#! /bin/bash

pool=jausoft_com
snap=20130920

zfs snapshot  $pool@$snap
zfs snapshot -r $pool@$snap
zfs snapshot -r $pool/data@$snap
zfs snapshot -r $pool/services@$snap
zfs snapshot -r $pool/system@$snap
zfs snapshot -r $pool/users@$snap
