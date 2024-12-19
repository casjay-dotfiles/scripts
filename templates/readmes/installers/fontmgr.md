## 👋 Welcome to REPLACE_APPNAME 🚀  

REPLACE_DESCRIBE  
  
  
### Requires scripts to be installed

```shell
 sudo bash -c "$(curl -q -LSsf https://github.com/fontmgr/installer/raw/REPLACE_DEFAULT_BRANCH/install.sh)" && sudo fontmgr install installer  
```

OR

### Automatic install/update  

```shell
fontmgr update REPLACE_APPNAME
```

OR  

```shell
bash -c "$(curl -q -LSsf "https://github.com/fontmgr/REPLACE_APPNAME/raw/REPLACE_DEFAULT_BRANCH/install.sh")"
```
  
Manual install:  

```shell
git clone "https://github.com/fontmgr/REPLACE_APPNAME" "$HOME/.local/share/CasjaysDev/fontmgr/REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/fontmgr/REPLACE_APPNAME/fonts/." "$HOME/.local/share/fonts/REPLACE_APPNAME" --delete
```
  
Manual update:

```shell
git -C "$HOME/.local/share/CasjaysDev/fontmgr/REPLACE_APPNAME" pull
rsync -avhP "$HOME/.local/share/CasjaysDev/fontmgr/REPLACE_APPNAME/fonts/." "$HOME/.local/share/fonts/REPLACE_APPNAME" --delete
```

## Author  

🤖 REPLACE_AUTHOR_NAME: [Github](https://github.com/REPLACE_AUTHOR_NAME) 🤖  
⛵ fontmgr: [Github](https://github.com/fontmgr) ⛵  
