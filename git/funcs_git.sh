#!/bin/bash

function git-new-milestone() {
    local module="$1"
    local last="$2"
    local new="$3"

    if [ -z "$module" -o -z "$last" -o -z "$new" ] ; then
        echo "Usage: $0 module last-ref new-ref"
        exit 1
    fi

    mkdir -p ../archive/$new/Sources
    mkdir -p ../archive/$new/ChangeLogs

    echo "Module $module - Tag $new"
#   git archive --format=tar --prefix=$module-$new/ $new | 7z a -si ../archive/$new/Sources/$module-$new.tar.7z
    git archive --format=tar --prefix=$module-$new/ $new | xz -z -9 > ../archive/$new/Sources/$module-$new.tar.xz
#   git archive --format=zip --prefix=$module-$new/ $new -o ../archive/$new/Sources/$module-$new.zip
    git log --no-merges $new ^$last > ../archive/$new/ChangeLogs/$module-ChangeLog-$new.txt
    git shortlog --no-merges $new ^$last > ../archive/$new/ChangeLogs/$module-ShortLog-$new.txt
    git diff --stat --summary -M $last $new > ../archive/$new/ChangeLogs/$module-diffstat-$new.txt
}
