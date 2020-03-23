#!/bin/bash
# inputs $1: project location

set -ex

source scripts/retry.sh

cd $1

if grep -q 'sdk: flutter' "./pubspec.yaml"; then
    flutter packages get
    #flutter format --set-exit-if-changed lib # mess up in my vscode windows, can't sure If needed
    flutter analyze --no-current-package lib

    if [[ -d "test" ]]; then
        #flutter format --set-exit-if-changed test
        flutter analyze --no-current-package test #
        flutter test --no-pub --coverage
    fi
fi

cd -