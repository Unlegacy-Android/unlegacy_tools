#!/bin/sh

BRANCH=aosp-8.0; TRACK=oreo-release

AOSP_FORKS="build/make build/soong bionic
	system/bt system/core system/sepolicy
	frameworks/av frameworks/base frameworks/native
	hardware/broadcom/wlan hardware/qcom/audio
	hardware/qcom/bt hardware/qcom/display
	hardware/qcom/gps hardware/qcom/keymaster
	hardware/qcom/media hardware/ril"

. `dirname $0`/fork-lib.sh

rebaseforks && pushforks
