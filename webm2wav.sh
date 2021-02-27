#!/usr/bin/env bash

SECONDS=0
today=$(date +'%d%m%Y')

# input webms files
inputdir=$1/*.webm

# output wav files
outputdir=$2_wavs_$today

mkdir -p ${outputdir}

for webmfile in ${inputdir}
do
	outputfilename="$(basename $webmfile)"
	ffmpeg -i "${webmfile}" -vn ${outputdir}/"${outputfilename%.*}.wav"; 
done

ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"