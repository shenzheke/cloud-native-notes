#!/bin/bash    #nfs1上执行
Path1="/backup/$(hostname -i)"
[ -f $Path1 ] || mkdir -p $Path1

cd $Path1 &&\
tar zcf conf_$(date +%F).tar.gz /var/spool/cron/root /etc/rc.local /server/scripts 2>/dev/null
tar zcf www_$(date +%F).tar.gz /var/html/www    #date + %F -d -1day
tar zcf logs_$(date +%F).tar.gz /app/logs

rsync -av /backup backup@172.16.1.41::backup --password-file=/etc/rsync.password

find /backp -type f -name "*.tar.gz" -mtime +7 |xargs rm -f
