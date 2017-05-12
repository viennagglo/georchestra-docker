#
# Dockerfile for the geOrchestra openldap service
#
# geo.viennagglo.dev
#
#FROM debian:jessie
FROM dinkel/openldap

MAINTAINER PSC "Fabien ALLAMANCHE <fallamanche@viennagglo.fr>"

ENV DEBIAN_FRONTEND noninterative

#INSTALL Prerequisites
#RUN apt-get update && apt-get install -y apt-utils
#RUN apt-get install -y slapd ldap-utils
RUN apt-get update && \
    apt-get install -y ldap-utils && \
    rm -rf /var/lib/apt/lists/*

#APACHE2 MODULES SETUP
CMD /etc/init.d/slapd start

#DATABASE ENTRIES
RUN mkdir -p /app/ldif
ADD ldif /app/ldif
WORKDIR /app/ldif

USER root
CMD ldapadd -Y EXTERNAL -H ldapi:/// -f bootstrap.ldif
CMD ldapadd -D"cn=admin,dc=georchestra,dc=org" -w secret -f root.ldif
CMD ldapadd -Y EXTERNAL -H ldapi:/// -f groupofmembers.ldif
CMD ldapadd -Y EXTERNAL -H ldapi:/// -f memberof.ldif 
CMD ldapadd -D"cn=admin,dc=georchestra,dc=org" -w secret -f georchestra.ldif

# Expose the ldap port
EXPOSE 389

# Set the default command to run when starting the container
#CMD slapd -h 'ldap:/// ldapi:///' -g openldap -u openldap -F /etc/ldap/slapd.d -d stats
CMD [ "slapd", "-d", "32768", "-u", "openldap", "-g", "openldap" ]
