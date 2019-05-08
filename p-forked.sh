#!/bin/sh

BRANCH=aosp-9.0; TRACK=pie-qpr3-release

AOSP_FORKS="build/make build/soong bionic hardware/ril
	external/perfetto system/bt system/core system/sepolicy
	frameworks/av frameworks/base frameworks/native
	hardware/broadcom/wlan hardware/qcom/audio
	hardware/qcom/bt hardware/qcom/display
	hardware/qcom/gps hardware/qcom/keymaster
	hardware/qcom/media hardware/qcom/power"

. `dirname $0`/fork-lib.sh

rebaseforks && pushforks
