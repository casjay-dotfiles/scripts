# Welcome to dockermgr GEN_README_REPLACE_APPNAME installer 👋
  
## GEN_README_REPLACE_DESCRIBE  
  
### Requires scripts to be installed

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/dockermgr/installer/raw/GEN_README_REPLACE_DEFAULT_BRANCH/install.sh")"
 dockermgr --config && dockermgr install scripts  
```

#### Automatic install/update  

```shell
dockermgr install GEN_README_REPLACE_APPNAME
```

#### Just run it

```shell
mkdir -p "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/"

git clone "https://github.com/dockermgr/GEN_README_REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME"

cp -Rfva "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/dataDir/." "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/"

sudo docker run -d \
--name="GEN_README_REPLACE_APPNAME" \
--hostname "GEN_README_REPLACE_APPNAME" \
--restart=always \
--privileged \
-e TZ="${TZ:-${TIMEZONE:-America/New_York}}" \
-v "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/files/data":/data:z \
-v "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/files/config":/config:z \
-p PORT:INT_PORT \
TEMPLATE/TEMPLATE 1>/dev/null
```

## Author

🤖 AuthorName: [Github](https://github.com/AuthorName) 🤖  
⛵ dockermgr: [Github](https://github.com/dockermgr) ⛵  
