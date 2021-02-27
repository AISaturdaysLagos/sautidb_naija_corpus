#!/usr/bin/env bash

SECONDS=0

inputdir=$1/*.wav
outputdir=$2_no_silence_${today}

# create output folder
mkdir -p ${outputdir}

for file in ${inputdir}
do	
	outputfilename="$(basename $file)"

	# (a) silence 1 441 3% : Remove silence at the beginning until at least 441 samples above 3% of the max level are detected
	# (b) reverse silence 1 441 0.1% reverse: Reverse the samples and repeate (a) with 0.1% of the max level, then reverse samples back 
	# I reduced reverse threshold to 0.1% to reduce the abrupt end in sentence that I observed when the threshold was set to 3%

	sox  "${file}" ${outputdir}/"${outputfilename}" silence 1 441 3% reverse silence 1 441 0.1% reverse; 
done


ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"