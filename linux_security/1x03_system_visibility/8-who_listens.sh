#!/bin/bash
lsof -iTCP:$1 -sTCP:LISTEN | tail -1 | awk '{print $1}'
