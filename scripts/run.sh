#!/bin/sh

set -e

if [ -z "$SMTP_LOGIN" -o -z "$SMTP_PASSWORD" ] ; then
  echo 'SMTP_LOGIN and SMTP_PASSWORD _must_ be defined'
  exit 1
fi
_extRelayHost=${EXT_RELAY_HOST:-'email-smtp.us-east-1.amazonaws.com'}
_relayHostName=${RELAY_HOST_NAME:-'relay.local.xfrocks.com'}

echo "$_relayHostName" > /etc/mailname

cat /root/templates/main.cf \
  | sed -e "s#{{ EXT_RELAY_HOST }}#$_extRelayHost#g" \
  | sed -e "s#{{ RELAY_HOST_NAME }}#$_relayHostName#g" \
  | tee /etc/postfix/main.cf >/dev/null

cat /root/templates/sasl_passwd \
  | sed -e "s#{{ EXT_RELAY_HOST }}#$_extRelayHost#g" \
  | sed -e "s#{{ SMTP_LOGIN }}#$SMTP_LOGIN#g" \
  | sed -e "s#{{ SMTP_PASSWORD }}#$SMTP_PASSWORD#g" \
  | tee /etc/postfix/sasl_passwd >/dev/null \
  && postmap /etc/postfix/sasl_passwd

exec /usr/bin/supervisord -c /root/templates/supervisord.conf
