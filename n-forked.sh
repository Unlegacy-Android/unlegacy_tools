#!/bin/sh

FALLBR=aosp-7.0; BRANCH=aosp-7.1; TRACK=nougat-mr1-release

AOSP_FORKS="build bionic system/core system/sepolicy
			frameworks/av frameworks/base frameworks/native
			hardware/broadcom/wlan hardware/qcom/audio
			hardware/qcom/bt hardware/qcom/display
			hardware/qcom/gps hardware/qcom/keymaster
			hardware/qcom/media"

. `dirname $0`/fork-lib.sh

rebaseforks && pushforks
