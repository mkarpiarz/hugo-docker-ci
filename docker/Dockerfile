FROM ubuntu:14.04
MAINTAINER Mariusz Karpiarz
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y nginx
ADD files/hugo/public /usr/share/nginx/html
# Expose ports.
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
