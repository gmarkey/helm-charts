FROM alpine:3.14

RUN apk add --no-cache squid

CMD [ "/usr/sbin/squid", "-f", "/etc/squid/squid.conf", "-NYCd", "1" ]
