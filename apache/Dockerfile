#
# Dockerfile for the geOrchestra apache service
#
# geo.viennagglo.dev
#
FROM debian:jessie

MAINTAINER PSC "Fabien ALLAMANCHE <fallamanche@viennagglo.fr>"

ENV DEBIAN_FRONTEND noninterative

#INSTALL APACHE2 & PHP5
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y apache2 php5 ca-certificates && rm -rf /var/lib/apt/lists/* && ldconfig

#APACHE2 MODULES SETUP
RUN a2enmod proxy proxy_http ssl rewrite headers deflate

#DIRECTORY SITE STRUCTURE
ADD georchestra-site /var/www/georchestra/
RUN chgrp www-data /var/www/georchestra/logs/ && chmod g+w /var/www/georchestra/logs/ && chown -Rf www-data:www-data /var/www/georchestra

RUN mv /var/www/georchestra/conf/georchestra.conf /etc/apache2/sites-enabled/
RUN a2dissite 000-default default-ssl && echo "127.0.0.1 geo.viennagglo.dev" >> /etc/hosts
RUN echo "ServerName georchestra.dev" >> /etc/apache2/apache2.conf

EXPOSE 80 443

# Set the default command to run when starting the container
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
