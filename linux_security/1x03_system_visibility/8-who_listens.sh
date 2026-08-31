#!/bin/bash
lsof -iTCP:$1 | tail -1 | awk '{print $1}'
