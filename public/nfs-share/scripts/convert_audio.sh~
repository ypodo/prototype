#!/bin/bash
#param $1 is user_id
user_id=$1
nfs_path="/var/www/prototype/public/nfs-share"
nfs_path_dev="/home/ubuntu/Documents/prototype/public/nfs-share"

cp "$nfs_path_dev"/"$user_id"/"$user_id".wav "$nfs_path_dev"/"$user_id"/"$user_id".wav.original
echo "Merging audio files"
sox "$nfs_path_dev"/"$user_id"/"$user_id".wav "$nfs_path_dev"/sounds/buttons-merged.wav "$nfs_path_dev"/"$user_id"/output.wav
echo "Start converting audio file user_id: " $user_id
sox "$nfs_path_dev"/"$user_id"/output.wav -t raw -r 8000 -s -2 -c 1 "$nfs_path_dev"/"$user_id"/"$user_id".sln
mv "$nfs_path_dev"/"$user_id"/output.wav "$nfs_path_dev"/"$user_id"/$user_id.wav
