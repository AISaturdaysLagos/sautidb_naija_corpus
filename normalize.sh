#!/usr/bin/env bash

SECONDS=0
today=$(date +'%d%m%Y')

inputdir=$1/*.wav
outputdir=$2_normalized_${today}

# create output folder
mkdir -p ${outputdir}

# normalization db
db=-0.1

for file in ${inputdir}
do	
	outputfilename="$(basename $file)"
	sox  "${file}" ${outputdir}/"${outputfilename}" norm $db; 
done

ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"