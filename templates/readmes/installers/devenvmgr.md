## GEN_README_REPLACE_APPNAME
  
### GEN_README_REPLACE_DESCRIBE  

Requires scripts to be installed: sudo bash -c "$(curl -LSs <https://github.com/dfmgr/installer/raw/$GIT_DEFAULT_BRANCH/install.sh>)" && sudo dfmgr install installer  
  Automatic install/update:  

```shell
devenvmgr install GEN_README_REPLACE_APPNAME
```

OR  

```shell
bash -c "$(curl -LSs https://github.com/devenvmgr/GEN_README_REPLACE_APPNAME/raw/$GIT_DEFAULT_BRANCH/install.sh)"
```
  
Manual install:  

```shell
git clone https://github.com/devenvmgr/GEN_README_REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/devenvmgr/GEN_README_REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/devenvmgr/GEN_README_REPLACE_APPNAME/." "MyProject" --exclude=*/.git/*
```
  
Manual update:  

```shell
git -C "$HOME/.local/share/CasjaysDev/devenvmgr/GEN_README_REPLACE_APPNAME" pull
```
