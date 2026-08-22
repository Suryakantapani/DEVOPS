crontab -e
0 17 * * 6 tar -czf ~/www_backup.tar.gz /var/www
crontab -l
