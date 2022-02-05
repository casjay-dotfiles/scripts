# 👋 Welcome to ProjectName 👋

GEN_README_REPLACE_DESCRIBE

## Run container

### command line

```shell
docker run -d \
--restart always \
--name ProjectName \
-e TZ=$TIMEZONE
-e HOSTNAME=ProjectName
-p 80:80 \
-v $PWD/ProjectName/data:/data \
-v $PWD/ProjectName/config:/config \
casjaysdev/ProjectName:latest
```

### docker-compose

```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdev/ProjectName
    container_name: ProjectName
    environment:
      - TZ=America/New_York
    volumes:
      - $HOME/.local/share/docker/storage/ProjectName/data:/data
      - $HOME/.local/share/docker/storage/ProjectName/config:/config
    ports:
      - 80:80
    restart: unless-stopped
```

## Author  

👤 **AuthorName**  
