```shell
docker build -t igeo/openldap .
docker run -dti -p 389:389 --name openldap igeo/openldap
docker run -ti -p 389:389 -e SLAPD_ORGANISATION=georchestra -e SLAPD_DOMAIN=georchestra.org -e SLAPD_PASSWORD=secret -e SLAPD_ADDITIONAL_MODULES=groupofmembers --name openldap igeo/openldap
```



