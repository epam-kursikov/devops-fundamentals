#!/bin/bash

if [ "$#" -lt 1 ];
then
  echo Specify what folders you want to monitor
  exit 0
fi

for folder in "$@"
do
  count=$(find "$folder" -type f | wc -l)
  echo $folder contains $count files
done
