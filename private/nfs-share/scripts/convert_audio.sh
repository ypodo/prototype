#!/bin/bash
user_id=$1
user_hash=$2

EXPECTED_ARGS=2
E_BADARGS=-1

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` <user_id> <user_hash>"
  exit $E_BADARGS
fi

#nfs_path_private="/var/www/prototype/private/nfs-share"
#nfs_path_public="/var/www/prototype/public/nfs-share"

nfs_path_private="/home/ubuntu/Documents/prototype/private/nfs-share/"
nfs_path_public="/home/ubuntu/Documents/prototype/public/nfs-share/"


if [ ! -f "$nfs_path_public"/"$user_id"/"$user_hash".wav ]; then
    echo "File not found!"
	exit $E_BADARGS
fi



echo Make a copy of the original file
cp "$nfs_path_public"/"$user_id"/"$user_hash".wav "$nfs_path_private"/"$user_id"/"$user_id".wav.original
cp "$nfs_path_private"/"$user_id"/"$user_id".wav.original "$nfs_path_private"/"$user_id"/"$user_id".wav

#echo Adjust sample rate
#sox "$nfs_path_private"/"$user_id"/"$user_id".wav.original -r 22050 "$nfs_path_private"/"$user_id"/"$user_id".wav

echo Add 1 second silence at the end of file
sox "$nfs_path_private"/"$user_id"/"$user_id".wav "$nfs_path_private"/"$user_id"/"$user_id".sil.wav pad 0 1

echo Adjust volume
sox -v 2.0 "$nfs_path_private"/"$user_id"/"$user_id".sil.wav "$nfs_path_private"/"$user_id"/"$user_id".inc.wav
cp "$nfs_path_private"/"$user_id"/"$user_id".inc.wav "$nfs_path_private"/"$user_id"/"$user_id".wav

echo Combine two files
sox "$nfs_path_private"/"$user_id"/"$user_id".wav "$nfs_path_private"/sounds/buttons-merged.wav "$nfs_path_private"/"$user_id"/output.wav

echo Replace playable file with combined
mv "$nfs_path_private"/"$user_id"/output.wav "$nfs_path_public"/"$user_id"/"$user_hash".wav

echo Convert audio file to sln
sox "$nfs_path_private"/"$user_id"/"$user_id".inc.wav -t raw -r 8000 -s -2 -c 1 "$nfs_path_private"/"$user_id"/"$user_id".sln
rm -f "$nfs_path_private"/"$user_id"/"$user_id".inc.wav

echo Done

exit 0
