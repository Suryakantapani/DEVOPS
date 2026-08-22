#!/bin/bash
usage=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
echo "Disk Usage: $usage%"
if [ $usage -gt 80 ]
then
    echo "Critical"
else
    echo "Normal"
fi