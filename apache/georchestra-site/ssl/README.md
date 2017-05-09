# Self-signed certificate

Generate a private key (enter a good passphrase and keep it safe !)
```
sudo rm -Rf /var/www/georchestra/ssl/*

sudo openssl genrsa -des3 \
	-passout pass:yourpassword \
	-out /var/www/georchestra/ssl/georchestra.key 2048
```

Protect it with:
```
sudo chmod 400 /var/www/georchestra/ssl/georchestra.key
```

Generate a [Certificate Signing Request](http://en.wikipedia.org/wiki/Certificate_signing_request) (CSR) for this key, with eg:
```
sudo openssl req \
	-key /var/www/georchestra/ssl/georchestra.key \
	-subj "/C=FR/ST=None/L=None/O=None/OU=None/CN=georchestra.fr" \
	-newkey rsa:2048 -sha256 \
	-passin pass:yourpassword \
	-out /var/www/georchestra/ssl/georchestra.csr
```

Be sure to replace the ```/C=FR/ST=None/L=None/O=None/OU=None/CN=geo.viennagglo.fr``` string with something more relevant:
 * ```C``` is the 2 letter Country Name code
 * ```ST``` is the State or Province Name
 * ```L``` is the Locality Name (eg, city)
 * ```O``` is the Organization Name (eg, company)
 * ```OU``` is the Organizational Unit (eg, company department)
 * ```CN``` is the Common Name (***your server FQDN***)

Create an unprotected key:
```
sudo openssl rsa \
	-in /var/www/georchestra/ssl/georchestra.key \
	-passin pass:yourpassword \
	-out /var/www/georchestra/ssl/georchestra-unprotected.key
```

Finally generate a self-signed certificate (CRT):
```
sudo openssl x509 -req \
	-days 365 \
	-in /var/www/georchestra/ssl/georchestra.csr \
	-signkey /var/www/georchestra/ssl/georchestra.key \
	-passin pass:yourpassword
	-out /var/www/georchestra/ssl/georchestra.crt
```

We check folder's content :
```
sudo chown -Rf www-data:www-data /var/www/georchestra/ssl/*
ls -l /var/www/georchestra/ssl/
```

Restart the web server:
```
sudo service apache2 restart
``` 

## Keystore

To create a keystore, enter the following:
```
sudo keytool -genkey \
    -alias georchestra_localhost \
    -keystore /srv/jetty/jetty80/etc/keystore \
    -storepass yourpassword \
    -keypass yourpassword \
    -keyalg RSA \
    -keysize 2048 \
    -dname "CN=geo.viennagglo.fr, OU=geo.viennagglo.fr, O=Unknown, L=Unknown, ST=Unknown, C=FR"
```
... where ```STOREPASSWORD``` is a password you choose, and the ```dname``` string is customized.

### CA certificates

If the geOrchestra webapps have to communicate with remote HTTPS services, our keystore/trustore has to include CA certificates.

This will be the case when:
 * the proxy has to relay an https service
 * geonetwork will harvest remote https nodes
 * geoserver will proxy remote https ogc services

To do this:
```
sudo keytool -importkeystore \
    -srckeystore /etc/ssl/certs/java/cacerts \
    -destkeystore /srv/jetty/jetty80/etc/keystore
```
First password is "yourpassword"     
The password of the srckeystore is "changeit" by default, and should be modified in /etc/default/cacerts.

### SSL

As the SSL certificate is absolutely required, at least for the CAS module, you must add it to the keystore.
```
sudo keytool -import -alias cert_ssl \
	-file /var/www/georchestra/ssl/georchestra.crt \
	-keystore /srv/jetty/jetty80/etc/keystore
```
Firts password is "yourpassword"     
After, answer yes or oui
