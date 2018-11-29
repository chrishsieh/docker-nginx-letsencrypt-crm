FROM chrishsieh/php-fpm-dev:latest

COPY ./php.ini /usr/local/etc/php/

RUN npm install grunt-cli i18next-extract-gettext -g && \
    echo "alias ls='ls --color=auto'" >> ~/.bashrc

# Set work directory to the web host path
WORKDIR /var/www

RUN git clone https://github.com/ChurchCRM/CRM.git CRM && \
    cd CRM && \
    chmod +x ./travis-ci/*.sh && \
    chmod +x ./scripts/*.sh && \
    cp BuildConfig.json.example BuildConfig.json && \
    npm install --unsafe-perm && \
    npm run composer-install && \
    npm run orm-gen && \
    npm run install && \
    npm run update-signatures && \
    chown -R www-data:www-data /var/www/CRM

# Run the configsetup file on container start
ENTRYPOINT ["/usr/local/bin/presetup"]
CMD ["php-fpm"]
