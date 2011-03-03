#!/bin/bash

function git-new-milestone() {
    local module="$1"
    local last="$2"
    local new="$3"

    if [ -z "$module" -o -z "$last" -o -z "$new" ] ; then
        echo "Usage: $0 module last-ref new-ref"
        exit 1
    fi

    echo "Module $module - Tag $new"
    git archive --format=tar --prefix=$module-$new/ $new | xz -z -9 > ../archive/$module-$new.tar.xz
    git archive --format=zip --prefix=$module-$new/ $new -o ../archive/$module-$new.zip
    git log --no-merges $new ^$last > ../archive/$module-ChangeLog-$new
    git shortlog --no-merges $new ^$last > ../archive/$module-ShortLog-$new
    git diff --stat --summary -M $last $new > ../archive/$module-diffstat-$new
}
