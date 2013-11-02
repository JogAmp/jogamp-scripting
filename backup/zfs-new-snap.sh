#! /bin/bash

#pool=jausoft_com
pool=jogamp_org
snap=20131102

zfs snapshot  $pool@$snap
zfs snapshot -r $pool/data@$snap
zfs snapshot -r $pool/services@$snap
zfs snapshot -r $pool/system@$snap
zfs snapshot -r $pool/users@$snap
