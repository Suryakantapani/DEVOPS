#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "Checking Nginx status:"
sudo systemctl status nginx --no-pager
echo "Checking localhost:"
curl http://localhost
echo
echo "Nginx web server is running successfully."