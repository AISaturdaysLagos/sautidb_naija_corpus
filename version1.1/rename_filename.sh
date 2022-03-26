inputdir=sautidb_v1
outputdir=sautidb_v1.1
rename_filenames=sautidb_v1_filename_rename_map.csv

mkdir -p $outputdir
sed 's/"//g' $rename_filenames | while IFS=, read orig new; do cp $inputdir/"$orig" $outputdir/"$new"; done
echo "done"