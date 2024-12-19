# My custom scripts
  
## Automatic install

```shell
sudo git clone https://github.com/casjay-dotfiles/scripts "/usr/local/share/CasjaysDev/scripts" && \
sudo /usr/local/share/CasjaysDev/scripts/install.sh
```

## Automatic update

```shell
sudo systemmgr update scripts
```

## Manual install
  
requires:

```shell
sudo apt install git bash zsh fish python3-pip python3-setuptools net-tools fontconfig jq tf xclip curl wget dialog qalc rsync links html2text dict sudo ruby expect nethogs iftop iotop iperf locate pass python
```  

```shell
sudo yum install git bash zsh fish python3-pip python3-setuptools net-tools fontconfig jq tinyfugue xclip curl wget dialog qalc sudo
```  

```shell
sudo pacman -S git bash zsh fish python-pip python-setuptools net-tools fontconfig jq xclip curl wget dialog qalculate-gtk sudo
yay -S tinyfugue
```  

```shell
apk add ncurses util-linux pciutils usbutils coreutils binutils findutils grep iproute2 sudo
```

```shell
export PATH="$PATH:/usr/local/share/CasjaysDev/scripts/bin"
sudo git clone https://github.com/systemmgr/installer "/usr/local/share/CasjaysDev/scripts"
echo 'for f in /usr/local/share/CasjaysDev/scripts/completions/*; do source "$f" >/dev/null 2>&1; done' | sudo tee -p "/etc/bash_completion.d/_my_scripts_completions" >/dev/null
sudo ln -sf /usr/local/share/CasjaysDev/scripts /usr/local/share/CasjaysDev/installer
for f in $(ls /usr/local/share/CasjaysDev/scripts/bin/); do 
  sudo ln -sf /usr/local/share/CasjaysDev/scripts/bin/$f /usr/local/bin/$f
done
```

Manual update:  

```shell
sudo git -C /usr/local/share/CasjaysDev/scripts pull
```
  
  
<p align="center">
  <a href="https://github.com/dfmgr" target="_blank">dotfiles</a>  |
  <a href="https://github.com/fontmgr" target="_blank">fonts</a>  |  
  <a href="https://github.com/iconmgr" target="_blank">icons</a>  |  
  <a href="https://github.com/thememgr" target="_blank">themes</a>  |  
  <a href="https://github.com/wallpapermgr" target="_blank">wallpapers</a>  <br>
  <a href="https://github.com/devenvmgr" target="_blank">devenvmgr</a>  |
  <a href="https://github.com/dockermgr" target="_blank">dockermgr</a>  |
  <a href="https://github.com/pkmgr" target="_blank">pkmgr</a> |
  <a href="https://github.com/systemmgr" target="_blank">systemmgr</a> <br />
</p>  
  
  
<p align=center>
  <a href="https://github.com/casjay-dotfiles/scripts" target="_blank">scripts site</a><br /><br />
  <a href="https://wakatime.com/@casjay" target="_blank"><img alt="Wakatime" src="https://wakatime.com/badge/github/casjay-dotfiles/scripts.svg"><br> <br>
  <a href="https://travis-ci.com/casjay-dotfiles/scripts" target="_blank"><img alt="Travis-CI" src="https://travis-ci.com/casjay-dotfiles/scripts.svg?branch=master"><br> <br>
</p>  
