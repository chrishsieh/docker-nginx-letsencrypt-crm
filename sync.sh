rm -f /var/www/source/done.touch
rsync -aL --delete /var/www/CRM /var/www/source
touch /var/www/source/done.touch
