#!/bin/bash

set -x

sdir_0=`dirname $0`
sdir=`readlink -f $sdir_0`

prefix=$1
shift

if [ -z ${prefix} ] ; then
    echo "Usage $0 prefix"
    exit 1
fi

netstat -tuna | awk '{print $5}' | grep "^${prefix}\..*" | sort -n  2>&1 > abuse.raw.txt

${sdir}/net-count-subs.sh ${prefix} abuse.raw.txt
