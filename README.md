# Lightweight mail relay container
Ready to be used with Amazon SES 

## Examples

### Start up

```
docker run -d --name relay \
  -e SMTP_LOGIN=username \
  -e SMTP_PASSWORD=password \
  -e EXT_RELAY_HOST=email-smtp.us-east-1.amazonaws.com \
  -e RELAY_HOST_NAME=relay.local.xfrocks.com \
  xfrocks/relay
```

 * `EXT_RELAY_HOST` is optional, default to `us-east-1`
 
### Test it

```
docker exec \
  -e FROM_ADDRESS=verified@domain.com \
  -e TO_ADDRESS=you@domain.com \
  relay /root/scripts/test.sh
```

Checking the container logs with `docker logs -f relay`, you should get something like below (see the `status=sent` line):

```
2018-01-23 06:25:06,554 CRIT Supervisor running as root (no user in config file)
2018-01-23 06:25:06,557 INFO supervisord started with pid 1
2018-01-23 06:25:07,559 INFO spawned: 'master' with pid 19
2018-01-23 06:25:07,561 INFO spawned: 'rsyslog' with pid 20
2018-01-23T06:25:07.686792+00:00 c57459dcf4a1 postfix/postfix-script[69]: warning: not owned by root: /var/spool/postfix/.
2018-01-23 06:25:07,687 INFO success: master entered RUNNING state, process has stayed up for > than 0 seconds (startsecs)
2018-01-23T06:25:07.688395+00:00 c57459dcf4a1 postfix/postfix-script[70]: warning: not owned by root: /var/spool/postfix/pid
2018-01-23T06:25:07.697048+00:00 c57459dcf4a1 postfix/postfix-script[88]: starting the Postfix mail system
2018-01-23T06:25:07.700820+00:00 c57459dcf4a1 postfix/master[90]: daemon started -- version 3.2.4, configuration /etc/postfix
2018-01-23 06:25:07,701 INFO exited: master (exit status 0; expected)
2018-01-23T06:25:09.337075+00:00 c57459dcf4a1 postfix/pickup[91]: 524461A6929: uid=0 from=<verified@domain.com>
2018-01-23T06:25:09.339457+00:00 c57459dcf4a1 postfix/cleanup[100]: 524461A6929: message-id=<20180123062509.524461A6929@relay.local.xfrocks.com>
2018-01-23T06:25:09.341781+00:00 c57459dcf4a1 postfix/qmgr[92]: 524461A6929: from=<verified@domain.com>, size=338, nrcpt=1 (queue active)
2018-01-23 06:25:10,343 INFO success: rsyslog entered RUNNING state, process has stayed up for > than 2 seconds (startsecs)
2018-01-23T06:25:13.470481+00:00 c57459dcf4a1 postfix/smtp[102]: 524461A6929: to=<you@domain.com>, relay=email-smtp.us-east-1.amazonaws.com[23.21.251.48]:25, delay=4.1, delays=0.01/0.03/3.1/1, dsn=2.0.0, status=sent (250 Ok 0101016121b121a4-fbe33575-ec45-49d7-b70a-47c00e2e1a64-000000)
2018-01-23T06:25:13.675192+00:00 c57459dcf4a1 postfix/qmgr[92]: 524461A6929: removed
```
