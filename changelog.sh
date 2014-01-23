#!/bin/bash

# To run this, simply cd to the xenon folder and run: . build/changelog.sh :)

_now=$(date +"%m-%d-%Y")
_file=XenonChangelogs/$_now/Xenon-Changelog-$_now.log

mkdir -p XenonChangelogs/ && mkdir -p XenonChangelogs/$_now # && cd /home/kyler/Desktop/xenon/build/ &&

repo forall -pc git log --reverse --no-merges --since=1.day.ago >  $_file
