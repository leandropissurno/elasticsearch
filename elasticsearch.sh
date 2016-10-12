#!/bin/bash

## PROPERTIES
IP=$(ip addr show eth1 | grep inet | cut -d/ -f1 | awk '{ print $2}')

## INSTALL
# -- Elasticsearch
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
tee /etc/yum.repos.d/elasticsearch.repo <<-'EOF'
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
EOF
yum -y install elasticsearch

## CONFIGURE ##
# -- Elasticsearch
sed -i -r 's/# cluster.name:.*/cluster.name: cluster-elasticsearch/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# node.name:.*/node.name: '"$HOSTNAME"'/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# network.host:.*/# network.host: [_eth1_, _local_]\nhttp.host: _local_\ntransport.host: _eth1_/' /etc/elasticsearch/elasticsearch.yml
sed -i -r 's/# discovery.zen.ping.unicast.hosts:.*/discovery.zen.ping.unicast.hosts: ["elasticsearch-01", "elasticsearch-02", "elasticsearch-03", "elasticsearch-04"]/' /etc/elasticsearch/elasticsearch.yml

## START
# -- Elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service