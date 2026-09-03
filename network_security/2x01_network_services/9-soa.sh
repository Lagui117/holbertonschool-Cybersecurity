#!/bin/bash
dig "$1" SOA +short | awk '{print $1}'
