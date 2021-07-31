## GEN_README_REPLACE_APPNAME
  
### GEN_README_REPLACE_DESCRIBE  
  
Requires scripts to be installed: sudo bash -c "$(curl -LSs <https://github.com/dockermgr/installer/raw/$GIT_DEFAULT_BRANCH/install.sh>)" && sudo dockermgr install installer  
Automatic install/update:  

```shell
dockermgr install GEN_README_REPLACE_APPNAME
```

OR

```shell
bash -c "$(curl -LSs https://github.com/dockermgr/GEN_README_REPLACE_APPNAME/raw/$GIT_DEFAULT_BRANCH/install.sh)"
```
  
Manual install:

```shell
git clone https://github.com/dockermgr/GEN_README_REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME"
bash -c "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME/install.sh"
```
  
Manual update:

```shell
git -C "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME" pull
bash -c "$HOME/.local/share/CasjaysDev/dockermgr/GEN_README_REPLACE_APPNAME/install.sh"
```
