```shell
docker build -t igeo/apache .
docker run -dti -p 80:80 -p 443:443 --name apache igeo/apache
```



