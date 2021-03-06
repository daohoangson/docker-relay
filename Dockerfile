FROM alpine:3.10
MAINTAINER Dao Hoang Son <daohoangson@gmail.com>

# https://pkgs.alpinelinux.org/packages?name=postfix&branch=v3.10
ENV POSTFIX_VERSION=3.4.5-r0

RUN true \
  && apk add --no-cache \
    ca-certificates \
    cyrus-sasl \
    cyrus-sasl-plain \
    libsasl \
    postfix=${POSTFIX_VERSION} \
    rsyslog \
    supervisor \
  && (rm "/tmp/"* 2>/dev/null || true) \
  && (rm -rf /var/cache/apk/* 2>/dev/null || true)

# Update aliases database. It's not used, but postfix complains if the .db file is missing
RUN postalias /etc/postfix/aliases

COPY . /root

VOLUME	[ "/var/spool/postfix", "/etc/postfix" ]

EXPOSE 25

CMD ["/root/scripts/run.sh"]
