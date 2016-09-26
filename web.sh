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