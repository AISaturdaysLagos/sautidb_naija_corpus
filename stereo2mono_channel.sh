#!/usr/bin/env bash

SECONDS=0
today=$(date +'%d%m%Y')

inputdir=$1/*.wav
outputdir=$2_mono_${today}

# create output folder
mkdir -p ${outputdir}

# convert all files in the inputdir to 1 channel
for file in ${inputdir}
do	
	outputfilename="$(basename $file)"
	sox  "${file}" -c 1  ${outputdir}/"${outputfilename}"; 
done

ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"
