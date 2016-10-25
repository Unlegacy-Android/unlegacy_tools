#!/bin/sh

BRANCH=aosp-7.1; TRACK=nougat-dr1-release

AOSP_FORKS="build bionic system/core
			frameworks/av frameworks/native
			hardware/broadcom/wlan hardware/qcom/audio
			hardware/qcom/bt hardware/qcom/display
			hardware/qcom/gps hardware/qcom/keymaster
			hardware/qcom/media"

. `dirname $0`/fork-lib.sh

rebaseforks && pushforks
