#!/usr/bin/env bash

SECONDS=0

# input wav files
inputdir=$1/*.wav

# output wav files
outputdir=$2

# samplerate 
default=48000
sr=${3-$default}

mkdir -p ${outputdir}

for file in ${inputdir}
do
	outputfilename="$(basename $file)"
	ffmpeg -i "${file}" -ar ${sr} ${outputdir}/"${outputfilename%.*}.wav"; 
done

ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"