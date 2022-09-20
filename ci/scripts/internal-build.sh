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

set -e
SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"

source "${SCRIPT_PATH}/../docker/SETTINGS"
source ${SCRIPT_PATH}/inc/helpers.sh

CV2SE_PATH="$(realpath ${SCRIPT_PATH}/../..)"
CV2SE_ARTIFACTS_PATH="${CV2SE_PATH}/build-artifacts"
PARAM_WITHOUT_CLEAN="0"
PARAM_WITH_DEBUG="0"
PARAM_EXEC_PROFILE="default"
PARAM_OPENWRT_CONFIGURATION="cv-2se"

INTERNAL_BUILDNO=""

if [ ! -z "${BUILD_NUMBER}" ]; then
   EXTERNAL_BUILDNO="${BUILD_NUMBER}"
elif [ ! -z "${CI_PIPELINE_ID}" ]; then
   EXTERNAL_BUILDNO="${CI_PIPELINE_ID}"
else
   EXTERNAL_BUILDNO="0"
fi

# -----------------------------------------------------------------------------
print_usage() {
    echo
    echo "$(basename ${0}) < test | build  | rebuild> <parameters>"
    echo
    echo "- Build project:"
    echo "  $(basename ${0}) build"
    echo
    echo "  -a <string>           - Artifacts directory.                [default: ${CV2SE_ARTIFACTS_PATH}]"
    echo "  -e                    - Clean project before build"
    echo "  -c <string>           - OpenWRT configuration               [default: ${PARAM_OPENWRT_CONFIGURATION}]"
    echo "  -s <string>           - Project directory.                  [default: ${CV2SE_PATH}]"
    echo "  -t <string>           - Building profile.                   [default: default]"
    echo "  -d                    - Force Debug build. make -j1 V=s"
    echo
    echo "- Reuild project: - rebuild only needed modules (See build profile)"
    echo "  $(basename ${0}) rebuild"
    echo
    echo "  -a <string>           - Artifacts directory.                [default: ${CV2SE_ARTIFACTS_PATH}]"
    echo "  -s <string>           - Project directory.                  [default: ${CV2SE_PATH}]"
    echo "  -t <string>           - Rebuilding profile.                 [default: default]"
    echo "  -d                    - Force Debug build. make -j1 V=s"
    echo
    echo "- Testing sources: - check sources with PVS, cppcheck ... (See check profile)"
    echo "  $(basename ${0}) check"
    echo
    echo "  -s <string>           - Project directory.                  [default: ${CV2SE_PATH}]"
    echo "  -t <string>           - Checking profile.                   [default: default]"
    echo
    exit 0
}

# -----------------------------------------------------------------------------
PARAM_COMMAND="${1}"
if [ "${PARAM_COMMAND}" == "" ] || [ "${PARAM_COMMAND}" == "help" ]; then
    print_usage
    exit 0
fi

shift
while [ -n "$1" ]
do
    case "$1" in
        -h) print_usage
            ;;
        -t) PARAM_EXEC_PROFILE="$2"
            shift
            ;;
        -s) CV2SE_PATH="$2"
            shift
            ;;
        -a) CV2SE_ARTIFACTS_PATH="$2"
            shift
            ;;
        -c) PARAM_OPENWRT_CONFIGURATION="$2"
            shift
            ;;
        -e) PARAM_WITH_CLEAN="1"
            ;;
        -d) PARAM_WITH_DEBUG="1"
            ;;
    esac
    shift
done
# -----------------------------------------------------------------------------
do_exec_profile() {
  . ${SCRIPT_PATH}/inc/config/${PARAM_COMMAND}/${PARAM_EXEC_PROFILE}.sh
  return "${?}"
}

# -----------------------------------------------------------------------------
if [ "${PARAM_COMMAND}" == "" ] || [ "${PARAM_COMMAND}" == "help" ]; then
  print_usage
  exit 127
fi

if [ ! -d "${SCRIPT_PATH}/inc/config/${PARAM_COMMAND}" ]; then
    _log "ERROR: Command [${PARAM_COMMAND}] not found !"
    print_usage
    exit 127
fi

if [ ! -f "${SCRIPT_PATH}/inc/config/${PARAM_COMMAND}/${PARAM_EXEC_PROFILE}.sh" ]; then
    _log "ERROR: Profile [${PARAM_EXEC_PROFILE}] not found"
    print_usage
    exit 17
fi

_start "Executing [${PARAM_COMMAND}/${PARAM_EXEC_PROFILE}]"
do_exec_profile
if [ "${?}" == "0" ]; then
     _finish "OK"
  else
     _finish "ERROR: Executing [${PARAM_COMMAND}/${PARAM_EXEC_PROFILE}]"
fi

# -----------------------------------------------------------------------------
