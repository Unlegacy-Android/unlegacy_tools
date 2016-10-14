#!/bin/sh

FETCH=https://android.googlesource.com; CANARY=build
SAUCE=~/android/$BRANCH; cd $SAUCE	# or whatever location

fetchtags() {
	git -C $1 fetch -qt $FETCH/platform/$1 $TRACK
}

fetchtags $CANARY && NEWTAG=`git -C $CANARY describe --tag FETCH_HEAD`

findtags() {
	if [ !`git -C $1 branch --list $BRANCH` ]; then
		git -C $1 checkout -q $BRANCH && echo "Branch $BRANCH doesn't exist locally; creating it from remote"
	fi
	OLDTAG=`git -C $1 describe --tag --abbrev=0 $BRANCH`
}

findtags $CANARY

if [ "$NEWTAG" = "$OLDTAG" ]; then
	read -p "Seems like $CANARY is onto latest tag ($NEWTAG). Continue? (y/N) " prompt
	if [ "$prompt" != "y" ]; then
		exit 0
	fi
else
	read -p "Found $OLDTAG in $CANARY; newest is $NEWTAG. Continue? (y/N) " prompt
	if [ "$prompt" != "y" ]; then
		exit 0
	fi
fi

forkrebase() {
	for r in $AOSP_FORKS; do
		fetchtags $r; findtags $r
		if [ "$NEWTAG" != "$OLDTAG" ]; then
			echo "Rebasing $r onto $NEWTAG (from $OLDTAG)"
			git -C $r rebase --onto $NEWTAG $OLDTAG $BRANCH
		else
			echo "Seems like $r is rebased onto latest tag already."
		fi
	done
}

#GERRIT=gerrit.unlegacy-android.cf:29418; $USER=???
#Actually, better create a remote in ~/.ssh/config:
#Host ul
#    Port 29418
#    User ???
#    HostName gerrit.unlegacy-android.cf

PJROOT=Unlegacy-Android; #UA=ssh://$USER@$GERRIT/$PJROOT

forkpush() {
	for r in $AOSP_FORKS; do
		f=android_`echo $r| tr / _`; echo $f
		git -C $r push ul:$PJROOT/$f $BRANCH:refs/heads/$BRANCH -f
	done
}

forkstatus() {
	for r in $AOSP_FORKS; do
		git -C $r status -bs; echo $r
	done
}
