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

if [ z"${PYTHON_BIN}" == z"" ]; then
    PYTHON_BIN="python"
fi

#
#   Log helper
#
# -----------------------------------------------------------------------------
function _log() {
    echo -e ${1}
}

#
#   Print title
#
# -----------------------------------------------------------------------------
function _title() {
    _log "########################################################"
    _log "# ${1}"
    _log "########################################################"
}

#
#   Print H1
#
# -----------------------------------------------------------------------------
function _h1() {
    _log "--------------------------------------------------------"
    _log "-- ${1}"
    _log "--------------------------------------------------------"
}

#
#   Print Info about action start
#
# -----------------------------------------------------------------------------
function _start() {
    _log ""
    _title "START: ${1}"
}

#
#   Print Info about action finish
#
# -----------------------------------------------------------------------------
function _finish() {
    _title "FINISH: ${1}"
    _log ""
}

#
#   Creat new folder
#
# -----------------------------------------------------------------------------
function _new_dir() {
    _log "# Create: ${1}"
    if [ -d "${1}" ]; then
        rm -rf "${1}"
    fi
    mkdir -p "${1}"
}

# -----------------------------------------------------------------------------
