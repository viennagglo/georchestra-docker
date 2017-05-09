#
# Dockerfile for the geOrchestra Proxycas (Security-proxy + CAS) service
#
# geo.viennagglo.dev
#
FROM jetty:9.3-jre8

MAINTAINER PSC "Fabien ALLAMANCHE <fallamanche@viennagglo.fr>"

ENV DEBIAN_FRONTEND noninterative
ENV XMS=256M XMX=1G

#INSTALL Prerequisites
RUN apt-get update && apt-get install -y apt-utils
RUN ldconfig
RUN apt-get install -y wget
RUN ldconfig

#RUN mkdir /app
WORKDIR /var/lib/jetty/webapps
RUN wget https://packages.georchestra.org/bot/wars/16.12/cas-generic.war -O cas.war
RUN wget https://packages.georchestra.org/bot/wars/16.12/ROOT-generic.war -O ROOT.war

WORKDIR /var/lib/jetty/
RUN mkdir work

#ADD GEORCHESTRA DATADIR CONF
ADD datadir/cas /etc/georchestra/cas

RUN java -jar "$JETTY_HOME/start.jar" --add-to-startd=jmx,jmx-remote,stats,gzip,deploy

EXPOSE 8080

VOLUME [ "/tmp", "/run/jetty" ]

CMD ["sh", "-c", "exec java \
-Djava.io.tmpdir=/tmp/jetty \
-Dgeorchestra.datadir=/etc/georchestra \
-Xms$XMS -Xmx$XMX \
-XX:-UsePerfData \
${JAVA_OPTIONS} \
-jar /usr/local/jetty/start.jar"]
