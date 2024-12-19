## 👋 Welcome to REPLACE_APPNAME 🚀  

REPLACE_DESCRIBE  
  
  
### Requires scripts to be installed

 ```shell
sudo bash -c "$(curl -q -LSsf "https://github.com/iconmgr/installer/raw/REPLACE_DEFAULT_BRANCH/install.sh")" && sudo iconmgr install installer
```

### Automatic install/update  

```shell
iconmgr update REPLACE_APPNAME
```

OR  

```shell
bash -c "$(curl -q -LSsf "https://github.com/iconmgr/REPLACE_APPNAME/raw/REPLACE_DEFAULT_BRANCH/install.sh")"
```
  
Manual install:

```shell
git clone "https://github.com/iconmgr/REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/iconmgr/REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/iconmgr/REPLACE_APPNAME/icons/." "$HOME/.local/share/icons/REPLACE_APPNAME" --delete
```
  
Manual update:  

```shell
git -C "$HOME/.local/share/CasjaysDev/iconmgr/REPLACE_APPNAME" pull
rsync -avhP "$HOME/.local/share/CasjaysDev/iconmgr/REPLACE_APPNAME/icons/." "$HOME/.local/share/icons/REPLACE_APPNAME" --delete
```

## Author  

🤖 REPLACE_AUTHOR_NAME: [Github](https://github.com/REPLACE_AUTHOR_NAME) 🤖  
⛵ iconmgr: [Github](https://github.com/iconmgr) ⛵  
