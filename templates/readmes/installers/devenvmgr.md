## 👋 Welcome to REPLACE_APPNAME 🚀  

REPLACE_DESCRIBE  
  
  
### Requires scripts to be installed

```shell
sudo bash -c "$(curl -q -LSsf <https://github.com/dfmgr/installer/raw/REPLACE_DEFAULT_BRANCH/install.sh>)" && sudo systemmgr install installer  
```

OR

### Automatic install/update  

```shell
devenvmgr update REPLACE_APPNAME
```

OR  

```shell
bash -c "$(curl -q -LSsf "https://github.com/devenvmgr/REPLACE_APPNAME/raw/REPLACE_DEFAULT_BRANCH/install.sh")"
```
  
Manual install:  

```shell
git clone "https://github.com/devenvmgr/REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/devenvmgr/REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/devenvmgr/REPLACE_APPNAME/." "MyProject" --exclude=*/.git/*
```
  
Manual update:  

```shell
git -C "$HOME/.local/share/CasjaysDev/devenvmgr/REPLACE_APPNAME" pull
```

## Author  

🤖 AuthorName: [Github](https://github.com/AuthorName) 🤖  
⛵ devenvmgr: [Github](https://github.com/devenvmgr) ⛵  
