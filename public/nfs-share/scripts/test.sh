#!/bin/bash 
`env >> /tmp/env.txt`
`echo "$(whoami)" >> /tmp/env.txt`
`ruby /srv/nfs/scripts/ssh_db_update.rb >> /tmp/env.txt`
