## 👋 Welcome to REPLACE_APPNAME 🚀  

REPLACE_DESCRIBE  
  
  
### Requires scripts to be installed


```shell
sudo bash -c "$(curl -q -LSsf "https://github.com/thememgr/installer/raw/REPLACE_DEFAULT_BRANCH/install.sh")" && sudo thememgr install installer  
```

OR

### Automatic install/update  

```shell
thememgr update REPLACE_APPNAME
```

OR  

```shell
bash -c "$(curl -q -LSsf "https://github.com/thememgr/REPLACE_APPNAME/raw/REPLACE_DEFAULT_BRANCH/install.sh")"
```
  
Manual install:  

```shell
git clone "https://github.com/thememgr/REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/thememgr/REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/thememgr/REPLACE_APPNAME/theme/." "$HOME/.local/share/themes/REPLACE_APPNAME" --delete
```
  
Manual update:  

```shell
git -C "$HOME/.local/share/CasjaysDev/thememgr/REPLACE_APPNAME" pull
rsync -avhP "$HOME/.local/share/CasjaysDev/thememgr/REPLACE_APPNAME/theme/." "$HOME/.local/share/themes/REPLACE_APPNAME" --delete
```

## Author  

🤖 REPLACE_AUTHOR_NAME: [Github](https://github.com/REPLACE_AUTHOR_NAME) 🤖  
⛵ thememgr: [Github](https://github.com/thememgr) ⛵  
