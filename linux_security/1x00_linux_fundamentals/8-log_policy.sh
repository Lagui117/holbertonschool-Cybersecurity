#!/bin/bash
chown :$2 $1 ; chmod 2750 $1 ; printf "$1/*.log {\n    create 0640 root $2\n}" > /etc/logrotate.d/app
