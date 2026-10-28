FROM nginx:1.27-alpine
RUN apk upgrade --no-cache
COPY index.html about.html contact.html products.html services.html /usr/share/nginx/html/
RUN mkdir -p /tmp/nginx /var/cache/nginx && \
    addgroup -S app && adduser -S -G app -u 1001 app && \
    chown -R app:app /usr/share/nginx/html /tmp/nginx /var/cache/nginx && \
    printf '%s\n' \
    'error_log stderr warn;' \
    'pid /tmp/nginx/nginx.pid;' \
    'events { worker_connections 1024; }' \
    'http {' \
    '  include /etc/nginx/mime.types;' \
    '  default_type application/octet-stream;' \
    '  access_log /dev/stdout;' \
    '  client_body_temp_path /tmp/nginx/client_temp;' \
    '  proxy_temp_path /tmp/nginx/proxy_temp;' \
    '  fastcgi_temp_path /tmp/nginx/fastcgi_temp;' \
    '  uwsgi_temp_path /tmp/nginx/uwsgi_temp;' \
    '  scgi_temp_path /tmp/nginx/scgi_temp;' \
    '  server {' \
    '    listen 8080;' \
    '    server_name _;' \
    '    root /usr/share/nginx/html;' \
    '    index index.html;' \
    '    location / { try_files $uri $uri/ =404; }' \
    '  }' \
    '}' > /etc/nginx/nginx.conf
EXPOSE 8080
USER 1001
CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]