#!/bin/sh

infile="$1"
awk '{ print $3; }' "$infile" | sort | uniq -c | sort
