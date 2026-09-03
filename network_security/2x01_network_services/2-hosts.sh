#!/bin/bash
awk '/localhost/{print $1}' /etc/hosts
