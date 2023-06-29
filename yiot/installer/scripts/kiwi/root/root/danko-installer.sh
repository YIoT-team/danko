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

#   Include
source "${INC_DIR}/config.ish"
source "${INC_DIR}/image.ish"
source "${INC_DIR}/system.ish"
source "${INC_DIR}/ethernet.ish"
source "${INC_DIR}/drive.ish"
source "${INC_DIR}/ui.ish"

# ---------------------------------------------------------
ethernet_mode_menu () {

    MENU="Setup ${1}"
    
    OPTIONS=(1 "Blink ethernet port"
    2 "Use as WAN"
    3 "Use as LAN"
    4 "Disable")

    ui_show_menu ${OPTIONS}

    clear
    case $CHOICE in
        1)
            eth_identify_port $1
            ethernet_menu
        ;;
        2)
            WAN=$CURRENT_MAC
            eth_lan_remove $CURRENT_MAC
            ethernet_menu
        ;;
        3)
            eth_lan_add $CURRENT_MAC
            if [[ "$CURRENT_MAC" == "$WAN" ]]; then
                WAN=""
            fi
            ethernet_menu
        ;;
        4)
            eth_lan_remove $CURRENT_MAC
            if [[ "$CURRENT_MAC" == "$WAN" ]]; then
                WAN=""
            fi
            ethernet_menu
        ;;
        255)
        echo "ESC pressed.";;
    esac
}

# --------------------------------------------------------
main_menu () {
    ui_set_colors

    MENU=" "
    
    OPTIONS=(1 "Install YIoT Danko"
        2 "Open shell"
    3 "Reboot")

    ui_show_menu ${OPTIONS}

    clear
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
    clear
    retval=$?
    
    case $retval in
        0)
            if [[ $CHOICE != "Back" && $CHOICE != "" ]]; then
                CHOICE=$((CHOICE-1))
                INSTALL_PATH=${DISK_DEVICES[${CHOICE}]}
                ethernet_menu
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
ethernet_menu () {
    eth_enumerate

    tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/dialog$$
    trap "rm -f $tempfile" 0 1 2 5 15
    
    MENU="Select interface to setup:"
    
    eth_mode "${NIC_NAMES[@]}"

    OPTIONS=()
    local N_EL=1
    for NETIF in "${NIC_ARR[@]}"; do
        OPTIONS+=("${N_EL}" "${NETIF}")
        N_EL=$((N_EL+1))
    done
    OPTIONS+=("" "" "Back" "" "Done" "")

    ui_show_menu ${OPTIONS}
    clear
    retval=$?

    case $retval in
        0)
            echo "${CHOICE}"
            if [[ "$CHOICE" == "Done" ]]; then
                if [ z"${WAN}" == "z" ] || [ z"${LAN}" == "z" ]; then
                    ui_message "Need to select WAN and LAN interfaces"
                    ethernet_menu
                else
                    clear
                    final_menu
                fi
            elif [[ $CHOICE == "Back" ]]; then
                drive_menu
            elif [[ "$CHOICE" != "" ]]; then
                CHOICE=$((CHOICE-1))
                local NIC="${NIC_NAMES[$CHOICE]}"
                CURRENT_MAC=$(eth_get_mac "${NIC}")
                ethernet_mode_menu "${NIC}"
            fi
            ;;
        1)
        echo "Cancel pressed.";;
        255)
        echo "ESC pressed.";;
    esac
}

# --------------------------------------------------------
final_menu () {
    ui_dialog "Do you want to install YIoT Danko on ${INSTALL_PATH}?"
    clear
    
    case $CHOICE in
        0)
            prepare_results
            image_repack
            image_install
            
            ui_dialog "Remove USB flash and press OK to boot YIoT Danko"
            system_hard_reboot
        ;;
        
        1)
            ethernet_menu
        ;;
        255)
            ethernet_menu
        ;;
    esac
}

# --------------------------------------------------------
#
#   Entry point
#
main_menu

# --------------------------------------------------------
