FROM nginx:alpine

# Install Certbot
RUN apk add certbot certbot-nginx

# Add Cronjob
RUN echo "0	0	*	*	*	/usr/bin/certbot renew --quiet" >> /etc/crontabs/root

# Replace default nginx server config
RUN echo "server {"                                         >> /etc/nginx/conf.d/nginx.conf.template && \
    echo '    server_name "";'                              >> /etc/nginx/conf.d/nginx.conf.template && \
    echo ""                                                 >> /etc/nginx/conf.d/nginx.conf.template && \
    echo "    location / {"                                 >> /etc/nginx/conf.d/nginx.conf.template && \
    echo "        proxy_pass http://\${PROXY_HOST}:51821/;" >> /etc/nginx/conf.d/nginx.conf.template && \
    echo "        proxy_http_version 1.1;"                  >> /etc/nginx/conf.d/nginx.conf.template && \
    echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/nginx.conf.template && \
    echo '        proxy_set_header Connection "Upgrade";'   >> /etc/nginx/conf.d/nginx.conf.template && \
    echo "        proxy_set_header Host \$host;"            >> /etc/nginx/conf.d/nginx.conf.template && \
    echo "    }"                                            >> /etc/nginx/conf.d/nginx.conf.template && \
    echo "}"                                                >> /etc/nginx/conf.d/nginx.conf.template

#Run crond (background) and nginx (foreground)
CMD envsubst "\$PROXY_HOST" < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/default.conf && /usr/bin/certbot renew --quiet && crond && nginx -g "daemon off;"