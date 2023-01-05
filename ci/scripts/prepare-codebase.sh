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

CI_PATH="$(realpath ${SCRIPT_PATH}/../..)"
YIOT_SRC_DIR="${CI_PATH}/yiot"

CPU_TYPE="${1}"
BASE_PATH="$(realpath ${SCRIPT_PATH}/../..)"
OPENWRT_PATH="${BASE_PATH}/ext/openwrt"
FEEDS_PATH="${BASE_PATH}/yiot/override/feeds.conf"
BUILD_PATH="${BASE_PATH}/build-${CPU_TYPE}"
OVERLAY_TMP="${BASE_PATH}/ovtmp_${CPU_TYPE}"

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
prepare_overlay_one() {
  _h1 "Prepare overlayfs directory ${1}"
  mkdir -p ${OVERLAY_TMP}/work_${1}
  mv -f ${OPENWRT_PATH}/${1} ${OVERLAY_TMP}
  mkdir -p ${OPENWRT_PATH}/${1}
}

# -----------------------------------------------------------------------------
prepare_overlay() {
  prepare_overlay_one package
  prepare_overlay_one target
  # prepare_overlay_one files
}

# -----------------------------------------------------------------------------
mount_overlay_one() {
  _h1 "Mounting overlayfs ${1}"

  LOWER_DIR=${OVERLAY_TMP}/${1}
  UPPER_DIR=${YIOT_SRC_DIR}/override/${1}
  WORK_DIR=${OVERLAY_TMP}/work_${1}

  echo "point    :  ${BUILD_PATH}/${1}"
  echo "lowerdir :  ${LOWER_DIR}"
  echo "upperdir :  ${UPPER_DIR}"
  echo "workdir  :  ${WORK_DIR}"

  mountpoint -q ${BUILD_PATH}/${1} || sudo mount -t overlay overlay -o lowerdir=${LOWER_DIR},upperdir=${UPPER_DIR},workdir=${WORK_DIR} ${BUILD_PATH}/${1}
}

# -----------------------------------------------------------------------------
mount_overlay() {
  mount_overlay_one package
  mount_overlay_one target
  # mount_overlay_one files
}

# -----------------------------------------------------------------------------

_new_dir "${BUILD_PATH}"

prepare

if [ ! -d ${OVERLAY_TMP} ]; then
  prepare_overlay
fi

mount_overlay

# -----------------------------------------------------------------------------
