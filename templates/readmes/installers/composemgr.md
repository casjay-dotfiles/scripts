## 👋 Welcome to REPLACE_APPNAME 🚀  

REPLACE_DESCRIBE

### Requires scripts to be installed

```shell
sudo bash -c "$(curl -q -LSsf "https://github.com/dfmgr/installer/raw/REPLACE_DEFAULT_BRANCH/install.sh")" && sudo dfmgr install installer
```

### Install docker compose files

```shell
composemgr install REPLACE_APPNAME
```

### Edit .env

```shell
$EDITOR "$HOME/.config/myscripts/composemgr/docker/$REPLACE_APPNAME/.env"
```

### Edit app.env - will overwrite defaults from .env

```shell
$EDITOR "$HOME/.config/myscripts/composemgr/docker/$REPLACE_APPNAME/app.env"
```

### Pull the containers

```shell
composemgr --dir "$HOME/.config/myscripts/composemgr/docker/$REPLACE_APPNAME" pull
```

### Start the stack

```shell
composemgr --dir "$HOME/.config/myscripts/composemgr/docker/$REPLACE_APPNAME" up &&
```

### Get the logs for the stack

```shell
composemgr --dir "$HOME/.config/myscripts/composemgr/docker/$REPLACE_APPNAME" logs
```
