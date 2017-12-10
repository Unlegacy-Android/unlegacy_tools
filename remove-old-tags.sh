#!/bin/bash

SOURCE_DIR=~/android/aosp-6.0

#repo sync -d -c -q --force-sync --jobs=8

function delete_old_tag {
local IFS=$'\n'
REPOS=$(repo list)
for repo in $REPOS; do
	path=$(echo $repo | cut -d':' -f1 | tr -d ' ')
	name=$(echo $repo | cut -d':' -f2 | tr -d ' ')

	if [[ $name == *"android_"* ]]; then
		cd $SOURCE_DIR/$path
		if git config remote.android-security.url > /dev/null; then
			echo "$name"
			echo "$path"
			git push --delete android-security android-6.0.1_r79
			git push --delete android-security android-6.0.1_r80
			git push --delete android-security android-7.1.2_r32
		fi
		cd $SOURCE_DIR
	fi
done
}

delete_old_tag
