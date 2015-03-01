# This script is intended to be run from within a fresh
# instance of Ubuntu Server 14.04.1 LTS from the user directory.

# To check what your Ubuntu version is, you can run
# lsb_release -a

# Draws from
# https://www.digitalocean.com/community/tutorials/how-to-install-hadoop-on-ubuntu-13-10
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/SingleCluster.html
# http://www.alexjf.net/blog/distributed-systems/hadoop-yarn-installation-definitive-guide/
# https://help.ubuntu.com/community/CheckingYourUbuntuVersion
# http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-multi-node-cluster/

# Curran Kelleher Feb 2015

sudo apt-get update
sudo apt-get install -y default-jdk

# To check what your Java version is, you can run
# java -version

# Set up SSH keys for Hadoop to use.
ssh-keygen -t rsa -P ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Fetch and unzip Hadoop.
curl -O http://mirror.cogentco.com/pub/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
tar xfz hadoop-2.6.0.tar.gz
sudo mv hadoop-2.6.0 /usr/local/hadoop
rm hadoop-2.6.0.tar.gz

# Set up environment variables.
echo export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 >> ~/.bashrc
echo export HADOOP_PREFIX=/usr/local/hadoop >> ~/.bashrc
echo export PATH=\$PATH:/usr/local/hadoop/bin >> ~/.bashrc
echo export PATH=\$PATH:/usr/local/hadoop/sbin >> ~/.bashrc
source ~/.bashrc


cp master/* /usr/local/hadoop/etc/hadoop/


# Format HDFS
hdfs namenode -format

# Start NameNode daemon and DataNode daemon
start-dfs.sh

# Add a security rule in the AWS Web Interface
# for allowing all incoming traffic.
# Under Security Group / Inbound / Edit / Add Rule

# On a given node, you can check to see which
# daemons are running with the command:
# jps

# For slave nodes,
# Edit the file /usr/local/hadoop/etc/hadoop/core-site.xml
# <configuration>
#   <property>
#     <name>fs.default.name</name>
#     <value>hdfs://52.11.95.33:9000</value>
#   </property>
# </configuration>

# For slave nodes,
# Edit the file /usr/local/hadoop/etc/hadoop/yarn-site.xml
# <configuration>
#   <property>
#     <name>yarn.resourcemanager.hostname</name>
#     <value>52.11.95.33</value>
#   </property>
# </configuration>

# You need to give the master node the ability to talk to the slave
# over passphraseless SSH. To do this, log into the master node and run
#
# cat ~/.ssh/id_rsa.pub
#
# Copy the results to the clipboard.

