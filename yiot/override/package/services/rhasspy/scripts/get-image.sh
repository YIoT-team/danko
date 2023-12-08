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
readonly YIOT_IMAGE="yiot/rhasspy"
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

echo "-------------------------------------------------------"
echo "- Repack image"
echo "-------------------------------------------------------"
rm -rf "${SCRIPT_PATH}/docker" || true
mkdir "${SCRIPT_PATH}/docker"
pushd "${SCRIPT_PATH}/docker"
    echo "FROM ${IMAGE}:${TAG} as initial"                         >   Dockerfile
    echo "FROM debian:buster-slim"                                      >>  Dockerfile
    echo "COPY --from=initial / /"                                      >>  Dockerfile
    echo "EXPOSE 12101"                                                 >>  Dockerfile
    echo 'ENTRYPOINT ["bash", "/usr/lib/rhasspy/bin/rhasspy-voltron"]'  >>  Dockerfile
    docker build -t "${YIOT_IMAGE}:${TAG}" .
popd

echo "-------------------------------------------------------"
echo "- Save Rhasspy image as a file"
echo "-------------------------------------------------------"
if [ ! -d ${IMAGE_DIR} ]; then
    mkdir -p ${IMAGE_DIR}
fi
echo "${YIOT_IMAGE}:${TAG}" > "${IMAGE_INFO_FILE}"
docker save -o "${DST_FILE}" ${YIOT_IMAGE}:${TAG}
