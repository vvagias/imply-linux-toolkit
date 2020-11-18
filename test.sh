#!/usr/bin/env bash

##### Constants

TITLE="System Information for $HOSTNAME"
RIGHT_NOW="$(date +"%x %r %Z")"
TIME_STAMP="Updated on $RIGHT_NOW by $USER"

##### Functions

system_info()
{
    echo "<h2>System release info</h2>"
    echo "<p>Function not yet implemented</p>"

}   # end of system_info


show_uptime()
{
    echo "<h2>System uptime</h2>"
    echo "<pre>"
    uptime
    echo "</pre>"

}   # end of show_uptime


drive_space()
{
    echo "<h2>Filesystem space</h2>"
    echo "<pre>"
    df
    echo "</pre>"

}   # end of drive_space


home_space()
{
    # Only the superuser can get this information

    if [ "$(id -u)" = "0" ]; then
        echo "<h2>Home directory space by user</h2>"
        echo "<pre>"
        echo "Bytes Directory"
        du -s /home/* | sort -nr
        echo "</pre>"
    fi

}   # end of home_space



##### Main
cat << "EOF"
_____                   _                __
|_   _|                 | |         ______\ \
 | |  _ __ ___   _ __  | | _   _  |______|\ \
 | | | '_ ` _ \ | '_ \ | || | | |  ______  > >
_| |_| | | | | || |_) || || |_| | |______|/ /
\___/|_| |_| |_|| .__/ |_| \__, |        /_/
_      _        | |         __/ |
| |    (_)       |_|        |___/
| |     _  _ __   _   _ __  __
| |    | || '_ \ | | | |\ \/ /
| |____| || | | || |_| | >  <
\_____/|_||_| |_| \__,_|/_/\_\


EOF
#!/bin/bash

if [ "$1" != "" ]; then
    export CLUSTER_ID="$1"
else
    echo "Positional parameter 1 is empty"
    exit
fi
if [ "$2" != "" ]; then
    export NODE_TYPE="$2"
else
    echo "Positional parameter 2 is empty"
    exit

fi
if [ "$3" != "" ]; then
    export MANAGER_HOST="$3"
    echo "Positional parameter 3 is $3"
else
    echo "Positional parameter 3 is empty"
    exit
fi
read -p "Enter name of your imply_manager Cluster ID [$CLUSTER_ID] > " clusterid
export CLUSTER_ID="$clusterid"
read -p "Enter node type [$NODE_TYPE] > " nodetype
export NODE_TYPE="$nodetype"

echo "IMPLY_MANAGER_HOST=$MANAGER_HOST
IMPLY_MANAGER_AGENT_CLUSTER=$CLUSTER_ID
IMPLY_MANAGER_AGENT_NODE_TYPE=$NODE_TYPE" > agent.conf.tmp
echo "processed MANAGER_HOST => $MANAGER_HOST CLUSTER_ID => $CLUSTER_ID and NODE_TYPE => $NODE_TYPE"


cat <<- _EOF_
  <html>
  <head>
      <title>$TITLE</title>
  </head>
  <body>
      <h1>$TITLE</h1>
      <p>$TIME_STAMP</p>
      $(system_info)
      $(show_uptime)
      $(drive_space)
      $(home_space)
      <h2>$CLUSTER_ID</h2>
      <h3>$NODE_TYPE</h3>
  </body>
  </html>
_EOF_
