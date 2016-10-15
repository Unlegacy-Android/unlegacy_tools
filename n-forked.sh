#!/bin/sh

BRANCH=aosp-7.0; TRACK=nougat-mr0.5-release

AOSP_FORKS="build bionic system/core
			frameworks/av frameworks/base frameworks/native
			hardware/broadcom/wlan hardware/qcom/audio
			hardware/qcom/bt hardware/qcom/display
			hardware/qcom/gps hardware/qcom/keymaster
			hardware/qcom/media"

. `dirname $0`/fork-lib.sh

rebaseforks && pushforks
