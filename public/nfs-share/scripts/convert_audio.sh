#!/bin/bash
user_id=$1
nfs_path="./public/nfs-share"


echo "Merging audio files"
CMD="sox "$nfs_path"/sounds/confirm-press-one.wav "$nfs_path"/sounds/decline-press-two.wav "$nfs_path"/"$user_id"/buttons-merged.wav"
CMD="sox "$nfs_path"/"$user_id"/"$user_id".wav "$nfs_path"/"$user_id"/buttons-merged.wav output.wav"
CMD="mv "$nfs_path"/"$user_id"/output.wav "$nfs_path"/"$user_id"/"$user_id".wav"
CMD="rm "$nfs_path"/"$user_id"/output.wav -f" 
echo "Start converting audio file user_id: " $user_id
CMD="sox "$nfs_path"/"$user_id"/"$user_id".wav -t raw -r 8000 -s -2 -c 1 "$nfs_path"/"$user_id"/"$user_id".sln"
$CMD 
