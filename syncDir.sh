#!/bin/bash

# Author: Vivek Sah
#
# Watches a directory for changes and commits any new files or file changes to remote github repo
# Intended for MacOS
# Prereq: the directory to watch needs to be a git repo, also need to have fswatch 
# To install : brew install fswatch
# Features:
# - Handles space in filenames
# - file deletions

function main() {
  if [ "$#" -ne 1 ]; then
      printf "ERROR: Illegal number of parameters\n Usage: ./syncBlogPosts {DIRECTORY_TO_WATCH}\n"
      exit 1
  fi

  DIR_TO_WATCH=$1

  # Check if fswatch installed
  [ -x "$(command -v fswatch)" ] ||  { printf "Error: fswatch is not installed. Execute: \n \t brew install fswatch \n to install\n"; exit 1; }

  # Check if directory is git repo
  [ -d "$DIR_TO_WATCH/.git" ] || { printf "Directory %s is not a git repo." "DIR_TO_WATCH"; exit 1; }

  # Watch
  fswatch -e ".*" -i "\\.md$" -0 "$DIR_TO_WATCH" | while read -d "" 
  do 
      # check any untracked files
      git ls-files --others --exclude-standard |  while read -r file 
      do
        git add "$file"
        git commit -m "Added $file"
      done

      #check any modified files
      git ls-files --modified | while read -r file
      do
        git add "$file"
        git commit -m "Modified $file"
      done

      # Push changes
      git push origin master
  done
}

main "$@"