#!/bin/bash

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

trap do_exit INT

set -e

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
source "${SCRIPT_PATH}/../docker/SETTINGS"
source ${SCRIPT_PATH}/inc/helpers.sh

CPU_TYPE="${1}"
BASE_PATH="$(realpath ${SCRIPT_PATH}/../..)"
OPENWRT_PATH="${BASE_PATH}/ext/openwrt"
FEEDS_PATH="${BASE_PATH}/yiot/override/feeds.conf"
BUILD_PATH="${BASE_PATH}/build-${CPU_TYPE}"

# -----------------------------------------------------------------------------
do_exit() {
  exit ${1}
}

# -----------------------------------------------------------------------------
prepare() {
  _title "Prepare project to build for ${CPU_TYPE}"

  _new_dir "${BUILD_PATH}"

  pushd "${BUILD_PATH}"

  _h1 "Copy OpenWRT"
  cp -rf ${OPENWRT_PATH}/* ./

  _h1 "Copy Feeds configuration"
  cp -rf ${FEEDS_PATH} ./

  popd

}

# -----------------------------------------------------------------------------

_new_dir "${BUILD_PATH}"

prepare


# -----------------------------------------------------------------------------
