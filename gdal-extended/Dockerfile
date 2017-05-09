#
# Dockerfile for the geOrchestra apache service
#
# geo.viennagglo.dev
#
FROM debian:jessie

MAINTAINER PSC "Fabien ALLAMANCHE <fallamanche@viennagglo.fr>"

ENV DEBIAN_FRONTEND noninterative

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y build-essential libxml2 libxml2-dev libjsoncpp0 libjsoncpp-dev unzip

#BUILD DEP GDAL - apt-cache showsrc gdal | grep ^Build-Depends
RUN apt-get install -y debhelper dh-autoreconf autotools-dev zlib1g-dev libnetcdf-dev netcdf-bin libjasper-dev libpng-dev libjpeg-dev libgif-dev libwebp-dev libhdf4-alt-dev libhdf5-dev libpq-dev libxerces-c-dev unixodbc-dev doxygen d-shlibs libgeos-dev libmysqlclient-dev dh-python python-all-dev python-numpy python3-all-dev python3-numpy libcurl4-gnutls-dev libsqlite3-dev libogdi3.2-dev chrpath swig patch libexpat1-dev libproj-dev libdap-dev libxml2-dev libspatialite-dev libepsilon-dev libpoppler-private-dev liblzma-dev libopenjpeg-dev libarmadillo-dev libfreexl-dev libkml-dev liburiparser-dev default-jdk ant
RUN rm -rf /var/lib/apt/lists/*

#CREATE WORKDIR
RUN mkdir /app

#ECW FILES SUPPORT
WORKDIR /app
#ADD http://downloads.hexagongeospatial.com/software/2016/ECWJP2SDK/erdas-ecw-sdk-5.3.0-linux.zip /app/erdas-ecw-sdk-5.3.0-linux.zip
ADD libs/ERDAS-ECW_JPEG_2000_SDK-5.3.0.tar.gz /app
RUN mv /app/libecw /usr/local/ecwjp2_sdk
RUN ln -s /usr/local/ecwjp2_sdk/lib/x64/release/libNCSEcw.so /usr/local/lib/libNCSEcw.so
RUN echo "/usr/local/ecwjp2_sdk/lib/x64/release/" >> /etc/ld.so.conf

ADD libs/gdal-2.1.3.tar.gz /app
WORKDIR /app/gdal-2.1.3
RUN ./configure --with-threads --with-grass=no --with-libtiff=internal --with-geotiff=internal \
    --with-java=/usr/lib/jvm/default-java --with-jasper --with-netcdf --with-xerces --with-geos --with-sqlite3 \
    --with-curl --with-pg --with-ogdi --with-mysql --with-perl --with-python --with-odbc \
    --with-dods-root=/usr --with-static-proj4=yes --with-spatialite=/usr --with-cfitsio=no --with-ecw=/usr/local/ecwjp2_sdk \
    --with-mrsid=no --with-poppler=yes --with-openjpeg=yes --with-freexl=yes --with-libkml=yes --with-armadillo=yes \
    --with-liblzma=yes --with-epsilon=/usr;
RUN make 
RUN make install

WORKDIR /app/gdal-2.1.3/swig/java
RUN export JAVA_HOME=/usr/lib/jvm/default-java
RUN make && make install

RUN ldconfig

#TEST ECW gdalinfo --formats | grep -i ecw /// gdalinfo /app/ecw/38-2012-0835-6470-LA93.ecw
ADD ecw/* /app/ecw/
WORKDIR /app/ecw
