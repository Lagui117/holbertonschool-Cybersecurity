#!/bin/bash
awk '/dhcp-server-identifier/{print $NF}' /var/lib/dhcp/dhclient.leases | tail -1 | tr -d ';'
