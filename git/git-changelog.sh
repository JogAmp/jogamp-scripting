#!/bin/bash

module="$1"
last="$2"
new="$3"

if [ -z "$module" -o -z "$last" -o -z "$new" ] ; then
    echo "Usage: $0 module last-ref new-ref"
    exit 1
fi

echo "Module $module - Tag $new"
#echo "git archive --prefix=$module-$new/ $new | lzma -9 > ../$module-$new.tar.lzma"
git log --no-merges $new ^$last > ../$module-ChangeLog-$new
git shortlog --no-merges $new ^$last > ../$module-ShortLog
git diff --stat --summary -M $last $new > ../$module-diffstat-$new
