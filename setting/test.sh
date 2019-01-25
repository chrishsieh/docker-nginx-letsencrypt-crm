git clone https://github.com/ChurchCRM/CRM.git CRM
cd CRM
chmod +x ./travis-ci/*.sh
chmod +x ./scripts/*.sh
cp /var/www/BuildConfig.json .
yarn install --no-bin-links
yarn run composer-update
yarn run composer-install
yarn run orm-gen
yarn run update-signatures
cd ..
chown -R www-data:www-data CRM