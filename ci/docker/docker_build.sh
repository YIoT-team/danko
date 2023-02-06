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

SCRIPT_PATH="$(cd $(dirname "$0") && pwd)"
pushd "${SCRIPT_PATH}"
    . ./SETTINGS

    # Check jinja console tool installed
    pip show j2cli
    if [ "$?" != "0" ]; then
     pip install j2cli
    fi

    # Exported variables for jinja processor
    export BUILDDATE=$(date +%Y%m%d)
    export IMAGENAME
    export IMGVERS1
    export IMGVERS2
    export PVS_LICENSE="${PVS_LICENSE:-NONE NONE}"

    j2 -f env -o dockerfiles/Dockerfile     dockerfiles/Dockerfile.tmpl
    j2 -f env -o dockerfiles/entrypoint.sh  dockerfiles/entrypoint.sh.tmpl

    # Prepare Flutter
    if [ ! -d dockerfiles/flutter ]; then
        wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.3.10-stable.tar.xz
        pushd dockerfiles
            tar xf ../flutter_linux_3.3.10-stable.tar.xz
        popd
    fi

    docker build -t "$LIBRARY"/"$IMAGENAME":"$IMGVERS1" -t "$LIBRARY"/"$IMAGENAME":"$IMGVERS2" dockerfiles
popd

