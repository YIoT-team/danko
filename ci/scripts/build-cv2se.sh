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

trap do_exit INT

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
source "${SCRIPT_PATH}/../docker/SETTINGS"
source ${SCRIPT_PATH}/inc/helpers.sh

CI_PATH="$(realpath ${SCRIPT_PATH}/../..)"
YIOT_SRC_DIR="${CI_PATH}/yiot"
OPENWRT_PATH="${CI_PATH}/ext/openwrt"

#   Docker
DOCKER_BASE_IMAGE="${LIBRARY}/${IMAGENAME}:${IMGVERS1}"
PARAM_WITH_DEBUG=""
PARAM_WITH_SHELL="0"
PARAM_BUILD_PROFILE="default"
PARAM_OPENWRT_CONFIGURATION="cv-2se"
DOCKER_USER=$([ $(id -u) == '0' ] && echo "root" || echo "jenkins")

PARAM_CPU="x86_64"

# -----------------------------------------------------------------------------
print_usage() {
    echo
    echo "$(basename ${0}) < shell | build > <parameters>"

    echo
    echo "- Run shell:"
    echo "  $(basename ${0}) shell"

    echo
    echo "- Build project (copy project to chacke directory and build):"
    echo "  $(basename ${0}) build"
    echo
    echo "  -a <string>           - Artifacts directory.                                [default: [${CV2SE_ARTIFACTS_PATH}]"
    echo "  -p <string>           - Project source directory                            [default: [${CV2SE_PATH}]"
    echo "  -t                    - Building profile                                    [default: [default]"
    echo "  -d                    - Force Debug build. make -j1 V=s"
    echo "  -c                    - OpenWRT configuration                               [default: [${PARAM_OPENWRT_CONFIGURATION}]"
    echo "  -q                    - CPU type                                            [default: [${PARAM_CPU}]"
    echo "  -s                    - Run shell after build"

    echo
    echo "- Rebuild project from build chache:"
    echo "  $(basename ${0}) rebuild"
    echo
    echo "  -a <string>           - Artifacts directory.                                [default: [${CV2SE_ARTIFACTS_PATH}]"
    echo "  -p <string>           - Project source directory                            [default: [${CV2SE_PATH}]"
    echo "  -t                    - Rebuilding profile                                  [default: [default]"
    echo "  -d                    - Force Debug build. make -j1 V=s"
    echo "  -q                    - CPU type                                            [default: [${PARAM_CPU}]"
    echo "  -s                    - Run shell after build"    
    echo
    echo "- Check sources with PVS-Studio:"
    echo "  $(basename ${0}) check"
    echo
    echo "  -a <string>           - Artifacts directory.                                [default: [${CV2SE_ARTIFACTS_PATH}]"
    echo "  -p <string>           - Project source directory                            [default: [${CV2SE_PATH}]"
    echo "  -t                    - Checking profile                                    [default: [default]"
    echo "  -s                    - Run shell after build"

    exit 0
}

# -----------------------------------------------------------------------------
find_tool() {
    local PARAM_CMD="${1}"
    RES_TMP="$(which ${PARAM_CMD} 2>&1)"
    if [ "${?}" != "0" ]; then
      echo "Tools [${PARAM_CMD}] NOT FOUND (Please install first)"
      return 127
    fi
    return 0
}


# -----------------------------------------------------------------------------
check_not_empty() {
    if [ z"${1}" == "z" ]; then
        echo "${2}"
    fi
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
        -a) CV2SE_ARTIFACTS="$2"
            shift
            ;;
        -p) CV2SE_PATH="$2"
            shift
            ;;            
        -t) PARAM_BUILD_PROFILE="$2"
            shift
            ;;
        -c) PARAM_OPENWRT_CONFIGURATION="$2"
            shift
            ;;
        -q) PARAM_CPU="$2"
            CV2SE_PATH="${CI_PATH}/build-${PARAM_CPU}"
            CV2SE_ARTIFACTS_PATH="${CI_PATH}/build-${PARAM_CPU}/build-artifacts"
            DOCKER_CONTAINER_NAME="${IMAGENAME}_build_${JOB_NAME:-NONE}_${PARAM_CPU}_${BUILD_NUMBER:-0}"
            shift
            ;;
        -d) PARAM_WITH_DEBUG="-d"
            ;;
        -s) PARAM_WITH_SHELL="1"
            ;;
        *) print_usage;;
    esac
    shift
done

CV2SE_PATH="${CI_PATH}/build-${PARAM_CPU}"
CV2SE_ARTIFACTS_PATH="${CI_PATH}/build-${PARAM_CPU}/build-artifacts"
DOCKER_CONTAINER_NAME="${IMAGENAME}_build_${JOB_NAME:-NONE}_${PARAM_CPU}_${BUILD_NUMBER:-0}"

OVERLAY_TMP="${CI_PATH}/ovtmp_${PARAM_CPU}"
BUILD_PATH="${CI_PATH}/build-${PARAM_CPU}"

# -----------------------------------------------------------------------------
docker_check_privileges() {
    sudo docker ps 2>&1 >/dev/null
    if [ "${?}" != "0" ]; then
       _log "ERROR: Docker not runing or not accessed"
       return 127
    else
       _log "OK"
       return 0
    fi
}

# -----------------------------------------------------------------------------
docker_rm() {
    _log "Remove container [${DOCKER_CONTAINER_NAME}]"
    TEMP_LOG=$(sudo docker rm -f ${DOCKER_CONTAINER_NAME} 2>&1 || true)
}

# -----------------------------------------------------------------------------
docker_shell() {
    _log "Exec shell"
    sudo docker exec -ti -u ${DOCKER_USER} ${DOCKER_CONTAINER_NAME} /bin/bash
}

# -----------------------------------------------------------------------------
docker_exec() {
     local PARAM_COMMAND="${@}"
    _log "Exec command [${PARAM_COMMAND}]"
    sudo docker exec --tty -u ${DOCKER_USER} ${DOCKER_CONTAINER_NAME} /bin/bash -c ". /etc/bashrc; ${PARAM_COMMAND}"
    RET_RES="${?}"
    if [ "${RET_RES}" != "0" ]; then
       _log "ERROR: execute command [${PARAM_COMMAND}]"
       return 127
    else
       return 0
    fi
}

# -----------------------------------------------------------------------------
docker_run() {
    _h1 "Run container"

    CCACHE_DIR="${HOME}/ccache"

    local PARAM_DOCKER_PARAMETERS="${@}"
    docker_rm
    sudo docker pull ${DOCKER_BASE_IMAGE}
    mkdir -p ${CV2SE_ARTIFACTS_PATH}
    mkdir -p ${CCACHE_DIR}
    sudo docker run -d --rm --name "${DOCKER_CONTAINER_NAME}" \
    --privileged --sysctl=net.ipv6.conf.all.disable_ipv6=0 \
    -e BUILD_UID="$(id -u)" -e BUILD_GID="$(id -g)" \
    -e BUILD_NUMBER="${BUILD_NUMBER}" -e CI_PIPELINE_ID="${CI_PIPELINE_ID}" \
    -v ${CI_PATH}:/yiot-ci \
    -v ${CV2SE_ARTIFACTS_PATH}:/build-artifacts \
    -v ${CV2SE_PATH}:/yiot-base \
    -v ${CCACHE_DIR}:/home/${DOCKER_USER}/.ccache \
    ${DOCKER_BASE_IMAGE}
    if [ "${?}" != "0" ]; then
       _log "ERROR: Docker run error"
       return 127
    fi
    _h1 "Waiting container started"
    sudo docker exec --tty ${DOCKER_CONTAINER_NAME} /bin/bash -c ". /etc/bashrc; /usr/local/bin/started.sh" || do_exit 127

   _log "OK"
   return 0
}

# -----------------------------------------------------------------------------
prepare_overlay_one() {
  _h1 "Prepare overlayfs directory ${1}"
  mkdir -p ${OVERLAY_TMP}/work_${1}
  cp -R ${OPENWRT_PATH}/${1} ${OVERLAY_TMP}
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
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
do_exit() {
  docker_rm
  exit ${1}
}

# -----------------------------------------------------------------------------
do_shell() {
  _h1 "Runing container shell"
  docker_run
  if [ "${?}" != "0" ]; then
    exit 127
  fi
  docker_shell
  do_exit 0
}

# -----------------------------------------------------------------------------
do_build() {
  _h1 "Building OpenWRT"
  docker_run
  if [ "${?}" != "0" ]; then
    _log "ERROR: running docker container"
    exit 127
  fi

  _start "Prepare ci integration"
  docker_exec "cp -f /yiot-ci/ci/integration/files/build-ci.sh /yiot-base/"         || do_exit 127

  _start "Update feeds"
  if [ ! -d "${BUILD_PATH}/feeds" ]; then
    docker_exec "cd /yiot-base/ && ./scripts/feeds update -a"         || do_exit 127
    docker_exec "cd /yiot-base/ && ./scripts/feeds install -a -f"     || do_exit 127
  fi

  _start "Prepare Overlay"  
  if [ ! -d ${OVERLAY_TMP} ]; then
    prepare_overlay
  fi
  mount_overlay

  _start "Building project"
  docker_exec "/yiot-ci/ci/scripts/internal-build.sh ${PARAM_COMMAND} ${PARAM_WITH_DEBUG} -a /build-artifacts -s /yiot-base -t ${PARAM_BUILD_PROFILE} -c ${PARAM_OPENWRT_CONFIGURATION}"
  if [ "${?}" == "0" ]; then
     _finish "OK"
  else
     _finish "ERROR"
     [ "${PARAM_WITH_SHELL}" == "0" ] && do_exit 127
  fi

  if [ "${PARAM_WITH_SHELL}" == "1" ]; then
     docker_shell
  fi
  do_exit 0
}

# -----------------------------------------------------------------------------

if [ ! -d "${CV2SE_PATH}" ]; then
    "${SCRIPT_PATH}/prepare-codebase.sh" ${PARAM_CPU}
fi

_h1 "--- Detecting tools"
find_tool realpath || FIND_RES=1
find_tool docker || FIND_RES=1
find_tool basename || FIND_RES=1
if [ "${FIND_RES}" == "1" ]; then
 _log "Please install required tools"
 exit 127
else
 _log "OK".
fi

# Check docker access
_h1 "--- Check Docker privileges"
docker_check_privileges
if [ "${?}" != "0" ]; then
  exit 127
fi

# Argv parse for command
case "${PARAM_COMMAND}" in
  shell)        do_shell
                ;;
  build)        do_build
                ;;
  rebuild)      do_build
                ;;
  check)        do_build
                ;;
        *)      echo "Error command"
                print_usage
                exit 127
                ;;
esac

# -----------------------------------------------------------------------------
