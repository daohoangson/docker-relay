#! /usr/bin/env bash
set -e # exit on error

if [ -z "$FROM_ADDRESS" ] ; then
	echo "FROM_ADDRESS _must_ be defined"
	exit 1
fi
export FROM_ADDRESS
export TO_ADDRESS=${TO_ADDRESS:-"check-auth-pony=xfrocks.com@verifier.port25.com"}

sendmail -f "$FROM_ADDRESS" -t "$TO_ADDRESS" < /root/templates/email.txt