#!/bin/bash
ifconfig | grep "inet " | awk '{print $2, $1}' | sed 's/ .*//'