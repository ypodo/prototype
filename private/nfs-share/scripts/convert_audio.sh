#!/bin/bash
user_id=$1

echo "Start converting audio dile user_id: " $user_id
CMD="sox ./public/nfs-share/"$user_id"/"$user_id".wav -t raw -r 8000 -s -2 -c 1 ./public/nfs-share/"$user_id"/"$user_id".sln"
$CMD 
