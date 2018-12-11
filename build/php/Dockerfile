ARG  IMG_VERSION=php-fpm-dev
ARG  CODE_VERSION=latest
FROM chrishsieh/${IMG_VERSION}:${CODE_VERSION}
ARG  CMD_STRING

# Set work directory to the web host path
WORKDIR /var/www

COPY ./php.ini /usr/local/etc/php/

RUN if [ "$IMG_VERSION" != "php-fpm" ]; then \
    npm install grunt-cli i18next-extract-gettext -g && \
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
    chown -R www-data:www-data /var/www/CRM; \
    fi

RUN touch ~/run_cmd && chmod 777 ~/run_cmd && echo ${CMD_STRING:-php-fpm} > ~/run_cmd
# Run the configsetup file on container start
ENTRYPOINT ["/usr/local/bin/presetup"]
CMD sh -c ~/run_cmd
