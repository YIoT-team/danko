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
# Set installation script as a shell for a root user
#--------------------------------------
usermod --shell /root/danko-installer.sh root

#======================================
# Enable autologin
#--------------------------------------
sed -i 's|ExecStart=.*|ExecStart=-/sbin/agetty --noclear -a root %I $TERM|g' /lib/systemd/system/getty@.service

#======================================
# Activate services
#--------------------------------------
baseInsertService dbus-broker
baseInsertService NetworkManager

#======================================
# Setup default target, single-user
#--------------------------------------
baseSetRunlevel 1
