FROM owasp/modsecurity-crs:nginx-alpine@sha256:873ce68a658d2e3b61484a8a24d215f7d15456e7ce5aec5e7114bf000d743365

# Cambiar temporalmente a root para crear la carpeta y dar permisos
USER root
RUN mkdir -p /usr/local/bootstrap/nginx && \
    touch /usr/local/bootstrap/nginx/dummy.conf && \
    chown -R nginx:nginx /usr/local/bootstrap

# Volver al usuario sin privilegios por seguridad
USER nginx

ENV PORT=8080
ENV BACKEND=https://mihorario-gateway-production.up.railway.app
ENV PROXY_SSL=off
ENV PROXY_PRESERVE_HOST=off
ENV MODSEC_RULE_ENGINE=DetectionOnly
ENV PARANOIA=1