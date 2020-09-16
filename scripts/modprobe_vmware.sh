#!/usr/bin/env sh

# How to install VMware Workstation 15.5.1 on Arch Linux
# - Install linux-headers with the same version as the current system kernel
#  version (uname -r)
# - Read and follow the Arch Linux Guide for VMware
# - Edit /etc/init.d/vmware, each mod='something' must assign mod=vmw_vmci,
#  search for the 'vmwareStartVmci' function, edit vmci=vmw_vmci and 
#  create a global variable mod=vmw_vmci then delete all "mod=...", so 
#  practically vmwareRealModName() should not be used in the whole script
#  also leave vmciNode=vmci as it is
# VMware 15.5.1:
# - tar -xzf workstation-15.5.1.tar.gz
# - cd vmware-host-modules-workstation-15.5.1
# VMware 16.0.0:
# - unzip ~/1w3j/bin/vmware-host-modules-workstation-16.0.0.zip
# - cd vmware-host-modules-workstation-16.0.0
# - make
# - sudo make install
# 
# if for some reason still isn't completed continue with the following:
# - Install vmware-patch from AUR
# - Run sudo vmware-patch -fvk
# - Run sudo vmware-modconfig --console --install-all
# - Run this script
# - sudo /etc/init.d/vmware start OR restart

modprobe vmw_vmci
modprobe vmmon
modprobe vmnet
