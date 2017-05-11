#
# Dockerfile for the geOrchestra Mapfishapp (Security-proxy + CAS) service
#
# geo.viennagglo.dev
#
FROM jetty:9.3-jre8

MAINTAINER PSC "Fabien ALLAMANCHE <fallamanche@viennagglo.fr>"

ENV DEBIAN_FRONTEND noninterative
ENV XMS=512M XMX=1G

#INSTALL Prerequisites
RUN apt-get update && apt-get install -y apt-utils && ldconfig
RUN apt-get install -y wget ca-certificates && rm -rf /var/lib/apt/lists/* && ldconfig

#RUN mkdir /app
WORKDIR /var/lib/jetty/webapps
RUN wget https://packages.georchestra.org/bot/wars/16.12/header-generic.war -O header.war
RUN wget https://packages.georchestra.org/bot/wars/16.12/mapfishapp-generic.war -O mapfishapp.war

WORKDIR /var/lib/jetty/
RUN mkdir work

#GEORCHESTRA DATADIR CONF
#VOLUME /etc/georchestra
#ADD datadir/cas /etc/georchestra/cas

RUN java -jar "$JETTY_HOME/start.jar" --add-to-startd=jmx,jmx-remote,stats,gzip,http,jsp,deploy,server

RUN echo "jetty.http.port=8180" >> /var/lib/jetty/start.d/http.ini && \
    echo "jetty.http.idleTimeout=30000" >> /var/lib/jetty/start.d/http.ini

RUN echo "jsp-impl=apache" >> /var/lib/jetty/start.d/jsp.ini

EXPOSE 8180

VOLUME ["/tmp", "/run/jetty"]

CMD ["sh", "-c", "exec java \
-Djava.awt.headless=true \
-XX:+UseConcMarkSweepGC \
-Xms$XMS \
-Xmx$XMX \
-Djavax.net.ssl.trustStore=/etc/georchestra/ssl/keystore \
-Djavax.net.ssl.trustStorePassword=yourpassword \
-Djava.util.prefs.userRoot=/tmp \
-Djava.util.prefs.systemRoot=/tmp \
-Dorg.geotools.referencing.forceXY=true \
-Dextractor.storage.dir=/tmp/extracts/ \
-Djava.util.prefs.userRoot=/tmp \
-Djava.util.prefs.systemRoot=/tmp \
-Dgeorchestra.datadir=/etc/georchestra \
-Dgeonetwork.jeeves.configuration.overrides.file=/etc/georchestra/geonetwork/config/config-overrides-georchestra.xml \
-Dmapfish-print-config=/etc/georchestra/mapfishapp/print/config.yaml \
${JAVA_OPTIONS} \
-jar /usr/local/jetty/start.jar"]
