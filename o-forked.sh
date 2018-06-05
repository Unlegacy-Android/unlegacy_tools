#!/bin/sh

FALLBR=aosp-8.0; BRANCH=aosp-8.1; TRACK=oreo-m4-s5-release

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
