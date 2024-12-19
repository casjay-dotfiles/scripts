## 👋 Welcome to REPLACE_APPNAME 🚀  

REPLACE_DESCRIBE  
  
  
### Requires scripts to be installed

```shell
sudo bash -c "$(curl -q -LSsf "https://github.com/wallpapermgr/installer/raw/REPLACE_DEFAULT_BRANCH/install.sh")" && sudo wallpapermgr install installer
```

OR

### Automatic install/update  

```shell
wallpapermgr update REPLACE_APPNAME
```

OR  

```shell
bash -c "$(curl -q -LSsf "https://github.com/wallpapermgr/REPLACE_APPNAME/raw/REPLACE_DEFAULT_BRANCH/install.sh")"
```
  
Manual install:  

```shell
git clone "https://github.com/wallpapermgr/REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/wallpapermgr/REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/wallpapermgr/REPLACE_APPNAME/images/." "$HOME/.local/share/wallpapers/REPLACE_APPNAME" --delete
```
  
Manual update:

```shell
git -C "$HOME/.local/share/CasjaysDev/wallpapermgr/REPLACE_APPNAME" pull
rsync -avhP "$HOME/.local/share/CasjaysDev/wallpapermgr/REPLACE_APPNAME/images/." "$HOME/.local/share/wallpapers/REPLACE_APPNAME" --delete
```

## Author  

🤖 REPLACE_AUTHOR_NAME: [Github](https://github.com/REPLACE_AUTHOR_NAME) 🤖  
⛵ wallpapermgr: [Github](https://github.com/wallpapermgr) ⛵  
