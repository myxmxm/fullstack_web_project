#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <port>"
    exit 1
fi

port=$1

# pids=($(sudo ss -tulnp | awk -v port=":$port" '$5 ~ port {split($7, arr, ","); for (i in arr) {gsub(/[^0-9]/, "", arr[i]); print arr[i]}}' | sort -u | head -n 2))
pids=($(ss -tulnp | grep :$port | awk '{print $7}' | grep -oP '(?<=pid=)[0-9]+'))

if [ ${#pids[@]} -eq 0 ]; then
    echo "No processes found for port $port"
    exit 0
fi

for pid in ${pids[@]}; do
    echo $pid
    sudo kill -9 $pid
done

echo "All processes have been killed"
exit 0
