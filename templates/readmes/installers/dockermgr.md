## 👋 Welcome to REPLACE_APPNAME 🚀  

REPLACE_DESCRIBE  
  
  
## Requires scripts to be installed  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/REPLACE_DEFAULT_BRANCH/install.sh")"
 systemmgr --config && systemmgr install scripts  
```

## Automatic install/update  

```shell
dockermgr update REPLACE_APPNAME
```

OR

```shell
mkdir -p "$HOME/.local/share/srv/docker/REPLACE_APPNAME/rootfs"
git clone "https://github.com/dockermgr/REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/dockermgr/REPLACE_APPNAME"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/REPLACE_APPNAME/rootfs/." "$HOME/.local/share/srv/docker/REPLACE_APPNAME/rootfs/"
```

## via command line  

```shell
docker pull REPLACE_REGISTRY_USER/REPLACE_PROJECT_NAME:latest && \
docker run -d \
--restart always \
--privileged \
--name REPLACE_REGISTRY_USER-REPLACE_PROJECT_NAME \
--hostname REPLACE_REGISTRY_USER-REPLACE_PROJECT_NAME \
-e TZ=${TIMEZONE:-America/New_York} \
-v $HOME/.local/share/srv/docker/REPLACE_REGISTRY_USER-REPLACE_PROJECT_NAME/rootfs/data:/data:z \
-v $HOME/.local/share/srv/docker/REPLACE_REGISTRY_USER-REPLACE_PROJECT_NAME/rootfs/config:/config:z \
-p 80:80 \
REPLACE_REGISTRY_USER/REPLACE_PROJECT_NAME:latest
```

## via docker-compose  

```yaml
version: "2"
services:
  ProjectName:
    image: REPLACE_REGISTRY_USER/REPLACE_PROJECT_NAME
    container_name: ProjectName
    environment:
      - TZ=America/New_York
      - HOSTNAME=REPLACE_REGISTRY_USER-REPLACE_PROJECT_NAME
    volumes:
      - $HOME/.local/share/srv/docker/REPLACE_REGISTRY_USER-REPLACE_PROJECT_NAME/rootfs/data:/data:z
      - $HOME/.local/share/srv/docker/REPLACE_REGISTRY_USER-REPLACE_PROJECT_NAME/rootfs/config:/config:z
    ports:
      - 80:80
    restart: always
```

## Author  

🤖 REPLACE_AUTHOR_NAME: [Github](https://github.com/REPLACE_AUTHOR_NAME) 🤖  
🤖 REPLACE_REGISTRY_USER: [Github](https://github.com/REPLACE_REGISTRY_USER) [Docker](https://hub.docker.com/r/REPLACE_REGISTRY_USER) 🤖  
