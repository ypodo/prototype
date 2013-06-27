#!/bin/bash
user_id=$1
#nfs_path="/var/www/prototype/public/nfs-share"
nfs_path="/home/ubuntu/Documents/prototype/public/nfs-share"

cp "$nfs_path"/"$user_id"/"$user_id".wav "$nfs_path"/"$user_id"/"$user_id".wav.original
echo "Merging audio files"
sox -v 4.0 "$nfs_path"/"$user_id"/"$user_id".wav.inc
mv "$nfs_path"/"$user_id"/"$user_id".wav.inc "$nfs_path"/"$user_id"/"$user_id".wav
sox "$nfs_path"/"$user_id"/"$user_id".wav "$nfs_path"/sounds/buttons-merged.wav "$nfs_path"/"$user_id"/output.wav
echo "Start converting audio file user_id: " $user_id
sox "$nfs_path"/"$user_id"/"$user_id".wav -t raw -r 8000 -s -2 -c 1 "$nfs_path"/"$user_id"/"$user_id".sln
mv "$nfs_path"/"$user_id"/output.wav "$nfs_path"/"$user_id"/$user_id.wav

