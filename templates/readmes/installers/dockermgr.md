# Welcome to dockermgr GEN_README_REPLACE_APPNAME installer 👋
  
### GEN_README_REPLACE_DESCRIBE  
  
#### Requires scripts to be installed

```shell
 sudo bash -c "$(curl -LSs <https://github.com/dockermgr/installer/raw/GEN_README_REPLACE_DEFAULT_BRANCH/install.sh>)"
 dockermgr --config && dockermgr install scripts  
```

#### Automatic install/update  

```shell
dockermgr install GEN_README_REPLACE_APPNAME
```


#### Manual install:

```shell
git clone https://github.com/dockermgr/GEN_README_REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME"
bash -c "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME/install.sh"
```
  
#### Just run
mkdir -p "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/"

git clone https://github.com/dockermgr/GEN_README_REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME"

cp -Rf "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/system/*" "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/"

sudo docker run -d \
--name="GEN_README_REPLACE_APPNAME" \
--hostname "checkip" \
--restart=unless-stopped \
--privileged \
-e TZ="${TZ:-${TIMEZONE:-America/New_York}}" \
-v "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/data":/data:z \
-v "$HOME/.local/share/srv/docker/GEN_README_REPLACE_APPNAME/config":/config:z \
-p PORT:INT_PORT \
TEMPLATE/TEMPLATE 1>/dev/null


## Author  

👤 **AuthorName**  
