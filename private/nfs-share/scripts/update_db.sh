#!/bin/bash
#Update inviteHistorys table this script will be trigered by ssh

EXPECTED_ARGS=3
E_BADARGS=-1

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` <user_id> <user_hash>"
  exit $E_BADARGS
fi

invite_id=$1
user_id=$2
answer=$3

#path="/var/www/prototype/db"
path="/home/ubuntu/Documents/prototype/db"

echo "Inserting $user_id $invite_id $answer"
sqlite3 "$path/development.sqlite3"  "UPDATE invite_histories SET arriving=$answer  WHERE id=$invite_id"
exit 0

