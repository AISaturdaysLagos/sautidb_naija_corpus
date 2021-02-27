#!/usr/bin/env bash

SECONDS=0
today=$(date +'%d%m%Y')

inputdir=$1/*.wav
outputdir=$2_mono_${today}

# create output folder
mkdir -p ${outputdir}

# convert all wavefiles in the inputdir to 1 channel
for wavfile in ${inputdir}
do	
	outputfilename="$(basename $wavfile)"
	sox  "${wavfile}" -c 1  ${outputdir}/"${outputfilename}"; 
done

ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"
