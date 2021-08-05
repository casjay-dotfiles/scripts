## GEN_README_REPLACE_APPNAME
  
### GEN_README_REPLACE_DESCRIBE  
  
#### Requires scripts to be installed

```shell
sudo bash -c "$(curl -LSs <https://github.com/thememgr/installer/raw/GEN_README_REPLACE_DEFAULT_BRANCH/install.sh>)" && sudo thememgr install installer  
```

### Automatic install/update

```shell
thememgr install GEN_README_REPLACE_APPNAME
```

OR  

```shell
bash -c "$(curl -LSs https://github.com/thememgr/GEN_README_REPLACE_APPNAME/raw/GEN_README_REPLACE_DEFAULT_BRANCH/install.sh)"
```
  
Manual install:  

```shell
git clone https://github.com/thememgr/GEN_README_REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/thememgr/GEN_README_REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/thememgr/GEN_README_REPLACE_APPNAME/theme/." "$HOME/.local/share/themes/GEN_README_REPLACE_APPNAME" --delete
```
  
Manual update:  

```shell
git -C "$HOME/.local/share/CasjaysDev/thememgr/GEN_README_REPLACE_APPNAME" pull
rsync -avhP "$HOME/.local/share/CasjaysDev/thememgr/GEN_README_REPLACE_APPNAME/theme/." "$HOME/.local/share/themes/GEN_README_REPLACE_APPNAME" --delete
```
