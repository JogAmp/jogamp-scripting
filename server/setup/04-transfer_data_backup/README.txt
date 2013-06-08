Initial backup from our non ZFS storage:
    Used rsync backup script: ../../../backup/rsync-jogamp2here.sh

ZFS send / receive ..
    On receiver:
        > zfs list
        ...
        pool/data/backup             22.2M  2.60T  22.1M  /data/backup
        pool/data/backup/jogamp.org   136K  2.60T   136K  /data/backup/jogamp.org
        ..

        > zfs set compression=gzip jausoft_com/data/backup
        > zfs get compression jausoft_com/data/backup
        jausoft_com/data/backup  compression  gzip      local

    On sender:
        test send:
            zfs send -Pvn -R -D tank/data@data_01 > /dev/null

        test receive:        
            zfs send -R -D tank/data@data_01 | ssh user@server.example.com "zfs receive -vn -u -d pool/data/backup/jogamp.org"

        the real thing ..
            zfs send -R -D tank/data@data_01 | ssh user@server.example.com "zfs receive -v -u -d pool/data/backup/jogamp.org"
            zfs inherit mountpoint pool/data/backup/jogamp.org/data
            zfs mount pool/data/backup/jogamp.org/data



