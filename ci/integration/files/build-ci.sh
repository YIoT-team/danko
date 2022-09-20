#!/usr/bin/env bash

#  ────────────────────────────────────────────────────────────
#                     ╔╗  ╔╗ ╔══╗      ╔════╗
#                     ║╚╗╔╝║ ╚╣╠╝      ║╔╗╔╗║
#                     ╚╗╚╝╔╝  ║║  ╔══╗ ╚╝║║╚╝
#                      ╚╗╔╝   ║║  ║╔╗║   ║║
#                       ║║   ╔╣╠╗ ║╚╝║   ║║
#                       ╚╝   ╚══╝ ╚══╝   ╚╝
#    ╔╗╔═╗                    ╔╗                     ╔╗
#    ║║║╔╝                   ╔╝╚╗                    ║║
#    ║╚╝╝  ╔══╗ ╔══╗ ╔══╗  ╔╗╚╗╔╝  ╔══╗ ╔╗ ╔╗╔╗ ╔══╗ ║║  ╔══╗
#    ║╔╗║  ║║═╣ ║║═╣ ║╔╗║  ╠╣ ║║   ║ ═╣ ╠╣ ║╚╝║ ║╔╗║ ║║  ║║═╣
#    ║║║╚╗ ║║═╣ ║║═╣ ║╚╝║  ║║ ║╚╗  ╠═ ║ ║║ ║║║║ ║╚╝║ ║╚╗ ║║═╣
#    ╚╝╚═╝ ╚══╝ ╚══╝ ║╔═╝  ╚╝ ╚═╝  ╚══╝ ╚╝ ╚╩╩╝ ║╔═╝ ╚═╝ ╚══╝
#                    ║║                         ║║
#                    ╚╝                         ╚╝
#
#    Lead Maintainer: Roman Kutashenko <kutashenko@gmail.com>
#  ────────────────────────────────────────────────────────────

set -e

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"

ARM_CONF="CONFIG_TARGET_arm=y"
if [ $(cat .config | grep "${ARM_CONF}") == "${ARM_CONF}" ]; then
  CV2SE_CPU="raspberry-pi"
else
  CV2SE_CPU="x86_64"
fi
echo "========================"
echo "CPU is ${CV2SE_CPU}"

# Get start date/time
START=$(date +%y-%m/%d-%H/%M/%S)

# Update feeds
./scripts/feeds update -a
./scripts/feeds install -a -f

#
#   Copy prepared configuration
#
copy_configuration() {
   local PARAM_CONFIG="${1}"
   echo "--- Copy [${CV2SE_CPU}/${PARAM_CONFIG}] -> .config"
   cp -f "/yiot-ci/ci/configs/${CV2SE_CPU}/${PARAM_CONFIG}.config" "${SCRIPT_PATH}/.config"
   if [ "${?}" != "0" ]; then
     echo "Error copy configuration or file not found !"
     exit 127
   fi
}

if [ -z "${1}" ]; then
    copy_configuration "cv-2se"
else
    copy_configuration ${1}
fi

#
#   Fix configuration
#
make defconfig

NOW=$(date +%y%m%d-%H%M%S)
make  download 2>&1

make ${2} 2>&1

if [ "$?" = "0" ] ; then
	echo "========================"
	echo "BUILD SUCCESS!!!"
	echo "========================"
else
	echo "========================"
	echo "BUILD FAILED!!!"
	echo "========================"
	exit 1
fi

END=$(date +%y-%m/%d-%H/%M/%S)
echo "========================"
echo "BUILD START at $START !!"
echo "FINISH at $END !!"
echo "========================"

