#!/usr/bin/env bash
#ex
#ssh -i vvagias.pem centos@54.166.245.254 'bash -s' < /Users/vasilisvagias/Desktop/imply-linux-toolkit/imply-linux-manager-setup-headless.sh CLUSTER_ID NODE_TYPE

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
    export DOWNLOAD_URL="$1"
    echo "download url is $1"
else
    echo "Positional parameter 1 download url is empty"
    exit
fi


#manager NEW
sudo yum install wget -y
wget $DOWNLOAD_URL
sudo yum install java-1.8.0-openjdk -y
sudo yum install python3 -y
sudo yum install make -y
sudo yum install perl -y
sudo yum install tar -y
#curl -L http://xrl.us/installperlnix | bash
tar -xvf imply-manager-4.0.0.tar.gz
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
update-crypto-policies --set LEGACY
sudo yum update -y
sudo yum install mysql-server -y
sudo systemctl start mysqld
sudo service mysqld start
mysqladmin -u root password passed
mysql -h "localhost" -u "root" "-ppassed" -e  "CREATE DATABASE \`imply_manager\`;"
#SHOW GRANTS FOR 'root'@'localhost';
mysql -h "localhost" -u "root" "-ppassed" -e  "CREATE USER 'root'@'%' IDENTIFIED BY 'passed';"
#mysql -h "localhost" -u "root" "-ppassed" -e  "SHOW GRANTS FOR 'root'@'*';"
mysql -h "localhost" -u "root" "-ppassed" -e  "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';"
wget https://downloads.apache.org/kafka/2.6.0/kafka_2.13-2.6.0.tgz
tar -xzf kafka_2.13-2.6.0.tgz
cd kafka_2.13-2.6.0
nohup bin/zookeeper-server-start.sh config/zookeeper.properties &
cd ..
sudo imply-manager-4.0.0/script/install
sudo chmod 777 /etc/opt/imply/manager.conf
sudo rm /etc/opt/imply/manager.conf
sudo echo "IMPLY_MANAGER_LICENSE_KEY=
IMPLY_MANAGER_STORE_TYPE=mysql
IMPLY_MANAGER_STORE_HOST=$HOSTNAME
IMPLY_MANAGER_STORE_PORT=3306
IMPLY_MANAGER_STORE_USER=root
IMPLY_MANAGER_STORE_PASSWORD=passed
IMPLY_MANAGER_STORE_DATABASE=imply_manager

imply_defaults_zkType=external
imply_defaults_zkHosts=$HOSTNAME:2181
imply_defaults_zkBasePath=imply
imply_defaults_metadataStorageType=mysql
imply_defaults_metadataStorageHost=$HOSTNAME
imply_defaults_metadataStoragePort=3306
imply_defaults_metadataStorageUser=root
imply_defaults_metadataStoragePassword=passed
imply_defaults_deepStorageType=local
imply_defaults_deepStorageBaseLocation=var/druid/segments
" > manager.conf.tmp
sudo cp manager.conf.tmp /etc/opt/imply/manager.conf
sudo chmod 744 /etc/opt/imply/manager.conf
sudo systemctl start imply-manager
sleep 5
systemctl list-dependencies --reverse imply-manager
exit
