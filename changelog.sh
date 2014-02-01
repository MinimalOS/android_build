#!/bin/bash

# To run this, simply cd to the xenon folder and run build/changelog.sh :)

_now=$(date +"%m-%d-%Y")
_file=build/XenonChangelogs/$_now/Xenon-Changelog-$_now.log

if [ -d XenonChangelogs ]; then
rm -rf XenonChangelogs
fi

if [ -d build/XenonChangelogs ];
mkdir -p build/XenonChangelogs/
fi

mkdir -p build/XenonChangelogs/$_now

chmod 777 -R build/XenonChangelogs

repo forall -pc git log --reverse --no-merges --since=1.day.ago >  $_file
