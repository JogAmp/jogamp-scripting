#! /bin/sh

git ls-files -s $* | awk '/120000/{print $4}'
