#!/bin/bash
dig "$1" +trace | grep -m1 'root-servers.net' | awk '{print $5}'
