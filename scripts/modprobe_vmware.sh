#!/usr/bin/env sh

# How to install VMware Workstation 15.5.1 on Arch Linux
# - Install linux-headers with the same version as system kernel
#  version (uname -r)
# - Read and follow the Arch Linux Guide for VMware
# - Change the /etc/init.d/vmware, the global variable mod=vmw_vmci,
#  search for the 'vmwareStartVmci' function, edit vmci=vmw_vmci
# - tar -xzf workstation-15.5.1.tar.gz
# - cd vmware-host-modules-workstation-15.5.1
# - make
# - sudo make install
# 
# if for some reason still isn't completed
# - Install vmware-patch from AUR
# - Run sudo vmware-patch -fvk
# - Run sudo vmware-modconfig --console --install-all
# - Run this script
# - sudo /etc/init.d/vmware start

modprobe vmw_vmci
modprobe vmmon
modprobe vmnet
