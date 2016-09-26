#!/bin/bash
echo "vagrant:vagrant"|chpasswd
systemctl stop firewalld;systemctl disable firewalld
timedatectl set-timezone America/Sao_Paulo
echo net.ipv6.conf.default.disable_ipv6 = 1 >> /etc/sysctl.conf
echo net.ipv6.conf.all.disable_ipv6 = 1 >> /etc/sysctl.conf
sysctl -p
curl -LOs 'http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie' && rpm -i jdk-8u102-linux-x64.rpm
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
tee /etc/yum.repos.d/elasticsearch.repo <<-'EOF'
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
EOF
yum -y install vim
yum -y install elasticsearch
yum -y update
IP=$(ip addr show eth1 | grep inet | cut -d/ -f1 | awk '{ print $2}')
sed -i -r 's/# cluster.name:.*/cluster.name: cluster-elasticsearch/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# node.name:.*/node.name: '"$HOSTNAME"'/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# network.host:.*/network.host: '"$IP"'/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# discovery.zen.ping.unicast.hosts:.*/discovery.zen.ping.unicast.hosts: ["elasticsearch-01", "elasticsearch-02", "elasticsearch-03", "elasticsearch-04", "elasticsearch-05"]/' /etc/elasticsearch/elasticsearch.yml
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service