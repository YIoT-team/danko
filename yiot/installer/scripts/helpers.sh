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


#
#   Log helper
#
function _log() {
    echo -e ${1}
}

#
#   Error handler
#
function err_trap() {
    err_code=$?
    # ${FUNCNAME[*]} : err_trap print_message main
    # call from subfunction: lenght = 3
    # ${FUNCNAME[*]} : err_trap  main
    # call from main: lenght = 2
    arr_shift=$((${#FUNCNAME[@]} - 2))
    # if arr_shift eq 0. we need to ommit FUNCTION and ARGUMENTS
    echo "##############################################################################"
    echo "### SCRIPT ERROR AT $0, IN LINE ${BASH_LINENO[$arr_shift]}"
    [ $arr_shift -ne 0 ] && echo "### BASH FUNCTION NAME: ${FUNCNAME[$arr_shift]}"
    echo "### BASH COMMAND: ${BASH_COMMAND[*]}"
    [ $arr_shift -ne 0 ] && echo "### COMMAND ARGUMENTS: $@"
    echo "### ERRORCODE: $err_code"
    echo "##############################################################################"
    exit 127
}

#
#   Print title
#
function _title() {
    _log "########################################################"
    _log "# ${1}"
    _log "########################################################"
}

#
#   Print Info about action start
#
function _start() {
    _log ""
    _title "START: ${1}"
}

#
#   Print Info about action finish
#
function _finish() {
    _title "FINISH: ${1}"
    _log ""
}

#
#   Creat new folder
#
function _new_dir() {
    _log "# Create: ${1}"
    if [ -d "${1}" ]; then
        rm -rf "${1}"
    fi
    mkdir -p "${1}"
}

# -----------------------------------------------------------------------------
