## GEN_README_REPLACE_APPNAME
  
### GEN_README_REPLACE_DESCRIBE  
  
#### Requires scripts to be installed

 ```shell
sudo bash -c "$(curl -LSs <https://github.com/iconmgr/installer/raw/GEN_README_REPLACE_DEFAULT_BRANCH/install.sh>)" && sudo iconmgr install installer
```

### Automatic install/update  

```shell
iconmgr install GEN_README_REPLACE_APPNAME
```

OR  

```shell
bash -c "$(curl -LSs https://github.com/iconmgr/GEN_README_REPLACE_APPNAME/raw/GEN_README_REPLACE_DEFAULT_BRANCH/install.sh)"
```
  
Manual install:

```shell
git clone https://github.com/iconmgr/GEN_README_REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/iconmgr/GEN_README_REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/iconmgr/GEN_README_REPLACE_APPNAME/icons/." "$HOME/.local/share/icons/GEN_README_REPLACE_APPNAME" --delete
```
  
Manual update:  

```shell
git -C "$HOME/.local/share/CasjaysDev/iconmgr/GEN_README_REPLACE_APPNAME" pull
rsync -avhP "$HOME/.local/share/CasjaysDev/iconmgr/GEN_README_REPLACE_APPNAME/icons/." "$HOME/.local/share/icons/GEN_README_REPLACE_APPNAME" --delete
```
