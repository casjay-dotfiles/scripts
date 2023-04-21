## 👋 Welcome to REPLACE_APPNAME 🚀

REPLACE_DESCRIBE  
  
  
### Requires scripts to be installed

```shell
sudo bash -c "$(curl -q -LSsf <https://github.com/desktopmgr/installer/raw/REPLACE_DEFAULT_BRANCH/install.sh>)" && sudo desktopmgr install installer
```

OR

### Automatic install/update  

```shell
desktopmgr update REPLACE_APPNAME
```

OR

```shell
bash -c "$(curl -q -LSsf https://github.com/desktopmgr/REPLACE_APPNAME/raw/REPLACE_DEFAULT_BRANCH/install.sh)"
```
  
requirements:
  
Debian based:

```shell
apt install REPLACE_APPNAME
```  

Fedora Based:

```shell
yum install REPLACE_APPNAME
```  

Arch Based:

```shell
pacman -S REPLACE_APPNAME
```  

MacOS:  

```text
Only linux is supported
```
  
Manual install:  

```shell
APPDIR="$HOME/.local/share/CasjaysDev/desktopmgr/REPLACE_APPNAME"
mv -fv "$HOME/.config/REPLACE_APPNAME" "$HOME/.config/REPLACE_APPNAME.bak"
git clone "https://github.com/desktopmgr/REPLACE_APPNAME" "$APPDIR"
cp -Rfv "$APPDIR/etc/." "$HOME/.config/REPLACE_APPNAME/"
[ -d "$APPDIR/bin" ] && cp -Rfv "$APPDIR/bin/." "$HOME/.local/bin/"
```

## Author

🤖 REPLACE_AUTHOR_NAME: [Github](https://github.com/REPLACE_AUTHOR_NAME) 🤖  
⛵ desktopmgr: [Github](https://github.com/desktopmgr) ⛵  
  
## Links

<p align=center>
   <a href="https://travis-ci.com/github/desktopmgr/REPLACE_APPNAME" target="_blank" rel="noopener noreferrer">
     <img src="https://travis-ci.com/desktopmgr/REPLACE_APPNAME.svg?branch=master" alt="Build Status"></a><br />
  <a href="https://wiki.archlinux.org/index.php/REPLACE_APPNAME" target="_blank" rel="noopener noreferrer">REPLACE_APPNAME wiki</a>  |  
  <a href="REPLACE_APPNAME" target="_blank" rel="noopener noreferrer">REPLACE_APPNAME site</a>
</p>  
