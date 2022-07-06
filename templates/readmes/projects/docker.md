# 👋 ProjectName Readme 👋

GEN_README_REPLACE_DESCRIBE

## Run container

```shell
dockermgr install ProjectName
```

### via command line

```shell
docker run -d \
--restart always \
--name ProjectName \
--hostname casjaysdev-ProjectName \
-e TZ=${TIMEZONE:-America/New_York} \
-v $PWD/ProjectName/data:/data \
-v $PWD/ProjectName/config:/config \
-p 80:80 \
casjaysdev/ProjectName:latest
```

### via docker-compose

```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdev/ProjectName
    container_name: ProjectName
    environment:
      - TZ=America/New_York
      - HOSTNAME=casjaysdev-ProjectName
    volumes:
      - $HOME/.local/share/docker/storage/ProjectName/data:/data
      - $HOME/.local/share/docker/storage/ProjectName/config:/config
    ports:
      - 80:80
    restart: always
```

## Authors  

🤖 AuthorName: [Github](https://github.com/AuthorName) [Docker](https://hub.docker.com/AuthorName) 🤖  
⛵ CasjaysDev: [Github](https://github.com/casjaysdev) [Docker](https://hub.docker.com/casjaysdev) ⛵  
