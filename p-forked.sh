#!/bin/sh

BRANCH=aosp-9.0; TRACK=pie-release

AOSP_FORKS="build/make build/soong bionic
	hardware/interfaces hardware/ril
	system/bt system/core system/nfc system/sepolicy
	frameworks/av frameworks/base frameworks/native
	hardware/broadcom/wlan hardware/qcom/audio
	hardware/qcom/bt hardware/qcom/display
	hardware/qcom/gps hardware/qcom/keymaster
	hardware/qcom/media hardware/qcom/power"

. `dirname $0`/fork-lib.sh

rebaseforks && pushforks
