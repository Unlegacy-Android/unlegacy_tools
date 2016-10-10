#!/bin/sh

BRANCH=aosp-6.0; TRACK=marshmallow-mr3-release

AOSP_FORKS="build bionic system/core
			frameworks/av frameworks/base frameworks/native
			hardware/broadcom/wlan hardware/qcom/audio
			hardware/qcom/bt hardware/qcom/display
			hardware/qcom/gps hardware/qcom/keymaster
			hardware/qcom/media hardware/qcom/wlan"

. `dirname $0`/fork-lib.sh

forkrebase
