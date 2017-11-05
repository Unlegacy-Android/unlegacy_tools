#!/bin/bash
BRANCH=aosp-7.1
SAUCE=~/android/$BRANCH

ROOT="$SAUCE"
PATCHPATH="$SAUCE/rebase"
PATCHREPOS=(
    'build'
    'bionic'
    'system/core'
    'system/sepolicy'
    'frameworks/av'
    'frameworks/base'
    'frameworks/native'
    'hardware/broadcom/wlan'
    'hardware/qcom/audio'
    'hardware/qcom/bt'
    'hardware/qcom/display'
    'hardware/qcom/gps'
    'hardware/qcom/keymaster'
    'hardware/qcom/media'
)

for patches in "${PATCHREPOS[@]}"; do
    cd "${ROOT}/${patches}"
    git am --whitespace=nowarn "${PATCHPATH}/${patches}"/*
    cd "${ROOT}"
done
