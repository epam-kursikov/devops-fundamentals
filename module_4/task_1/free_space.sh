#!/bin/bash

declare -i threshold
declare -i default_threshold=100000

if [ -z "$1" ]
then
  threshold=$default_threshold
  echo min disk space threshold is not provided, default value of $threshold will be used. 
else
  threshold=$1
  echo min disk space threshold is set to $threshold. 
fi

declare -i available_space=$(df -m / --output=avail | tail -1)
if [ "$(($available_space))" -lt "$(($threshold))" ];
then
  echo You are running out of space, only $available_space MB left.
else
  echo All good, you still have $available_space MB left
fi
