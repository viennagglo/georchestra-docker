# docker-georchestra

stop all docker containers
```shell
docker stop $(docker ps -a -q)
```

Delete all docker containers
```shell
docker rm $(docker ps -a -q)
```

Delete all docker images
```shell
docker rmi $(docker images -q)
```

Delete all docker volumes
```shell
docker volume rm $(docker volume ls -qf dangling=true)
```
