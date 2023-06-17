#!/bin/bash
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Setup default target, multi-user
#--------------------------------------
# systemctl set-default multi-user.target

#======================================
# Set up the user skeleton for root user
#--------------------------------------
# cp -a /etc/skel/* /root/

#======================================
# Force localhost for hostname
#--------------------------------------
echo "localhost" > /etc/hostname
