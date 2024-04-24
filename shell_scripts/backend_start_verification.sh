#!/bin/bash

if tail -n 2 /tmp/server.log | grep -q "Application startup complete"; then
    echo "Application startup complete"
    exit 0
else
    echo "Application startup not complete"
    exit 1
fi