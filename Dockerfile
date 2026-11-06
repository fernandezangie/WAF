FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      nginx libnginx-mod-http-modsecurity ca-certificates curl gettext-base \
    && rm -rf /var/lib/apt/lists/*

# OWASP Core Rule Set con versión fija
ARG CRS_VERSION=3.3.5
RUN mkdir -p /etc/crs /etc/modsecurity \
    && curl -fsSL https://github.com/coreruleset/coreruleset/archive/refs/tags/v${CRS_VERSION}.tar.gz \
       | tar -xz -C /etc/crs --strip-components=1 \
    && cp /etc/crs/crs-setup.conf.example /etc/crs/crs-setup.conf

COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY modsecurity.conf.template /etc/modsecurity/modsecurity.conf.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]