today=$(date +'%d%m%Y')

bash_scripts=../bash_scripts

inputdir=sauti_webms
outputdir=sautidb_wavs_$today

### TODO: Implement error handling. Current solution found always exit the terminal but I would prefer a solution that doesn't do that

##################################################################################################
# CONVERT WEBM TO WAV 
##################################################################################################

. $bash_scripts/webm2wav.sh $inputdir $outputdir


##################################################################################################
# COPY NON-REJECTED AUDIO FILES TO NEW FOLDER
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

inputdir=sautidb_wavs_$today
outputdir=sautidb_reduced_$today
filenames=sautidb_filename.csv
# [[ ! -f $filenames ]] && echo "$filenames does not exist!"
# [[ ! -d $inputdir ]] && echo "$inputdir does not exist!" 

mkdir -p $outputdir
cat $filenames | xargs -I{} cp $inputdir/{} $outputdir

# Remove old folders for space
rm -rf $inputdir 

##################################################################################################
# NORMALIZE AUDIO SAMPLES
##################################################################################################
inputdir=sautidb_reduced_$today
outputdir=sautidb_normalize_$today
db=-0.1
. $bash_scripts/normalize.sh $inputdir $outputdir $db

# Remove old folders for space
rm -rf $inputdir 


##################################################################################################
# REMOVE LEADING AND TRAILING SILENCE
##################################################################################################
inputdir=sautidb_normalize_$today
outputdir=sautidb_nosilence_$today
. $bash_scripts/remove_leading_trailing_silence.sh $inputdir $outputdir


# Remove old folders for space
rm -rf $inputdir 


##################################################################################################
# RENAME AUDIO FILES TO FILENAME CONTAINING THE AUDIO METADATA INFORMATION 
##################################################################################################

inputdir=sautidb_nosilence_$today
outputdir=sautidb_released_$today
rename_filenames=sautidb_filename_newname.csv

mkdir -p $outputdir
sed 's/"//g' $rename_filenames | while IFS=, read orig new; do cp $inputdir/"$orig" $outputdir/"$new"; done

# Remove old folders for space
rm -rf $inputdir 
