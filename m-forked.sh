#!/bin/sh

BRANCH=aosp-6.0; TRACK=marshmallow-mr3-release

AOSP_FORKS="build frameworks/av frameworks/native
			packages/apps/Camera2

. `dirname $0`/fork-lib.sh

forkrebase
