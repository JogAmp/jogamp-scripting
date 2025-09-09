#!/bin/bash

prefix=$1
shift
list=$1
shift

if [ ! -f ${list} ] || [ -z ${prefix} ] ; then
    echo "Usage $0 prefix file"
    exit 1
fi

tmpfile1="$(mktemp)" || exit 1
tmpfile2="$(mktemp)" || exit 1

do_count() {
    for ((i = 0 ; i < 256 ; i++)); do
        mask="^${prefix}.${i}."
        netmask="${prefix}.${i}.0.0/16"
        got=0
        grep ${mask} ${list} 2> /dev/null > ${tmpfile1} && got=1
        if [ ${got} -eq 1 ] ; then
            num=`cat ${tmpfile1} | wc -l`
            echo "${num} ${netmask}"
        fi
    done
}

do_count | sort -h > ${tmpfile2}
cat ${tmpfile2}
cat ${tmpfile2} | awk '{ print $2 }'
