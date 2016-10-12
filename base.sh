#!/bin/bash

## PROPERTIES

echo "vagrant:vagrant"|chpasswd
systemctl stop firewalld;systemctl disable firewalld
timedatectl set-timezone America/Sao_Paulo
echo net.ipv6.conf.default.disable_ipv6 = 1 >> /etc/sysctl.conf
echo net.ipv6.conf.all.disable_ipv6 = 1 >> /etc/sysctl.conf
sysctl -p
yum -y install bash-completion vim nmap