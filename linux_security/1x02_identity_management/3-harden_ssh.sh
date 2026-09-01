#!/bin/bash
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' "$1"
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' "$1"
sed -i 's/PubkeyAuthentication no/PubkeyAuthentication yes/' "$1"
sshd -t && service ssh restart
