#!/bin/bash

domainname=$(hostname)

echo "Enter username for codeserver to install on"
read selecteduser
echo "Enter a password for code-server"
read -s password

apt update 
apt install nginx nodejs -y
wget https://github.com/cdr/code-server/releases/download/v3.9.2/code-server-3.9.2-linux-amd64.tar.gz
tar -xf code-server-3.9.2-linux-amd64.tar.gz
mv code-server-*/ /home/$selecteduser/bin
chmod 777 /home/$selecteduser/bin/code-server
su $selecteduser -c "mkdir -p ~/data"



echo "
[Unit]
Description=code-server
After=nginx.service

[Service]
User=code
WorkingDirectory=/home/code
Environment=PASSWORD=$password
ExecStart=/home/$selecteduser/bin/code-server --host 127.0.0.1 --port 7777 --user-data-dir /home/$selecteduser/data --auth password
Restart=always

[Install]
WantedBy=multi-user.target

" >> /etc/systemd/system/code-server.service

echo "
server {
	listen 8020 ssl http2;
	server_name $domainname;

	ssl_certificate /etc/letsencrypt/live/$domainname/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/$domainname/privkey.pem;

	location / {
		proxy_pass http://127.0.0.1:7777/;
		proxy_set_header Host \$host;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection upgrade;
		proxy_set_header Accept-Encoding gzip;
	}
}
" >> /etc/nginx/sites-available/codeserver

ln -s /etc/nginx/sites-available/codeserver /etc/nginx/sites-enabled/
systemctl daemon-reload 
systemctl restart nginx
systemctl restart code-server
echo "You should be able to see your codeserver server at http://$domainname:8020"

