FROM owasp/modsecurity-crs:nginx-alpine

ENTRYPOINT ["sh", "-c", "echo SERVICIO-WAF-OK; ls /docker-entrypoint.d/; sleep 3600"]