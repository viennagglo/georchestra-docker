#!/bin/bash

set -e

#SSL
rm -Rf /var/www/georchestra/ssl/*

#Generate a private key (enter a good passphrase and keep it safe !)
openssl genrsa -des3 -passout pass:yourpassword -out /var/www/georchestra/ssl/georchestra.key 2048

#Generate a Certificate Signing Request (CSR) for this key
openssl req -key /var/www/georchestra/ssl/georchestra.key -subj "/C=FR/ST=None/L=None/O=None/OU=None/CN=georchestra.dev" -newkey rsa:2048 -sha256 -passin pass:yourpassword -out /var/www/georchestra/ssl/georchestra.csr

#Create an unprotected key
openssl rsa -in /var/www/georchestra/ssl/georchestra.key -passin pass:yourpassword -out /var/www/georchestra/ssl/georchestra-unprotected.key

#generate a self-signed certificate (CRT)
openssl x509 -req -days 365 -in /var/www/georchestra/ssl/georchestra.csr -signkey /var/www/georchestra/ssl/georchestra.key -passin pass:yourpassword -out /var/www/georchestra/ssl/georchestra.crt

chown -Rf www-data:www-data /var/www/georchestra/ssl/*
ls -l /var/www/georchestra/ssl/
