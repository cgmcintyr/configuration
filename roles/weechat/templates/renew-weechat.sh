#!/bin/bash
certbot renew -q
cat /etc/letsencrypt/live/{{ weechat_domain }}/privkey.pem \
    /etc/letsencrypt/live/{{ weechat_domain }}/fullchain.pem > \
    /home/{{ username }}/.weechat/ssl/relay.pem
chown {{ username }}:{{ username }} /home/{{ username }}/.weechat/ssl/relay.pem
echo '*/relay sslcertkey' > /home/{{ username }}/.weechat/weechat_fifo
