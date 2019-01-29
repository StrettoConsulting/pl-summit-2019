FROM printerlogic/base-php-fpm-nginx:7.2

# add bitbucket and github to known hosts for ssh needs
RUN touch /root/.ssh/known_hosts && ssh-keyscan -t rsa bitbucket.org >> /root/.ssh/known_hosts \
    && ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

WORKDIR /var/www
ENV COMPOSER_VENDOR_DIR=/var/www/vendor
ENV NODE_ENV=develop
ENV PATH /var/www/vendor/bin:/var/www/node_modules/.bin:$PATH
ENV NODE_PATH=/var/www/node_modules

# Copy in package/dependency files
COPY --chown=www-data:www-data ./composer.json ./composer.lock ./package.json ./

# composer
RUN \
    n=0; until [ $n -ge 2 ]; do \
        composer install --no-scripts --no-autoloader --ansi --no-interaction -o && break; \
        n=$((n+1)); \
        sleep 10; \
    done; \
    if [ $n -ge 2 ]; then \
        exit 1; \
    fi;

# npm: use "develop" to ensure tools are available for building)
RUN \
    n=0; until [ $n -ge 2 ]; do \
        npm install && break; \
        n=$((n+1)); \
        sleep 10; \
    done; \
    if [ $n -ge 2 ]; then \
        exit 1; \
    fi;

WORKDIR /var/www/app

# server config files
COPY ./.docker-config/nginx.conf /etc/nginx/nginx.conf
COPY ./.docker-config/nginx-app.conf /etc/nginx/conf.d/default.conf

# copy application code
COPY --chown=www-data:www-data . .
RUN cp .env.local .env

# Run composer
# npm run build will run 'gulp --production`
RUN composer dump-autoload --no-scripts

# Run entrypoint
RUN chmod 775 ./.docker-config/scripts/*.sh
ENTRYPOINT ["/var/www/app/.docker-config/scripts/entrypoint.sh"]

EXPOSE 80 443 9001
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
