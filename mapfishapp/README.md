docker build -t igeo/mapfishapp .  
docker run -dti --volumes-from georchestra_datadir --name mapfishapp igeo/mapfishapp
