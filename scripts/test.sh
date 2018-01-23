#!/bin/sh

set -e

if [ -z "$FROM_ADDRESS" ] ; then
  echo 'FROM_ADDRESS _must_ be defined'
  exit 1
fi

_toAddress=${TO_ADDRESS:-"check-auth-pony=xfrocks.com@verifier.port25.com"}

exec sendmail -f "$FROM_ADDRESS" -t "$_toAddress" < /root/templates/email.txt
