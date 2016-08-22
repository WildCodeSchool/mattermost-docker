#!/bin/bash
echo Starting Nginx
sed -Ei "s/APP_PORT/$PLATFORM_PORT_80_TCP_PORT/" /etc/nginx/sites-available/mattermost
sed -Ei "s/APP_PORT/$PLATFORM_PORT_80_TCP_PORT/" /etc/nginx/sites-available/mattermost-ssl
sed -Ei "s/DOMAIN/$DOMAIN/" /etc/nginx/sites-available/letsencrypt
sed -Ei "s/DOMAIN/$DOMAIN/" /etc/nginx/sites-available/mattermost-ssl

if test -f "/etc/letsencrypt/live/$DOMAIN/cert.pem"; then
    if [ "$MATTERMOST_ENABLE_SSL" = true ]; then
	ssl="-ssl"
    fi
    ln -s -f /etc/nginx/sites-available/mattermost$ssl /etc/nginx/sites-enabled/mattermost
else
    ln -s -f /etc/nginx/sites-available/letsencrypt /etc/nginx/sites-enabled/mattermost
fi

nginx -g 'daemon off;'
