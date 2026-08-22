#!/bin/bash

brew install nginx

brew services start nginx

cd /opt/homebrew/var/www || exit 1

cat > index.html <<EOF
<!DOCTYPE html>
<html>
<body>
<h1>Welcome to My NGINX Server</h1>
<p>Hosted on macOS</p>
</body>
</html>
EOF
brew services restart nginx
curl localhost:8080