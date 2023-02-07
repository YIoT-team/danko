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

include $(TOPDIR)/rules.mk

PKG_NAME:=yiot-wg-ui
PKG_VERSION:=0.0.1
PKG_RELEASE:=$(SUBTARGET)

https://github.com/YIoT-team/wireguard-ui/archive/refs/tags/v0.0.1.tar.gz

PKG_SOURCE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/YIoT-team/wireguard-ui/archive/refs/tags/$(PKG_SOURCE)
# PKG_HASH:=e35824e19e8acc06296ce6bfa78a14a6f3ee8f42a965f7762b7056b506457a29

PKG_BUILD_DIR:=$(BUILD_DIR)/wireguard-ui-$(PKG_VERSION)
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=yiot_api
GO_PKG_BUILD_PKG:=$$(GO_PKG)

GO_PKG_TAGS:=full
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/constant.Version=v$(PKG_VERSION) \
	$(GO_PKG)/constant.Commit=v$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk


define Package/$(PKG_NAME)
  SECTION:=yiot
  CATEGORY:=YIoT Applications
  TITLE:=YIoT WireGuard UI
  MAINTAINER:=Roman Kutashenko <kutashenko@gmail.com>
  DEPENDS:=$$(GO_ARCH_DEPENDS)
endef

define Package/$(PKG_NAME)/config
menu "Configuration"
	depends on PACKAGE_$(PKG_NAME)

endmenu
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
endef

# define Package/$(PKG_NAME)/install
# 	$(INSTALL_DIR) $(1)/etc/init.d
# 	$(INSTALL_BIN) ./files/yiot-backend.init $(1)/etc/init.d/yiot-backend
# 	$(INSTALL_DIR) $(1)/usr/bin
# 	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/yiot_api $(1)/usr/bin/yiot-backend
# endef


$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))