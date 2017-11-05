#!/bin/bash
BRANCH=aosp-6.0
SAUCE=~/android/$BRANCH

ROOT="$SAUCE"
PATCHPATH="$SAUCE/rebase"
PATCHREPOS=(
    'build'
    'frameworks/av'
    'frameworks/base'
    'frameworks/native'
    'packages/apps/Camera2'
    'system/core'
)

for patches in "${PATCHREPOS[@]}"; do
    cd "${ROOT}/${patches}"
    git am --whitespace=nowarn "${PATCHPATH}/${patches}"/*
    cd "${ROOT}"
done
