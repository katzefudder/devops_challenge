FROM nginx:1.27-alpine

# add nginx' host configuration
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf

# nginx consul template
COPY nginx_app.conf /etc/nginx/conf.d/nginx.conf

COPY index.html /var/www/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
