#!/bin/bash
apt-get install -y "$1"
sed -i 's/.*pam_pwquality.so.*/password requisite pam_pwquality.so retry=3 minlen=12 minclass=3/' "$2"
