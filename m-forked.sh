#!/bin/sh

BRANCH=aosp-6.0; TRACK=marshmallow-mr2-release

AOSP_FORKS="build system/core
	frameworks/av frameworks/base frameworks/native
	packages/apps/Camera2"

. `dirname $0`/fork-lib.sh

rebaseforks && pushforks
