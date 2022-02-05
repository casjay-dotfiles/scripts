# 👋 ProjectName Readme 👋

GEN_README_REPLACE_DESCRIBE

## Run container

### via command line

```shell
docker run -d \
--restart always \
--name ProjectName \
-e HOSTNAME=ProjectName
-e TZ=${TIMEZONE:-America/New_York}
-p 80:80 \
-v $PWD/ProjectName/data:/data \
-v $PWD/ProjectName/config:/config \
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
      - HOSTNAME=ProjectName
    volumes:
      - $HOME/.local/share/docker/storage/ProjectName/data:/data
      - $HOME/.local/share/docker/storage/ProjectName/config:/config
    ports:
      - 80:80
    restart: always
```

## Authors  

🤖 Casjay: [Github](https://github.com/casjay) [Docker](https://hub.docker.com/casjay) 🤖  
⛵ CasjaysDev: [Github](https://github.com/casjaysdev) [Docker](https://hub.docker.com/casjaysdev) ⛵  
