#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi

environment=$1

if tail -n 2 /tmp/server.log | grep -q "Application startup complete"; then
    echo "Application in $environment environment startup complete"
    exit 0
else
    echo "Application in $environment environment startup failed!"
    exit 1
fi