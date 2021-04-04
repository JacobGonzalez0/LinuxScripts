#!/bin/bash

apt update 
apt install wget curl git go default-jdk nodejs npm maria-db-server nginx nano certbot -y


read -p "Please enter your domain name: " domainname
read -p "Please enter your email :" email

certbot certonly --standalone --agree-tos -m email -d $domainname

echo "
server {
	listen 80;
	server_name " + $domainname + ";
	# enforce https
	return 301 https://$server_name:443$request_uri;
}

server {
	listen 443 ssl http2;
	server_name code.hakase-labs.io;

	ssl_certificate /etc/letsencrypt/live/$server_name/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/$server_name/privkey.pem;

	location / {
		proxy_pass http://127.0.0.1:8080/;
		proxy_set_header Host $host;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection upgrade;
		proxy_set_header Accept-Encoding gzip;
	}
}
" >> /etc/nginx/sites-available/tomcat

ln -s /etc/nginx/sites-available/tomcat /etc/nginx/sites-enabled/
systemctl restart nginx
echo "You should be able to see your java server at http://" + $domainname
