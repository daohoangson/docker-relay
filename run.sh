#! /usr/bin/env bash
set -e # exit on error

# Variables
if [ -z "$SMTP_LOGIN" -o -z "$SMTP_PASSWORD" ] ; then
	echo "SMTP_LOGIN and SMTP_PASSWORD _must_ be defined"
	exit 1
fi
export SMTP_LOGIN SMTP_PASSWORD
export EXT_RELAY_HOST=${EXT_RELAY_HOST:-"email-smtp.us-east-1.amazonaws.com"}
export RELAY_HOST_NAME=${RELAY_HOST_NAME:-"relay.local.xfrocks.com"}

echo $RELAY_HOST_NAME > /etc/mailname

# Templates
sed -e "s#{{ RELAY_HOST_NAME }}#$RELAY_HOST_NAME#g" /root/templates/main.cf |
	sed -e "s#{{ EXT_RELAY_HOST }}#$EXT_RELAY_HOST#g" > /etc/postfix/main.cf
sed -e "s#{{ SMTP_LOGIN }}#$SMTP_LOGIN#g" /root/templates/sasl_passwd |
	sed -e "s#{{ SMTP_PASSWORD }}#$SMTP_PASSWORD#g" |
	sed -e "s#{{ EXT_RELAY_HOST }}#$EXT_RELAY_HOST#g" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

# Launch
exec /usr/bin/supervisord -c /etc/supervisord.conf
