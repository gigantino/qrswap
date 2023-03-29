#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Error: input file not specified"
  exit 1
fi

inputfile="$1"

if [ ! -f "$inputfile" ]; then
  echo "Error: input file not found"
  exit 1
fi

timestamp=$(date +"%d-%m-%Y-%H-%M-%S")
outputfolder="output-$timestamp"

mkdir "$outputfolder"

chunk_size=1000
prefix="image"

base64 "$inputfile" | split -b "$chunk_size" - "$outputfolder/$prefix" && \
  for f in "$outputfolder/$prefix"*
  do
    qrencode -o "$f.png" < "$f"
    rm "$f"
  done

cd "$outputfolder"
i=1
for f in *.png
do
  mv "$f" "$i.png"
  i=$((i+1))
done

