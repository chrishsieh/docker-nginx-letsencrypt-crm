FROM chrishsieh/php-fpm-dev:latest

COPY ./php.ini /usr/local/etc/php/

RUN npm install grunt-cli i18next-extract-gettext -g && \
    echo "alias npm='npm --no-bin-links'" >> ~/.bashrc && \
    echo "alias ls='ls --color=auto'" >> ~/.bashrc

# Set work directory to the web host path
WORKDIR /var/www

# Run the configsetup file on container start
ENTRYPOINT ["/usr/local/bin/presetup"]
CMD ["php-fpm"]
