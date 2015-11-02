#!/bin/bash

echo "****************************"
echo "Starting Prepare Host"
echo "****************************"

echo -e "\nSetting Umask to 022"
umask 022
echo "umask 022" >> ~/.bashrc

#disable SELinux
echo -e "\nDisabling SELinux"
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Turn off autostart of iptables and ip6tables
echo -e "\nChecking ipTables and ip6table are off"
service iptables stop
sudo chkconfig iptables off
service ip6tables stop
sudo chkconfig ip6tables off

#Set Swapiness
echo -e "Setting Swapiness to 0"
echo 0 | sudo tee /proc/sys/vm/swappiness
echo vm.swappiness = 0 | sudo tee -a /etc/sysctl.conf

#Turn on NTPD
echo "Setting up NTPD and syncing time"
#Need to add a check to see if NTPD is installed.  If not install it
chkconfig ntpd on
ntpd -q
service ntpd start

#Install Oracle JDK 7
########################################################################
# NOTE: YOU MAY NEED TO UPDATE THE URL FOPR A MORE RECENT JDK VERSION
########################################################################
echo "Installing Oracle JDK7u79"
JDK_RPM="jdk7u79-linux-x64.rpm"
echo "JDK NAME:" $JDK_NAME
wget --no-check-certificate --no-cookies - --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        -O $JDK_RPM http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm
chmod u+x $JDK_RPM
rpm -ivh $JDK_RPM

JDK_NAME="jdk1.7.0_79"
export JDK_HOME="/usr/java/${JDK_NAME}"
echo "SETTING JDK_HOME TO: " $JDK_HOME

alternatives --install /usr/bin/java java /usr/java/${JDK_NAME}/jre/bin/java 20000
alternatives --install /usr/bin/jar jar /usr/java/${JDK_NAME}/bin/jar 20000
alternatives --install /usr/bin/javac javac /usr/java/${JDK_NAME}/bin/javac 20000
alternatives --install /usr/bin/javaws javaws /usr/java/${JDK_NAME}/jre/bin/javaws 20000
alternatives --set java /usr/java/${JDK_NAME}/jre/bin/java
alternatives --set javaws /usr/java/${JDK_NAME}/jre/bin/javaws
alternatives --set javac /usr/java/${JDK_NAME}/bin/javac
alternatives --set jar /usr/java/${JDK_NAME}/bin/jar

ls -lA /etc/alternatives/{jar,java*}
java -version

echo -e "\n****************************"
echo "Prepare Nodes COMPLETE!"
echo "****************************"