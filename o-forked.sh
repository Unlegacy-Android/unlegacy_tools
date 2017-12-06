#!/bin/sh

FALLBR=aosp-8.0; BRANCH=aosp-8.1; TRACK=oreo-mr1-release

AOSP_FORKS="build/make build/soong bionic
	hardware/interfaces hardware/ril
	system/bt system/core system/sepolicy
	frameworks/av frameworks/base frameworks/native
	hardware/broadcom/wlan hardware/qcom/audio
	hardware/qcom/bt hardware/qcom/display
	hardware/qcom/gps hardware/qcom/keymaster
	hardware/qcom/media"

. `dirname $0`/fork-lib.sh

rebaseforks && pushforks
