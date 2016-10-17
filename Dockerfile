FROM alpine:edge
MAINTAINER Dao Hoang Son <daohoangson@gmail.com>

RUN	true && \
	apk add --no-cache --update postfix ca-certificates supervisor rsyslog bash && \
	(rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)

COPY	supervisord.conf /etc/supervisord.conf
COPY	rsyslog.conf /etc/rsyslog.conf
COPY	templates /root/templates
COPY	run.sh /root/run.sh
COPY	test.sh /root/test.sh
RUN		chmod +x /root/*.sh

VOLUME	[ "/var/spool/postfix", "/etc/postfix" ]

EXPOSE 25

CMD ["/root/run.sh"]
