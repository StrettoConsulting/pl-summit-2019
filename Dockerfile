FROM printerlogic/base-php-fpm-nginx:7.2 AS build

WORKDIR /var/www/app

# Copy in application code
COPY --chown=www-data:www-data . .

# Copy the .env.local as the base for environment variables within the image.  Dev systems will bind-mount on top of
# this and instead pass the environment values into the container environment through the compose env_file values.
# But we still need this here for other environments so we have a reasonable set of default values specified for the
# application layer through the container's environment vars.
RUN cp .env.local .env

# Run entrypoint
RUN chmod 775 ./.docker-config/scripts/*.sh
ENTRYPOINT ["/var/www/app/.docker-config/scripts/entrypoint.sh"]

EXPOSE 80 443 9001
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
