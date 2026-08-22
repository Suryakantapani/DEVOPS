brew install nginx
brew services start nginx
echo "<html><body><h1>Welcome to NGINX</h1><p>Static Website Hosted Successfully</p></body></html>" > /opt/homebrew/var/www/index.html
brew services restart nginx
curl http://localhost:8080