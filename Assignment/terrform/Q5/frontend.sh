#!/bin/bash

apt update -y
apt install nginx -y
systemctl start nginx
systemctl enable nginx

echo "<h1>Frontend Server</h1><p>Backend IP: ${backend_ip}</p>" > /var/www/html/index.html
