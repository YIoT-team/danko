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

#   Global variables
readonly SCRIPT_FOLDER="$(cd "$(dirname "$0")" && pwd)"
readonly ARTEFACTS_DIR="${SCRIPT_FOLDER}/artefacts"
readonly BUILD_CACHE_DIR="${SCRIPT_FOLDER}/tmp"
readonly CONFIG_FOLDER="${SCRIPT_FOLDER}/kiwi"

#   Params
readonly YIOT_IMAGE="${1}"

#   Include helpers
source "${SCRIPT_FOLDER}/helpers.sh"

#   Catch errors
set -o errtrace
trap 'err_trap  $@' ERR

# -----------------------------------------------------------------------------
#
#   Prepare
#
function prepare() {
    local OP_NAME="Prapare"
    _start "${OP_NAME}"

    # Check parameters
    if [ ! -f "${YIOT_IMAGE}" ]; then
        echo "ERROR: cannot find image file ${YIOT_IMAGE}"
        echo "USAGE: ${0} <path to YIoT image>"
        exit 1
    fi

    # Prepare folders
    _new_dir "${ARTEFACTS_DIR}"
    _new_dir "${BUILD_CACHE_DIR}"

    # Copy data files
    cp -rf "${CONFIG_FOLDER}"/* "${BUILD_CACHE_DIR}"

    # Copy YIoT Danko
    cp -f "${YIOT_IMAGE}" "${BUILD_CACHE_DIR}/root/root/yiot.img.gz"

    # Unpack image
    pushd "${BUILD_CACHE_DIR}/root/root"
        gzip -d yiot.img.gz || true
        if [ ! -f yiot.img ]; then
            echo "ERROR: There is no decompressed image file"
            exit -1
        fi
    popd

    _finish "${OP_NAME}"
}

# -----------------------------------------------------------------------------
#
#   Build
#
function build() {
    local OP_NAME="Live Image build"
    _start "${OP_NAME}"

    pushd "${BUILD_CACHE_DIR}"

        kiwi-ng --type iso --profile Live system build --description . --target "${BUILD_CACHE_DIR}"
    
    popd

    _finish "${OP_NAME}"
}

# -----------------------------------------------------------------------------
#
#   Save artefacts
#
function save_artefacts() {
    local OP_NAME="Save Artefacts"
    _start "${OP_NAME}"

    pushd "${BUILD_CACHE_DIR}"

        mv ./*.iso "${ARTEFACTS_DIR}"
    
    popd

    _finish "${OP_NAME}"
}

# -----------------------------------------------------------------------------
#
#   Clean
#
function clean() {
    local OP_NAME="Clean"
    _start "${OP_NAME}"

    rm -rf "${BUILD_CACHE_DIR}"

    _finish "${OP_NAME}"
}

# -----------------------------------------------------------------------------
#
#   Main
#
prepare
build
save_artefacts
# clean
