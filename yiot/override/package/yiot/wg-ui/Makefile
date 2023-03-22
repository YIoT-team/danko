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
PKG_SOURCE_URL:=https://github.com/YIoT-team/wireguard-ui/archive/refs/tags
PKG_HASH:=1b86e7d7299889b100b58f560fb4be7effe17e5e77e7ee295aa227b46bec42e9

PKG_BUILD_DIR:=$(BUILD_DIR)/wireguard-ui-$(PKG_VERSION)
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/ngoduykhanh/wireguard-ui

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
	cd $(PKG_BUILD_DIR) && ./prepare_assets.sh
	# cd $(PKG_BUILD_DIR) && rice embed-go 
	$(call GoPackage/Build/Compile)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/yiot-wg-ui.init $(1)/etc/init.d/yiot-wg-ui

	$(INSTALL_DIR) $(1)/etc/nginx/conf.d
	$(INSTALL_BIN) ./files/yiot-wg-ui.locations $(1)/etc/nginx/conf.d/yiot-wg-ui.locations

	$(INSTALL_DIR) $(1)/opt/yiot-wg-ui
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/wireguard-ui $(1)/opt/yiot-wg-ui/yiot-wg-ui
	
	$(INSTALL_DIR) $(1)/opt/yiot-wg-ui/github.com/ngoduykhanh/wireguard-ui
	$(CP) -L $(PKG_BUILD_DIR)/assets $(1)/opt/yiot-wg-ui/github.com/ngoduykhanh/wireguard-ui/
	$(CP) -L $(PKG_BUILD_DIR)/templates $(1)/opt/yiot-wg-ui/github.com/ngoduykhanh/wireguard-ui/
endef


$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))