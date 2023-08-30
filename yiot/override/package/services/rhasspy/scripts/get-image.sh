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

#!/bin/bash

readonly SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
readonly IMAGE_DIR="${SCRIPT_PATH}/../files/images"
readonly DST_FILE="${IMAGE_DIR}/rhasspy.tar"
readonly IMAGE_INFO_FILE="${IMAGE_DIR}/rhasspy"

readonly IMAGE="rhasspy/rhasspy"
readonly TAG="2.5.11"

if [ "${1}" == "RPi4" ]; then
    readonly PLATFORM="linux/arm64"
else
    readonly PLATFORM="linux/amd64"
fi

echo "-------------------------------------------------------"
echo "- Clean Rhasspy images"
echo "-------------------------------------------------------"
docker image rm ${IMAGE}:${TAG} || true

echo "-------------------------------------------------------"
echo "- Pull Rhasspy ${TAG}"
echo "-------------------------------------------------------"
docker pull --platform ${PLATFORM} ${IMAGE}:${TAG}
echo "${IMAGE}:${TAG}" > "${IMAGE_INFO_FILE}"

echo "-------------------------------------------------------"
echo "- Save Rhasspy image as a file"
echo "-------------------------------------------------------"
if [ ! -d ${IMAGE_DIR} ]; then
    mkdir -p ${IMAGE_DIR}
fi
docker save -o "${DST_FILE}" ${IMAGE}:${TAG}
