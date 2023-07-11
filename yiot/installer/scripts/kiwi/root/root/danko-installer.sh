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
readonly INC_DIR="${SCRIPT_FOLDER}/inc"
readonly SUPPORT_ETHERNET_SETTINGS=0

#   Include
source "${INC_DIR}/config.ish"
source "${INC_DIR}/image.ish"
source "${INC_DIR}/system.ish"
source "${INC_DIR}/ethernet.ish"
source "${INC_DIR}/drive.ish"
source "${INC_DIR}/ui.ish"
source "${INC_DIR}/menu/ethernet.ish"

# --------------------------------------------------------
main_menu () {
    ui_set_colors

    MENU=" "
    
    OPTIONS=(1 "Install YIoT Danko"
        2 "Open shell"
    3 "Reboot")

    ui_show_menu ${OPTIONS}

    case $CHOICE in
        1)
            drive_menu
        ;;
        2)
            bash
        ;;
        3)
            reboot
        ;;
    esac
}

# --------------------------------------------------------
drive_menu () {
    MENU="Choose destination disk:"
    
    tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/dialog$$
    trap "rm -f $tempfile" 0 1 2 5 15
    
    drive_enumerate

    OPTIONS=()
    local N_EL=1
    for DRIVE in "${DISK_ARR[@]}"; do
        OPTIONS+=("${N_EL}" "${DRIVE}")
        N_EL=$((N_EL+1))
    done
    OPTIONS+=("" "" "Back" "")
   
    ui_show_menu ${OPTIONS}
    retval=$?
    
    case $retval in
        0)
            if [[ $CHOICE != "Back" && $CHOICE != "" ]]; then
                CHOICE=$((CHOICE-1))
                INSTALL_PATH=${DISK_DEVICES[${CHOICE}]}
                if [ ${SUPPORT_ETHERNET_SETTINGS} eq 1]; then
                    ethernet_menu
                else
                    final_menu
                fi
            else
                main_menu
        fi;;
        1)
        echo "Cancel pressed.";;
        255)
        echo "ESC pressed.";;
    esac
}

# --------------------------------------------------------
final_menu () {
    ui_dialog "Do you want to install YIoT Danko on ${INSTALL_PATH}?"

    case $CHOICE in
        0)
            prepare_results
            image_repack
            image_install
            
            ui_dialog "Remove USB flash and press OK to boot YIoT Danko"
            system_hard_reboot
        ;;
        
        1)
            if [ ${SUPPORT_ETHERNET_SETTINGS} eq 1]; then
                ethernet_menu
            else
                drive_menu
            fi
        ;;
        255)
            if [ ${SUPPORT_ETHERNET_SETTINGS} eq 1]; then
                ethernet_menu
            else
                drive_menu
            fi
        ;;
    esac
}

# --------------------------------------------------------
#
#   Entry point
#
main_menu

# --------------------------------------------------------
