#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071356-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  mgr_install.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 13:56 EDT
# @File              :  mgr_install.bash
# @Description       :  Functions for *mgr scripts
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
###################### devenvmgr settings ######################
devenvmgr_install() {
  export SCRIPTS_PREFIX="devenvmgr"
  export installtype="devenvmgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### dfmgr settings ######################
dfmgr_install() {
  export SCRIPTS_PREFIX="dfmgr"
  export installtype="dfmgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### desktopmgr settings ######################
desktopmgr_install() {
  export SCRIPTS_PREFIX="desktopmgr"
  export installtype="desktopmgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### dockermgr settings ######################
dockermgr_install() {
  export SCRIPTS_PREFIX="dockermgr"
  export installtype="dockermgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### fontmgr settings ######################
fontmgr_install() {
  export SCRIPTS_PREFIX="fontmgr"
  export installtype="fontmgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### hakmgr settings ######################
hakmgr_install() {
  export SCRIPTS_PREFIX="hakmgr"
  export installtype="hakmgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### iconmgr settings ######################
iconmgr_install() {
  export SCRIPTS_PREFIX="iconmgr"
  export installtype="iconmgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### pkmgr settings ######################
pkmgr_install() {
  export SCRIPTS_PREFIX="pkmgr"
  export installtype="pkmgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
}
#__main_installer_info
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### systemmgr settings ######################
systemmgr_install() {
  export SCRIPTS_PREFIX="systemmgr"
  export installtype="systemmgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### thememgr settings ######################
thememgr_install() {
  export SCRIPTS_PREFIX="thememgr"
  export installtype="thememgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### wallpapermgr settings ######################
wallpapermgr_install() {
  export SCRIPTS_PREFIX="wallpapermgr"
  export installtype="wallpapermgr_install"
  source "$CASJAYSDEVDIR/functions/installers/${SCRIPTS_PREFIX}.bash"
  #__main_installer_info
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
