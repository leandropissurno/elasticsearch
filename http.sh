#!/bin/bash

## PROPERTIES
IP=$(ip addr show eth1 | grep inet | cut -d/ -f1 | awk '{ print $2}')

## INSTALL
# -- Apache HTTP
yum -y groups install Web\ Server
yum -y update

## CONFIGURE ##
# -- Apache HTTP
tee /etc/httpd/conf.d/elasticsearch.conf <<EOF
LISTEN $IP:8080
<VirtualHost $IP:8080>
   ServerName $HOSTNAME
   ProxyPass / http://localhost:9200/
   ProxyPassReverse / http://localhost:9200/
</VirtualHost>
EOF

## START
# -- Apache HTTP
systemctl enable httpd.service
systemctl start httpd.service
