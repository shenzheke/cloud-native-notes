#!/bin/bash
cmd="/usr/bin/inotifywait"

$cmd -mrq --format '%w%f' -e close_write,delete /backup |\
while read line
do
	[! -e "$line" ] && cd /backup &&\
	rsync -az --delete ./ backup@backup::backup && continue
	rsync -az --delete $line backup@backup::backup
done  
