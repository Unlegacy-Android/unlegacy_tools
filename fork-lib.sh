#!/bin/sh

AOSP=https://android.googlesource.com; SAUCE=~/android/$BRANCH
UA=Unlegacy-Android; GH=https://github.com; CANARY=build

cd $SAUCE && echo "Using $SAUCE" || echo "Using $PWD"

errout() { echo "$1"; exit 1; }

fetchtags() {
	git -C $1 fetch -qt $AOSP/platform/$1 $TRACK || \
	errout "Failed to get upstream tags in $1; exiting!"
}

fetchtags $CANARY && NEWTAG=`git -C $CANARY describe --tag FETCH_HEAD`

atoua() { echo android_`echo $1| tr / _`; }

forkcout() {
	git -C $1 fetch -qt $GH/$UA/`atoua $1` $BRANCH && \
	git -C $1 checkout -q FETCH_HEAD || \
	errout "Failed to get $BRANCH branch in $1; exiting!"
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
			errout "Rebase failed in $r; please fix!" && \
			PUSH_FORKS="$PUSH_FORKS $r"
		else
			echo "Seems like $r is rebased onto latest tag already."
		fi
	done
}

#GERRIT=gerrit.unlegacy-android.cf:29418; GUSER=???; UAG=ssh://$GUSER@$GERRIT/$UA
#Actually, better create a remote in ~/.ssh/config:
#Host uag
#    Port 29418
#    User ???
#    HostName gerrit.unlegacy-android.cf

pushforks() {
	prompterr "Really force push rebased HEADs to Gerrit?" "yes"
	for r in $PUSH_FORKS; do
		git -C $r push uag:$UA/`atoua $r` HEAD:refs/heads/$BRANCH -f
	done
}

forkstatus() {
	for r in $AOSP_FORKS; do
		git -C $r status -bs; echo $r
	done
}
