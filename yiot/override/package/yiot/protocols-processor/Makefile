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

PKG_NAME:=yiot-cv2se
PKG_VERSION:=0.0.1
PKG_RELEASE:=1
PKG_LICENSE:=Apache-2.0 MIT
PKG_LICENSE_FILES:=LICENSE-APACHE LICENSE-MIT

USE_SOURCE_DIR:=$(shell pwd)/src

PKG_BUILD_DEPENDS:=rust/host

CARGO_HOME := $(STAGING_DIR_HOST)
TARGET_CONFIGURE_OPTS += CARGO_HOME="$(STAGING_DIR_HOST)"

include $(INCLUDE_DIR)/package.mk

CONFIG_HOST_SUFFIX:=$(shell cut -d"-" -f4 <<<"$(GNU_HOST_NAME)")
RUSTC_HOST_ARCH:=$(HOST_ARCH)-unknown-linux-$(CONFIG_HOST_SUFFIX)
RUSTC_TARGET_ARCH:=$(REAL_GNU_TARGET_NAME)

CONFIGURE_VARS += \
        CARGO_HOME="$(CARGO_HOME)" \
        ac_cv_path_CARGO="$(STAGING_DIR_HOST)/bin/cargo" \
        ac_cv_path_RUSTC="$(STAGING_DIR_HOST)/bin/rustc" \
        RUSTFLAGS="-C linker=$(TARGET_CC_NOCACHE) -C ar=$(TARGET_AR)"

CONFIGURE_ARGS += \
  	--host=$(REAL_GNU_TARGET_NAME)

define Build/Compile
        cd $(PKG_BUILD_DIR) && $(TARGET_CONFIGURE_OPTS) $(CONFIGURE_VARS) cargo update && \
	  $(TARGET_CONFIGURE_OPTS) $(CONFIGURE_VARS) cargo build -v --release \
	  --target $(REAL_GNU_TARGET_NAME)
endef

define Package/$(PKG_NAME)
    SECTION:=yiot
    CATEGORY:=YIoT Applications
    TITLE:=YIoT CV-2SE Protocols processor
    DEPENDS:=@!SMALL_FLASH @!LOW_MEMORY_FOOTPRINT
    URL:=https://github.com/neg2led
endef

define Package/$(PKG_NAME)/description
  YIoT CV-2SE Protocols processor
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/yiot-cv2se.init $(1)/etc/init.d/yiot-cv2se
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(REAL_GNU_TARGET_NAME)/release/cv2se $(1)/usr/bin/$(PKG_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))