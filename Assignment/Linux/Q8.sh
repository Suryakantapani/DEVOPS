#!/bin/bash
empty=0
total=0
for file in AWS
do
    lines=$(cat "$file" | wc -l)
    echo "File: $file"
    if [ $lines -eq 0 ]
    then
        empty=$((empty+1))
    elif [ $lines -le 5 ]
    then
        echo "Short"
    else
        echo "Large"
    fi

    total=$((total+1))
done
echo "Total Files: $total"
echo "Empty Files: $empty"