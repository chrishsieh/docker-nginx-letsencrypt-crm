ARG  IMG_VERSION=php-fpm-dev
ARG  CODE_VERSION=latest
FROM chrishsieh/${IMG_VERSION}:${CODE_VERSION}
ARG  CMD_STRING

# Set work directory to the web host path
WORKDIR /var/www

COPY ./php.ini /usr/local/etc/php/

RUN if [ "$IMG_VERSION" != "php-fpm" ]; then \
        yarn add global grunt-cli i18next-extract-gettext github-release-notes webpack webpack-cli && \
        echo "alias ls='ls --color=auto'" >> ~/.bashrc
    fi

RUN touch ~/run_cmd && chmod 777 ~/run_cmd && echo ${CMD_STRING:-php-fpm} > ~/run_cmd
# Run the configsetup file on container start
ENTRYPOINT ["/usr/local/bin/presetup"]
CMD sh -c ~/run_cmd
