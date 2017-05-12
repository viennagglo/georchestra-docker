```shell
docker build -t igeo/proxycas .
docker run -dti --volumes-from georchestra_datadir --name proxycas igeo/proxycas
```
