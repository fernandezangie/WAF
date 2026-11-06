#!/bin/sh
set -e

export PORT="${PORT:-8080}"
export MODSEC_RULE_ENGINE="${MODSEC_RULE_ENGINE:-DetectionOnly}"
export MODSEC_AUDIT="${MODSEC_AUDIT:-RelevantOnly}"
export PARANOIA="${PARANOIA:-1}"
: "${BACKEND:?Falta la variable BACKEND}"
export BACKEND="${BACKEND%/}"
export BACKEND_HOST="$(echo "$BACKEND" | sed -E 's#^[a-zA-Z]+://##; s#/.*$##; s#:[0-9]+$##')"

# DNS de Railway (puede ser IPv6)
RES="$(awk '/^nameserver/{print $2; exit}' /etc/resolv.conf)"
case "$RES" in *:*) RES="[$RES]";; esac
export RESOLVER="$RES"

VARS='${PORT} ${BACKEND} ${BACKEND_HOST} ${RESOLVER} ${MODSEC_RULE_ENGINE} ${MODSEC_AUDIT} ${PARANOIA}'
envsubst "$VARS" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
envsubst "$VARS" < /etc/modsecurity/modsecurity.conf.template > /etc/modsecurity/main.conf

# Muestra el audit log de ModSecurity en los Deploy Logs
tail -n 0 -F /var/log/modsec/audit.log &

echo "WAF: puerto=$PORT backend=$BACKEND motor=$MODSEC_RULE_ENGINE audit=$MODSEC_AUDIT paranoia=$PARANOIA"
nginx -t
exec nginx -g 'daemon off;'