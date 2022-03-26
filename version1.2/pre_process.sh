today=$(date +'%d%m%Y')

bash_scripts=../bash_scripts

##################################################################################################
# COPY NON-REJECTED AUDIO FILES TO OUTPUT DIR FOLDER
##################################################################################################

# files were rejected based on the following as noted by Iroro Orife and Tejumade Afonja
# (1) Repetition of words, stuttering or self-editing during reading
# (2) Distortion on speech (from codec or other elements of the recording chain)
# (3) Transient distortion (clicks/pops), whistling sounds, non-stationary noise in the background
# (4) Breathing or turbulent noise on microphone, proximity effect on microphone
# (5) Audio gating effect on the microphone/recording-software
# (6) Singing or loud discussion in the background
# (7) Muffled or unintelligible speech
# (8) Very very quiet audio samples (this might not normalize well)
# (9) Cut off words or incomplete sentences or invented sentences or adding rhetorics
# (10) Noise immediately the microphone opens (this is an indication of a very noisy and potentially unusable file)
# (11) Nationality (we only considered Nigerians)


outputdir=sautidb_hausa
filenames=sautidb_hausa_filename.csv
mkdir -p ${outputdir}
cat ${filenames} | xargs -I{} gsutil cp gs://accent-db-48c9b.appspot.com/{} ${outputdir}

##################################################################################################
# RESAMPLE AUDIO SAMPLES
##################################################################################################
inputdir=sautidb_hausa
outputdir=sautidb_hausa_resample_${today}
sr=48000
. ${bash_scripts}/resample.sh $inputdir ${outputdir} $sr

# Remove old folders for space
# rm -rf ${inputdir} 

##################################################################################################
# NORMALIZE AUDIO SAMPLES
##################################################################################################
inputdir=sautidb_hausa_resample_${today}
outputdir=sautidb_hausa_normalize_${today}
db=-0.1
. ${bash_scripts}/normalize.sh ${inputdir} ${outputdir} ${db}

# Remove old folders for space
rm -rf ${inputdir} 


##################################################################################################
# REMOVE LEADING AND TRAILING SILENCE
##################################################################################################
inputdir=sautidb_hausa_normalize_${today}
outputdir=sautidb_hausa_nosilence_${today}
. ${bash_scripts}/remove_leading_trailing_silence.sh ${inputdir} $outputdir


# Remove old folders for space
rm -rf ${inputdir} 


##################################################################################################
# RENAME AUDIO FILES TO FILENAME CONTAINING THE AUDIO METADATA INFORMATION 
##################################################################################################

inputdir=sautidb_hausa_nosilence_${today}
outputdir=sautidb_hausa_released_${today}
rename_filenames=sautidb_hausa_${today}_filename_newname.csv

mkdir -p ${outputdir}
sed 's/"//g' ${rename_filenames} | while IFS=, read orig new; do cp ${inputdir}/"$orig" ${outputdir}/"$new"; done

echo "indir: ${inputdir%/*} --> outdir: $outputdir"
echo "Done! Elapsed time: $ELAPSED"
# Remove old folders for space
rm -rf ${inputdir} 

##################################################################################################
# MAKE V1.2 FOLDER, COPY SAUTIDB-NAIJA V1.1 DATA AND NEWLY RELEASED HAUSA DATA INTO THIS NEW FOLDER
# WE NOW HAVE 1137 SAMPLES 🎉🎉🎉
##################################################################################################

old_version="../data/sautidb_v1.1"
new_version="../data/sautidb_v1.2"
mkdir -p ${new_version}

cp -rf ${old_version}/* ${new_version}
cp -rf ${outputdir}/* ${new_version}

echo "indir: ${old_version%/*} --> outdir: $new_version"
echo "Done! Elapsed time: $ELAPSED"
echo "done! 🎉🎉🎉"