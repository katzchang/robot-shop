#!/usr/bin/env bash

# set -x

# echo "arg 1 $1"

BASE_DIR=/usr/share/nginx/html

echo "hello"

if [ -n "$1" ]
then
    exec "$@"
fi


if [ -n "$SPLUNK_RUM_TOKEN" -a -n "$SPLUNK_REALM" ]
then
    echo "Enabling Splunk RUM"
    sed -i "s|SPLUNK_RUM_TOKEN|$SPLUNK_RUM_TOKEN|" $BASE_DIR/rum-tmpl.html
    sed -i "s|SPLUNK_REALM|$SPLUNK_REALM|" $BASE_DIR/rum-tmpl.html
    cp $BASE_DIR/rum-tmpl.html $BASE_DIR/rum.html
else
    echo "RUM not enabled"
    cp $BASE_DIR/empty.html $BASE_DIR/rum.html
fi

# make sure nginx can access the eum file
chmod 644 $BASE_DIR/rum.html

# apply environment variables to default.conf
envsubst '${CATALOGUE_HOST} ${USER_HOST} ${CART_HOST} ${SHIPPING_HOST} ${PAYMENT_HOST} ${RATINGS_HOST}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

echo "***"
cat /etc/nginx/nginx.conf
echo "***"
ls -al /opt/opentelemetry-webserver-sdk/WebServerModule/Nginx/
echo "***"
cat /tmp/appd_install_*
echo "***"

exec nginx-debug -g "daemon off;"

