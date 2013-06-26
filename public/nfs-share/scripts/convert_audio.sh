#!/bin/bash
user_id=$1
user_hash=$2

nfs_path_private="/home/ubuntu/Documents/prototype/private/nfs-share/"
nfs_path_public="/home/ubuntu/Documents/prototype/public/nfs-share/"

echo Make a copy of the original file
cp "$nfs_path_public"/"$user_id"/"$user_hash".wav "$nfs_path_private"/"$user_id"/"$user_id".wav.original

echo Adjust sample rate
sox "$nfs_path_private"/"$user_id"/"$user_id".wav.original -r 22050 "$nfs_path_private"/"$user_id"/"$user_id".wav

echo Adjust volume
sox -v 4.0 "$nfs_path_private"/"$user_id"/"$user_id".wav "$nfs_path_private"/"$user_id"/"$user_id".inc.wav
cp "$nfs_path_private"/"$user_id"/"$user_id".inc.wav "$nfs_path_private"/"$user_id"/"$user_id".wav

echo Combine two files
sox "$nfs_path_private"/"$user_id"/"$user_id".wav "$nfs_path_private"/sounds/buttons-merged.wav "$nfs_path_private"/"$user_id"/output.wav

echo Replace playable file with combined
mv "$nfs_path_private"/"$user_id"/output.wav "$nfs_path_private"/"$user_id"/$user_id.wav

echo Convert audio file to sln
sox "$nfs_path_private"/"$user_id"/"$user_id".inc.wav -t raw -r 8000 -s -2 -c 1 "$nfs_path_private"/"$user_id"/"$user_id".sln
rm -f "$nfs_path_private"/"$user_id"/"$user_id".inc.wav

echo Done

exit
