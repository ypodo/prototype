#!/bin/bash
#Update inviteHistorys table this script will be trigered by ssh
invite_id=$1
user_id=$2
answer=$3
path="/var/www/prototype/db"
path_dev="/home/ubuntu/Documents/prototype/db"

echo "Inserting $user_id $invite_id $answer"
sqlite3 "$path_dev/development.sqlite3"  "UPDATE invite_histories SET arriving=$answer  WHERE id=$invite_id"
exit 0