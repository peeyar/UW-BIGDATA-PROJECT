#!/bin/bash
echo -e "=========================================================================================================\n"
echo -e "Make sure you do these first:"
echo -e "\t1> Create two files:"
echo -e "\t\t cluster-hosts.txt with just the ips of the cluster nodes"
echo -e "\t\t hosts file that will go in /etc/hosts."
echo -e "\n\t2> Make sure wget is installed"
echo -e "\t3> Create ssh keys. Use 'parallelCopyKeys.sh cluster-hosts.txt [path/to/key]' to copy to cluster nodes"
echo -e "\t4> Install pssh from https://code.google.com/p/parallel-ssh/ on the manager node"
echo -e "\t5> Run 'preInstallCheckCentos.sh > preInstall.log' and look at the log output"
echo -e "=========================================================================================================\n"
read -p "Has all this been done [y/N]: " confirm
confirm=${confirm:-n}
echo    # (optional) move to a new line
if [[ $confirm =~ ^[Yy]$ ]]
then
    echo "Copying prepareNodes.sh to nodes"
	#parallel-scp -l ec2-user -h cluster-hosts.txt -x "-oStrictHostKeyChecking=no -i /home/dave/keys/dpatton-1.pem" prepareNodes.sh /home/ec2-user/prepareNodes.sh
	pscp -v -l root -h cluster-hosts.txt -x " -oStrictHostKeyChecking=no -i keys/id_rsa" prepareNode.sh /root/prepareNodes.sh

	echo "Starting prepareNodes on each node"
	#parallel-ssh -t 0 -i -l ec2-user -h cluster-hosts.txt -x "-t -t -oStrictHostKeyChecking=no -i /home/dave/keys/dpatton-1.pem" 'chmod u+x prepareNodes.sh && ./prepareNodes.sh >> prepareNode.log && sudo reboot'
	pssh -v -t 0 -l root -h cluster-hosts.txt -x "-t -t -oStrictHostKeyChecking=no -i keys/id_rsa" 'chmod u+x prepareNodes.sh && ./prepareNodes.sh >> prepareNode.log && sudo reboot'
	echo -e "\n=================="
	echo -e "Setup Complete"
	echo -e "==================="

	read -p "Do you want to setup Ambari now [y/N]" setupAmbari
	setupAmbari=${setupAmbari:-n}

	if [[ $setupAmbari =~ ^[Yy]$ ]]
	then
		echo -e "Running Amabri setup script"
		./setupAmbari.sh

	else
		echo -e "Ok.  You can run that later.  We are all done here."
		exit 0
	fi
else
	echo "****** Ok Do all that then run this script again. ******"
	exit 0
fi
