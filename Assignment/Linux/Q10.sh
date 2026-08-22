#!/bin/bash
mkdir -p temp
i=1
until [ $i -gt 10 ]
do
    touch temp/file-$i
    i=$((i+1))
done
ls temp