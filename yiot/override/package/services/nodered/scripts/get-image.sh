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
readonly DST_FILE="${IMAGE_DIR}/nodered.tar"
readonly IMAGE_INFO_FILE="${IMAGE_DIR}/nodered"

readonly IMAGE="nodered/node-red"
readonly YIOT_IMAGE="yiot/node-red"
readonly TAG="3.0.2-14"

if [ "${1}" == "RPi4" ]; then
    readonly PLATFORM="linux/arm64"
else
    readonly PLATFORM="linux/amd64"
fi

echo "-------------------------------------------------------"
echo "- Clean NodeRed images"
echo "-------------------------------------------------------"
docker image rm ${IMAGE}:${TAG} || true

echo "-------------------------------------------------------"
echo "- Pull NodeRed ${TAG}"
echo "-------------------------------------------------------"
docker pull --platform ${PLATFORM} ${IMAGE}:${TAG}

echo "-------------------------------------------------------"
echo "- Repack image"
echo "-------------------------------------------------------"
rm -rf "${SCRIPT_PATH}/docker" || true
mkdir "${SCRIPT_PATH}/docker"
pushd "${SCRIPT_PATH}/docker"
    echo "FROM ${IMAGE}:${TAG} as initial"                              >   Dockerfile
    echo "FROM mhart/alpine-node:4"                                     >>  Dockerfile
    echo "COPY --from=initial / /"                                      >>  Dockerfile
    echo "EXPOSE 1880"                                                  >>  Dockerfile
    echo "ENV FLOWS=flows.json"                                         >>  Dockerfile
    echo 'CMD ["npm", "start", "--", "--userDir", "/data"]'             >>  Dockerfile
    docker build -t "${YIOT_IMAGE}:${TAG}" .
popd

echo "-------------------------------------------------------"
echo "- Save NodeRed image as a file"
echo "-------------------------------------------------------"
if [ ! -d ${IMAGE_DIR} ]; then
    mkdir -p ${IMAGE_DIR}
fi
echo "${YIOT_IMAGE}:${TAG}" > "${IMAGE_INFO_FILE}"
docker save -o "${DST_FILE}" ${YIOT_IMAGE}:${TAG}
