#!/bin/bash

if [ -f data.txt ]
then
    echo "data.txt exists"
else
    touch data.txt
    echo "data.txt did not exist, so it was created"
fi