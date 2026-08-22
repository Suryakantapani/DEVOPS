#!/bin/bash
brew install nginx
echo "<h1> Welcome to NGINX Server</h1>" > /opt/homebrew/var/www/index.html
brew services start nginx
echo "Nginx web server is running."
curl http://localhost:8080