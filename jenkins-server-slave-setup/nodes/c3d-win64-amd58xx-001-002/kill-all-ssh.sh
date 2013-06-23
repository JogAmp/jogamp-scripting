#! /bin/sh

for i in `ps ax | grep ssh | awk ' { print $1 } ' `  ; do kill $i ; done
