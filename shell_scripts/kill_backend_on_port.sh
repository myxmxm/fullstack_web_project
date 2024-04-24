#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <port>"
    exit 1
fi

port=$1

pids=($(sudo ss -tulnp | awk -v port=":$port" '$5 ~ port {split($7, arr, ","); for (i in arr) {gsub(/[^0-9]/, "", arr[i]); print arr[i]}}' | sort -u | head -n 2))

if [ ${#pids[@]} -eq 0 ]; then
    echo "No processes found for port $port"
    exit 0
fi

for pid in ${pids[@]}; do
    echo $pid
    sudo kill -9 $pid
done

# Verify if all processes have been killed
all_killed=true
for pid in ${pids[@]}; do
    if ps -p $pid > /dev/null; then
        all_killed=false
        break
    fi
done

if [ "$all_killed" = true ]; then
    echo "All processes have been killed"
    exit 0
fi
