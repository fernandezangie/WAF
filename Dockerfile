FROM owasp/modsecurity-crs:nginx-alpine

USER root
RUN rm -f /docker-entrypoint.d/0-move-writables.sh \
 && ! ls /docker-entrypoint.d/ | grep -q move-writables

ENV PORT=8080
ENV BACKEND=https://mihorario-gateway-production.up.railway.app
ENV PROXY_SSL=off
ENV PROXY_PRESERVE_HOST=off
ENV MODSEC_RULE_ENGINE=DetectionOnly
ENV PARANOIA=1