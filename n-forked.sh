#!/bin/sh

TRACK=nougat-release
BRANCH=aosp-7.0; CANARY=build
FETCH=https://android.googlesource.com

SAUCE=~/android/$BRANCH; cd $SAUCE	# or whatever location

OLDTAG=`git -C $CANARY describe --tag aosp/$TRACK`
git -C $CANARY fetch $FETCH/platform/$CANARY $TRACK && \
NEWTAG=`git -C $CANARY describe --tag FETCH_HEAD`

# Show OLD/NEWTAG here & prompt to continue…

AOSP_FORKS="build bionic system/core
			frameworks/av frameworks/base frameworks/native
			hardware/broadcom/wlan hardware/qcom/audio
			hardware/qcom/bt hardware/qcom/display
			hardware/qcom/gps hardware/qcom/keymaster
			hardware/qcom/media hardware/qcom/wlan"

for r in $AOSP_FORKS
do
	echo $r
	git -C $r fetch $FETCH/platform/$r $TRACK && \
	git -C $r rebase --onto $NEWTAG $OLDTAG $BRANCH
done

GERRIT=gerrit.unlegacy-android.cf:29418
PJROOT=Unlegacy-Android; $USER=???
UA=ssh://$USER@$GERRIT/$PJROOT

forkpush() {
	for r in $AOSP_FORKS
	do
		f=android_`echo $r| tr / _`; echo $f
		git -C $r push $UA/$f $BRANCH:refs/heads/$BRANCH
	done
}

forkstatus() {
	for r in $AOSP_FORKS
	do
		git -C $r status -bs; echo $r
	done
}
