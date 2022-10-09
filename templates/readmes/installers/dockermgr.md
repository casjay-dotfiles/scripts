## 👋 Welcome to GEN_README_REPLACE_APPNAME 🚀  

GEN_README_REPLACE_DESCRIBE  
  
  
### Requires scripts to be installed  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/dockermgr/installer/raw/GEN_README_REPLACE_DEFAULT_BRANCH/install.sh")"
 dockermgr --config && dockermgr install scripts  
```

OR

### Automatic install/update  

```shell
dockermgr update GEN_README_REPLACE_APPNAME
```

### via command line  

```shell
mkdir -p "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir"
git clone "https://github.com/dockermgr/GEN_README_REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME/dataDir/." "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/"
```

```shell
docker pull casjaysdevdocker/ProjectName:latest && \
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-ProjectName \
--hostname casjaysdev-ProjectName \
-e TZ=${TIMEZONE:-America/New_York} \
-v $HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/dataDir/data:/data:z \
-v $HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/dataDir/config:/config:z \
-p 80:80 \
casjaysdevdocker/ProjectName:latest
```

### via docker-compose  

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
      - $HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/dataDir/data:/data:z
      - $HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/dataDir/config:/config:z
    ports:
      - 80:80
    restart: always
```

## Author

🤖 AuthorName: [Github](https://github.com/AuthorName) 🤖  
⛵ dockermgr: [Github](https://github.com/dockermgr) ⛵  
