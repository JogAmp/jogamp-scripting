#!/bin/sh

infile="$1"
awk '{ print $1; }' "$infile" | sort | uniq -c | sort
