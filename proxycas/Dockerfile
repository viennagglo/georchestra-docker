#
# Dockerfile for the geOrchestra Proxy (Security-proxy) service
#
# geo.viennagglo.dev
#
#FROM jetty:9.3-jre8
FROM jetty:9.2.21-jre7

MAINTAINER PSC "Fabien ALLAMANCHE <fallamanche@viennagglo.fr>"

ENV DEBIAN_FRONTEND noninterative
ENV XMS=256M XMX=1G

#INSTALL Prerequisites
RUN apt-get update && apt-get install -y apt-utils && ldconfig
RUN apt-get install -y wget ca-certificates && rm -rf /var/lib/apt/lists/* && ldconfig

WORKDIR /var/lib/jetty/webapps
RUN wget https://packages.georchestra.org/bot/wars/16.12/ROOT-generic.war -O ROOT.war
RUN wget https://packages.georchestra.org/bot/wars/16.12/cas-generic.war -O cas.war

WORKDIR /var/lib/jetty/
RUN mkdir work

RUN java -jar "$JETTY_HOME/start.jar" --add-to-startd=http,https,ssl,jsp,deploy,server

RUN echo "jetty.http.port=8080" >> /var/lib/jetty/start.d/http.ini && \
    echo "jetty.http.idleTimeout=30000" >> /var/lib/jetty/start.d/http.ini

RUN echo "https.port=8443" >> /var/lib/jetty/start.d/https.ini && \
    echo "https.timeout=30000" >> /var/lib/jetty/start.d/https.ini

RUN echo "jetty.httpConfig.securePort=8443" >> /var/lib/jetty/start.d/ssl.ini && \
    echo "jetty.sslContext.keyStorePath=/etc/georchestra/ssl/keystore" >> /var/lib/jetty/start.d/ssl.ini && \
    echo "jetty.sslContext.trustStorePath=/etc/georchestra/ssl/keystore" >> /var/lib/jetty/start.d/ssl.ini && \
    echo "jetty.sslContext.keyStorePassword=yourpassword" >> /var/lib/jetty/start.d/ssl.ini && \
    echo "jetty.sslContext.keyManagerPassword=yourpassword" >> /var/lib/jetty/start.d/ssl.ini && \
    echo "jetty.sslContext.trustStorePassword=yourpassword" >> /var/lib/jetty/start.d/ssl.ini

RUN echo "jsp-impl=apache" >> /var/lib/jetty/start.d/jsp.ini


EXPOSE 8080 8443

VOLUME ["/tmp", "/run/jetty"]

CMD ["sh", "-c", "exec java \
-Djava.awt.headless=true \
-XX:+UseConcMarkSweepGC \
-Xms$XMS \
-Xmx$XMX \
-Dgeorchestra.datadir=/etc/georchestra \
-Djavax.net.ssl.trustStore=/etc/georchestra/ssl/keystore \
-Djavax.net.ssl.trustStorePassword=yourpassword \
-Djava.io.tmpdir=/tmp/jetty \
-XX:-UsePerfData \
${JAVA_OPTIONS} \
-jar /usr/local/jetty/start.jar"]