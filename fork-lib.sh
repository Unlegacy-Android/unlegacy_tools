#!/bin/sh

AOSP=https://android.googlesource.com; SAUCE=`cd ..;pwd`
UA=Unlegacy-Android; GH=https://github.com; CANARY=`echo $AOSP_FORKS| cut -d\  -f1`

cd $SAUCE && echo "Using $SAUCE" || echo "Using $PWD"

mexit() { echo "$1"; exit $2; }

fetchtags() {
	git -C $1 fetch -qt $AOSP/platform/${1%/make} $TRACK || \
	mexit "Failed to get upstream tags in $1; exiting!" 1
}

fetchtags $CANARY && NEWTAG=`git -C $CANARY describe --tag FETCH_HEAD`

atoua() { echo android_`echo ${1%/make}| tr / _`; }

forkcout() {
	git -C $1 fetch -qt $GH/$UA/`atoua $1` $BRANCH || \
	([ -z "$FALLBR" ] || git -C $1 fetch -qt $GH/$UA/`atoua $1` $FALLBR)

	[ $? -eq 0 ] && git -C $1 checkout -q FETCH_HEAD || \
	mexit "Failed to get $BRANCH branch in $1; exiting!" 1
}

oldtag() { forkcout $1 && OLDTAG=`git -C $1 describe --tag --abbrev=0 FETCH_HEAD`; }

oldtag $CANARY

prompterr() { read -p "$1 Continue? ($2/N) " prompt; [ "$prompt" = "$2" ] || exit 0; }

[ "$NEWTAG" != "$OLDTAG" ] && \
prompterr "Found $OLDTAG in $CANARY; newest is $NEWTAG." "y" || \
prompterr "Seems like $CANARY is already onto latest tag ($NEWTAG)." "y"

PUSH_FORKS=""

rebaseforks() {
	for r in $AOSP_FORKS; do
		fetchtags $r; oldtag $r
		if [ "$NEWTAG" != "$OLDTAG" ]; then
			echo "Rebasing $r onto $NEWTAG (from $OLDTAG)"
			git -C $r rebase --onto $NEWTAG $OLDTAG HEAD || \
			mexit "Rebase failed in $r; please fix!" 1 && \
			PUSH_FORKS="$PUSH_FORKS $r"
		else
			echo "Seems like $r is rebased onto latest tag already."
		fi
	done
}

#UAG=gerrit.unlegacy-android.cf:29418; $UAGER=???; GERRIT=ssh://$UAGER@$UAG/$UA

#Actually, better create a remote in ~/.ssh/config:
#Host uag
#    User ???
#    Port 29418
#    HostName gerrit.unlegacy-android.cf

GERRIT=uag:$UA

pushforks() {
	[ "$PUSH_FORKS" = "" ] && mexit "Nothing new to push!" 0 || \
	prompterr "Really force push rebased HEADs to Gerrit?" "yes"
	for r in $PUSH_FORKS; do
		git -C $r push $GERRIT/`atoua $r` HEAD:refs/heads/$BRANCH -f
	done
}

forkstatus() {
	for r in $AOSP_FORKS; do
		git -C $r status -bs; echo $r
	done
}
