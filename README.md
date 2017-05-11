## geOrchestra Docker

#REQUIREMENTS 
On virtual machine (host), clone geOrchestra ViennAgglo default datadir
```shell
git clone --recursive https://github.com/viennagglo/georchestra-datadir.git  /etc/georchestra
```

This repository contains the default configuration files for geOrchestra modules, and can be used as a reference to build your own "geOrchestra datadir". We call this a "datadir" for the similarity with the well-known GeoServer and GeoNetwork datadirs, but this directory is not meant to host geographic data.  

At startup, geOrchestra applications running inside a servlet container having the extra georchestra.datadir parameter, will initialize themselves with the configuration contained in the directory that this parameters points to.  

# Creating and mounting a data volume container with geOchestra datadir content
```shell
docker create -v /etc/georchestra/:/etc/georchestra/ --name georchestra-datadir debian:jessie
```

```shell
docker run -ti --volumes-from georchestra-datadir --name proxycas igeo/proxycas /bin/bash
```

# Get the geOrchestra-docker repository

you need to download georchestra-docker repository :
```shell
git clone --recursive https://github.com/viennagglo/georchestra-docker.git  ~/georchestra-docker
```

# Create Self-signed certificate for Apache & Keystore (Tomcat or Jetty)
Create SSL directory
```shell
cd /etc/georchestra
mkdir ssl
cd ssl
```

Generate a private key (enter a good passphrase and keep it safe !)
```shell
sudo rm -Rf ../ssl/*

sudo openssl genrsa -des3 \
	-passout pass:yourpassword \
	-out georchestra.key 2048
```

Protect it with:
```shell
sudo chmod 400 georchestra.key
```

Generate a [Certificate Signing Request](http://en.wikipedia.org/wiki/Certificate_signing_request) (CSR) for this key, with eg:
```shell
sudo openssl req \
	-key georchestra.key \
	-subj "/C=FR/ST=None/L=None/O=None/OU=None/CN=geo.viennagglo.dev" \
	-newkey rsa:2048 -sha256 \
	-passin pass:yourpassword \
	-out georchestra.csr
```

Be sure to replace the ```/C=FR/ST=None/L=None/O=None/OU=None/CN=geo.viennagglo.dev``` string with something more relevant:
 * ```C``` is the 2 letter Country Name code
 * ```ST``` is the State or Province Name
 * ```L``` is the Locality Name (eg, city)
 * ```O``` is the Organization Name (eg, company)
 * ```OU``` is the Organizational Unit (eg, company department)
 * ```CN``` is the Common Name (***your server FQDN***)

Create an unprotected key:
```shell
sudo openssl rsa \
	-in georchestra.key \
	-passin pass:yourpassword \
	-out georchestra-unprotected.key
```

Finally generate a self-signed certificate (CRT):
```shell
sudo openssl x509 -req \
	-days 365 \
	-in georchestra.csr \
	-signkey georchestra.key \
	-passin pass:yourpassword
	-out georchestra.crt
```

We check folder's content :
```shell
sudo chown -Rf www-data:www-data ../ssl/*
ls -l ../ssl/
```

Restart the web server:
```shell
sudo service apache2 restart
``` 

# Keystore

To create a keystore, enter the following:
```shell
sudo keytool -genkey \
    -alias georchestra_localhost \
    -keystore keystore \
    -storepass yourpassword \
    -keypass yourpassword \
    -keyalg RSA \
    -keysize 2048 \
    -dname "CN=geo.viennagglo.dev, OU=geo.viennagglo.dev, O=Unknown, L=Unknown, ST=Unknown, C=FR"
```
... where ```STOREPASSWORD``` is a password you choose, and the ```dname``` string is customized.

### CA certificates

If the geOrchestra webapps have to communicate with remote HTTPS services, our keystore/trustore has to include CA certificates.

This will be the case when:
 * the proxy has to relay an https service
 * geonetwork will harvest remote https nodes
 * geoserver will proxy remote https ogc services

To do this:
```shell
sudo keytool -importkeystore \
    -srckeystore /etc/ssl/certs/java/cacerts \
    -destkeystore keystore
```
First password is "yourpassword"     
The password of the srckeystore is "changeit" by default, and should be modified in /etc/default/cacerts.

### SSL

As the SSL certificate is absolutely required, at least for the CAS module, you must add it to the keystore.
```shell
sudo keytool -import -alias cert_ssl \
	-file georchestra.crt \
	-keystore keystore
```
Firts password is "yourpassword"     
After, answer yes or oui

