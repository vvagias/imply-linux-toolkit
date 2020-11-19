# Welcome to Imply Linux Manager/Agent Toolkit

Setting up Manager must be done first.
Create an Instance and grab it's ip address

get your manager and agent urls here
https://imply.io/get-started

Now run

    ssh -i your.pem centos@ipaddress 'bash -s' < imply-linux-toolkit/imply-linux-manager-setup-headless.sh DOWNLOAD_URL

Once that finishes running you can navigate to http://ipaddress:9097 for cluster manager

First time user must create a new user

Now click create cluster and set any properties you wish

!!! Ensure that Schema field is set to imply_manager

run the following command with your <ipaddress> <your.pem> and CLUSTER_ID , NODE_TYPE, MANAGER_HOST(use internal ip to be safe) and the DOWNLOAD_URL(for the agent) 

    ssh -i your.pem centos@ipaddress 'bash -s' < imply-linux-toolkit/imply-linux-agent-setup-headless.sh CLUSTER_ID NODE_TYPE MANAGER_HOST DOWNLOAD_URL

if you are feeling nervous ... 

try the test script first on any of the nodes to make sure everything is connected and ready...

    ssh -i your.pem centos@ip 'bash -s' < test.sh CLUSTER_ID NODE_TYPE

imply-linux-agent-setup.sh is an interactive shell you can scp to all nodes and run manually if you prefer.
