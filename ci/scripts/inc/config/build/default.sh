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

export PATH=${PATH}:${CV2SE_PATH}/staging_dir/host/bin

export CV2SE_ARTIFACTS_PATH

if [ "${PARAM_WITH_DEBUG}" == "1" ]; then
  BUILD_PARAM="V=s -j1"
else
  BUILD_PARAM="-j10"
fi

pushd ${CV2SE_PATH}
   INTERNAL_BUILDNO="1"
   if [ "${PARAM_WITH_CLEAN}" == "1" ]; then
      local STAGE_NAME="Clean sources"
      _start "${STAGE_NAME}"
      make distclean
      _finish  "${STAGE_NAME}"
   fi


   local STAGE_NAME="Building images"
   _start "${STAGE_NAME}"
   ./build-ci.sh "${PARAM_OPENWRT_CONFIGURATION}"  "${BUILD_PARAM}"
   _finish  "${STAGE_NAME}"

   local STAGE_NAME="Archiving artifacts"
   mkdir -p ${CV2SE_ARTIFACTS_PATH}
   _start "${STAGE_NAME}"

  cp -f ${CV2SE_PATH}/common/build/bin/* ${CV2SE_ARTIFACTS_PATH}/

  cp -f ${CV2SE_PATH}/* ${CV2SE_ARTIFACTS_PATH}/
  _finish  "${STAGE_NAME}"
popd
