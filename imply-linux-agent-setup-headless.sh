#!/usr/bin/env bash
#ex
#ssh -i vvagias.pem centos@3.227.234.182 'bash -s' < /Users/vasilisvagias/Desktop/imply-linux-toolkit/imply-linux-agent-setup-headless.sh 26e44dab-25c5-4164-af23-3857a33bd190 master

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
#Imply Agent Install Shell
if [ "$1" != "" ]; then
    export CLUSTER_ID="$1"
    echo "cluster id is $1"
else
    echo "Positional parameter 1 cluster id is empty"
    exit
fi
if [ "$2" != "" ]; then
    export NODE_TYPE="$2"
    echo "node type (data,query,master) is $2"
else
    echo "Positional parameter 2 node type (data,query,master) is empty"
    exit
fi
if [ "$3" != "" ]; then
    export MANAGER_HOST="$3"
    echo "manager-host-ip is $3"
else
    echo "Positional parameter 3 manager-host-ip is empty"
    exit
fi
if [ "$3" != "" ]; then
    export DOWNLOAD_URL="$4"
    echo "agent-download-url is $4"
else
    echo "Positional parameter 4 agent-download-url is empty"
    exit
fi

echo "IMPLY_MANAGER_HOST=$MANAGER_HOST
IMPLY_MANAGER_AGENT_CLUSTER=$CLUSTER_ID
IMPLY_MANAGER_AGENT_NODE_TYPE=$NODE_TYPE" > agent.conf.tmp
echo "processed MANAGER_HOST => $MANAGER_HOST CLUSTER_ID => $CLUSTER_ID and NODE_TYPE => $NODE_TYPE"
sudo yum install wget -y
wget https://static.imply.io/release/imply-agent-4.0.0.tar.gz
sudo yum install java-1.8.0-openjdk -y
sudo yum install python3 -y
sudo yum install make -y
sudo yum install tar -y
sudo yum install perl -y
#curl -L http://xrl.us/installperlnix | bash
sudo yum update -y
update-crypto-policies --set LEGACY
tar -xvf imply-agent-4.0.0.tar.gz
yes yes| sudo imply-agent-4.0.0/script/install
sudo su
rm /etc/opt/imply/agent.conf
cp agent.conf.tmp /etc/opt/imply/agent.conf
chmod 777 /etc/opt/imply/agent.conf
#configure the settings
sudo systemctl start imply-agent
sleep 5
systemctl list-dependencies --reverse imply-agent
