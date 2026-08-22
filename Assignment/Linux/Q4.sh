#!/bin/bash

mkdir -p DevOps
cd DevOps

touch testing
cp testing testing.bak

chmod 444 testing.bak

cat testing.bak