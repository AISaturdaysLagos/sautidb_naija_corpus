#!/usr/bin/env bash

SECONDS=0

# input webms files
inputdir=$1/*.webm

# output wav files
outputdir=$2

mkdir -p ${outputdir}

for webmfile in ${inputdir}
do
	outputfilename="$(basename $webmfile)"
	ffmpeg -i "${webmfile}" -vn ${outputdir}/"${outputfilename%.*}.wav"; 
done

ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"