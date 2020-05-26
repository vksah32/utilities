#!/bin/bash

# A simple bash script which will be used by Typora to upload pics to github and returns url of uploaded pics to Typora which Typora will 
# substitute in the markdown file

# Expected behavior: Drag/drop a pic into Typora editor; the editor invokes this script and adds a hyperlink to the images in the markdown.

# Prereq: need a github repo to store the pics and a local repo

LOCAL_PICS_REPO_PATH='/Users/viveks/repos/screenshots'
BASE_DOWNLOAD_LINK='https://raw.githubusercontent.com/vksah32/screenshots/master'

# Uploads multiple files at a time
function main () {
	if [ "$#" -eq 0 ]; then
    	printf "Please specify at least one file\n"
		exit 1
	fi

	
	# go through all pics, move them to screenshots repo
	for file in "$@"
	do
		# printf "Processing %s\n" "$file"
  		if  ! add_to_repo_and_upload "$file"; then 
  			# printf "Successfully processed %s\n" "$file"
		
			# printf "Failed processing %s\n" "$file"
			exit 1
  		fi		 				 
	done
	exit 0
}

function add_to_repo_and_upload () {
	[ -f "$1" ] || return 
	CURRENT_DIR=$(pwd)
	mv "$1" $LOCAL_PICS_REPO_PATH || return
	cd $LOCAL_PICS_REPO_PATH ||  return
	filename=$(basename "$1")
	# replace space in filenames with underscores
	newfilename="${filename// /_}" 
	mv "$filename"  "$newfilename"
	# printf "new filename is %s\n" "$newfilename"
	git add .  > /dev/null 2>&1
	git commit -m "Add ${newfilename}"  > /dev/null 2>&1
	git push origin master > /dev/null 2>&1
	printf "%s/%s\n" "$BASE_DOWNLOAD_LINK" "$newfilename"
	cd "$CURRENT_DIR" || return
	
}

#execute main
main "$@"