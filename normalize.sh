#!/usr/bin/env bash

SECONDS=0

inputdir=$1/*.wav
outputdir=$2

# create output folder
mkdir -p ${outputdir}

# normalization db
default=-0.1
db=${3-$default}


for file in ${inputdir}
do	
	outputfilename="$(basename $file)"
	sox  "${file}" ${outputdir}/"${outputfilename}" norm $db; 
done

ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"