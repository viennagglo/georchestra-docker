#
# Dockerfile for the geOrchestra PostgreSQL service
#
# geo.viennagglo.dev
#
FROM debian:jessie

MAINTAINER PSC "Fabien ALLAMANCHE <fallamanche@viennagglo.fr>"

ENV DEBIAN_FRONTEND noninterative
RUN export DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#INSTALL Prerequisites
RUN apt-get update && apt-get install -y apt-utils && ldconfig
RUN apt-get install -y build-essential pkg-config wget bash-completion postgresql-9.4 postgresql-server-dev-9.4
RUN ldconfig

#prerequisites Postgis
WORKDIR /tmp
RUN if [ ! -f geos-3.6.1.tar.bz2 ]; then \
	wget http://download.osgeo.org/geos/geos-3.6.1.tar.bz2; \
	fi;
RUN tar xvjf geos-3.6.1.tar.bz2 && \
cd geos-3.6.1 && \
./configure && make && make install
RUN ldconfig


RUN if [ ! -f proj-4.9.3.tar.gz ]; then \
        wget http://download.osgeo.org/proj/proj-4.9.3.tar.gz; \
        fi;
RUN tar xvzf proj-4.9.3.tar.gz && \
    cd proj-4.9.3 && \
    ./configure && make && make install
RUN ldconfig

RUN apt-get install -y libxml2 libxml2-dev libjsoncpp0 libjsoncpp-dev && ldconfig
RUN if [ ! -f gdal-2.2.0.tar.gz ]; then \
	wget http://download.osgeo.org/gdal/2.2.0/gdal-2.2.0.tar.gz; \
        fi;
RUN tar xvzf gdal-2.2.0.tar.gz && \
    cd gdal-2.2.0 && \
    #apt-get build-dep -y gdal && \
    ./configure && make && make install && ldconfig

RUN if [ ! -f postgis-2.3.2.tar.gz ]; then \
        wget http://download.osgeo.org/postgis/source/postgis-2.3.2.tar.gz; \
        fi;
RUN tar xvzf postgis-2.3.2.tar.gz && \
    cd postgis-2.3.2 && \
    ./configure && make && make install
RUN ldconfig

RUN mkdir -p /app/sql
ADD sql	/app/sql

# Run the rest of the commands as the ``postgres`` user
USER postgres

# Create a PostgreSQL role named ``georchestra`` with ``georchestra`` as the password and
# then create a database ``georchestra`` owned by the ``georchestra`` role.
RUN /etc/init.d/postgresql start && \
    psql -c "CREATE USER georchestra WITH SUPERUSER PASSWORD 'georchestra';" && \
    psql -c "CREATE USER geonetwork WITH SUPERUSER PASSWORD 'geonetwork';" && \
    createdb -E UTF8 -T template0 -O georchestra georchestra && \
    psql -d georchestra -c "ALTER USER "georchestra" WITH PASSWORD 'www-data';" && \
    psql -d georchestra -c "CREATE SCHEMA geonetwork AUTHORIZATION geonetwork;" && \
    psql -d georchestra -f /app/sql/01-create-extension.sql && \
    psql -d georchestra -f /app/sql/02-mapfishapp.sql && \
    psql -d georchestra -f /app/sql/03-downloadform.sql && \
    psql -d georchestra -f /app/sql/04-ldapadmin.sql && \
    psql -d georchestra -f /app/sql/05-ldapadmin-data.sql && \
    psql -d georchestra -f /app/sql/06-ogc-server-statistics.sql && \
    psql -d georchestra -f /app/sql/07-atlas.sql && \
    psql -d georchestra -f /app/sql/08-geofence.sql && \
    psql -d georchestra -f /app/sql/09-extractor-app.sql && \
    psql -d georchestra -f /app/sql/fix-owner.sql && \
    psql -d georchestra -c "SELECT change_owner('mapfishapp', 'georchestra');" && \
    psql -d georchestra -c "SELECT change_owner('downloadform', 'georchestra');" && \
    psql -d georchestra -c "SELECT change_owner('ldapadmin', 'georchestra');" && \
    psql -d georchestra -c "SELECT change_owner('ogcstatistics', 'georchestra');" && \
    psql -d georchestra -c "SELECT change_owner('public', 'georchestra');" && \
    psql -d georchestra -c "SELECT change_owner('geonetwork', 'georchestra');" && \
    /etc/init.d/postgresql stop
# FIXME: no superuser here


# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf

# And add ``listen_addresses``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

# Better query performance with:
RUN sed -i 's/shared_buffers = 128MB/shared_buffers = 1024MB/' /etc/postgresql/9.4/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
#~ VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
VOLUME  ["/var/log/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
