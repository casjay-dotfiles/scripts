## 👋 Welcome to GEN_README_REPLACE_APPNAME 🚀  

GEN_README_REPLACE_DESCRIBE  
  
  
## Requires scripts to be installed  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/GEN_README_REPLACE_DEFAULT_BRANCH/install.sh")"
 systemmgr --config && systemmgr install scripts  
```

## Automatic install/update  

```shell
dockermgr update GEN_README_REPLACE_APPNAME
```

OR

```shell
mkdir -p "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir"
git clone "https://github.com/dockermgr/GEN_README_REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME/dataDir/." "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/"
```

## via command line  

```shell
docker pull casjaysdevdocker/ProjectName:latest && \
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-ProjectName \
--hostname casjaysdev-ProjectName \
-e TZ=${TIMEZONE:-America/New_York} \
-v $HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/data:/data:z \
-v $HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/config:/config:z \
-p 80:80 \
casjaysdevdocker/ProjectName:latest
```

## via docker-compose  

```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdevdocker/ProjectName
    container_name: ProjectName
    environment:
      - TZ=America/New_York
      - HOSTNAME=casjaysdev-ProjectName
    volumes:
      - $HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/data:/data:z
      - $HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/config:/config:z
    ports:
      - 80:80
    restart: always
```

## Author  

🤖 AuthorName: [Github](https://github.com/AuthorName) [Docker](https://hub.docker.com/r/AuthorName) 🤖  
📽 dockermgr: [Github](https://github.com/dockermgr) [Docker](https://hub.docker.com/r/dockermgr) 📽  
⛵ CasjaysDev Docker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/r/casjaysdevdocker) ⛵  
