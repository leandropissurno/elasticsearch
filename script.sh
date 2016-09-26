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
sed -i -r 's/# cluster.name: my-application/cluster.name: teste/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# node.name: node-1/node.name: '"$HOSTNAME"'/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# network.host:.*/network.host: '"$IP"'/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# discovery.zen.ping.unicast.hosts: \["host1", "host2"\]/discovery.zen.ping.unicast.hosts: ["elasticsearch-01", "elasticsearch-02"]/' /etc/elasticsearch/elasticsearch.yml
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service


## NGINX ##
tee /etc/yum.repos.d/nginx.repo <<-'EOF'
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
EOF
yum -y update
yum -y insntall nginx



## APACHE ##
yum -y install httpd mod_ssl
tee /etc/httpd/conf.d/reverse-proxy.conf <<-'EOF'
ProxyRequests Off

ProxyPass /test1 http://192.168.1.10:8080/test1
ProxyPassReverse /test1 http://192.168.1.10:8080/test1

#ProxyPass http://localhost:9200/
<Location /%your_location%>
     ProxyRequests Off
     ProxyPass http://localhost:9200/
     ProxyPassReverse http://localhost:9200/
</Location>
EOF