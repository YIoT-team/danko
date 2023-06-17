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

#   Files



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

    # if [ ! -f "${YIOT_IMAGE}" ]; then
    #     echo "ERROR: cannot find image file ${YIOT_IMAGE}"
    #     echo "USAGE: ${0} <path to YIoT image>"
    #     exit 1
    # fi

    _new_dir "${ARTEFACTS_DIR}"
    _new_dir "${BUILD_CACHE_DIR}"

    cp -f "${CONFIG_FOLDER}"/* "${BUILD_CACHE_DIR}"

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

        kiwi-ng system build --description . --target "${BUILD_CACHE_DIR}"
    
    popd

    _finish "${OP_NAME}"
}

# -----------------------------------------------------------------------------
#
#   Save artefacts
#
function save_artefacts() {
    local OP_NAME="Save Artevfacts"
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
