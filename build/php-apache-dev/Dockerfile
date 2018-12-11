FROM chrishsieh/php-apache-dev:latest

# Set work directory to the web host path
WORKDIR /var/www

COPY ./php.ini /usr/local/etc/php/

RUN npm install grunt-cli i18next-extract-gettext -g && \
    echo "alias ls='ls --color=auto'" >> ~/.bashrc && \
    git clone https://github.com/ChurchCRM/CRM.git CRM && \
    cd CRM && \
    chmod +x ./travis-ci/*.sh && \
    chmod +x ./scripts/*.sh && \
    cp BuildConfig.json.example BuildConfig.json && \
    npm install --unsafe-perm && \
    npm audit fix && \
    npm run composer-install && \
    npm run orm-gen && \
    npm run update-signatures && \
    chown -R www-data:www-data /var/www/CRM

# Run the configsetup file on container start
ENTRYPOINT ["/usr/local/bin/presetup"]
CMD ["apache2-foreground"]
