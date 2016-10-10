#!/bin/sh

TRACK=nougat-mr0.5-release
BRANCH=aosp-7.0; CANARY=build
FETCH=https://android.googlesource.com

SAUCE=~/android/$BRANCH; cd $SAUCE	# or whatever location

git -C $CANARY fetch -q $FETCH/platform/$CANARY $TRACK && \
NEWTAG=`git -C $CANARY describe --tag FETCH_HEAD`

findtags() {
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

AOSP_FORKS="build bionic system/core
			frameworks/av frameworks/base frameworks/native
			hardware/broadcom/wlan hardware/qcom/audio
			hardware/qcom/bt hardware/qcom/display
			hardware/qcom/gps hardware/qcom/keymaster
			hardware/qcom/media hardware/qcom/wlan"

forkrebase() {
	for r in $AOSP_FORKS; do
		findtags $r
		if [ "$NEWTAG" != "$OLDTAG" ]; then
			echo "Rebasing $r onto $NEWTAG (from $OLDTAG)"
			git -C $r rebase --onto $NEWTAG $OLDTAG $BRANCH
		else
			echo "Seems like $r is rebased onto latest tag already."
		fi
	done
}

forkrebase

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
