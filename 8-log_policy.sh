#!/bin/bash
chown :$2 $1 ; chmod 2750 $1 ; printf "$1/*.log {
    create 0640 root $2
}" > /etc/logrotate.d/app ; printf "$1/*.log {
    create 0640 root $2
}" > /etc/logrotate.d/app
