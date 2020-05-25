#!/bin/bash

# A simple bash script which will be used by Typora to upload pics to github and returns url of uploaded pics to Typora which Typora will 
# substitute in the markdown file

# Expected behavior: Drag/drop a pic into Typora editor; the editor invokes this script and adds a hyperlink to the images in the markdown.

# Prereq: need a github repo to store the pics and a local repo

LOCAL_PICS_REPO_PATH='~/repos/screenshots/'
BASE_DOWNLOAD_LINK='https://raw.githubusercontent.com/vksah32/screenshots/master/'

# Uploads multiple files at a time
function main () {
	if [ "$#" -eq 0 ]; then
    	echo "Please specify at least one file\n"
		return 1
	fi

	cd $LOCAL_PICS_REPO_PATH
	# go through all pics, move them to screenshots repo
	for file in "$@"
	do
  		add_to_repo_and_upload $file		 				 
	done
	return 0
}

function add_to_repo_and_upload () {
	mv $1 ./
	filename=`basename $1`
	# replace space in filenames with underscores
	newfilename="${filename// /_}" 
	mv "$filenamme"  "$newfilenamme"
	printf "new filename is ${newfilename}"
	git add .
	git commit -m "Add ${newfilename}"
	git push origin master
	printf "${BASE_DOWNLOAD_LINK}/${newfilename}\n"
}

#execute main
main "$@"