#!/bin/bash


if [ $# -ne 1 ]; then
    echo "Usage: $0 <port>"
    exit 1
fi

port=$1

pids=($(sudo ss -tulnp | awk -v port=":$port" '$5 ~ port {split($7, arr, ","); for (i in arr) {gsub(/[^0-9]*/, "", arr[i]); if (arr[i] != 3) print arr[i]}}' | sort -u))


for pid in ${pids[@]}; do
    echo $pid
    sudo kill 9 $pid
done