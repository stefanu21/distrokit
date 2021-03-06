# -*-makefile-*-
#
# Copyright (C) 2016 by Alexander Aring <aar@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_BAREBOX_RPI2) += barebox-rpi2

#
# Paths and names
#
BAREBOX_RPI2_VERSION	:= 2017.10.0
BAREBOX_RPI2_MD5	:= cae141fd919810397a7d539959d75aae
BAREBOX_RPI2		:= barebox-$(BAREBOX_RPI2_VERSION)
BAREBOX_RPI2_SUFFIX	:= tar.bz2
BAREBOX_RPI2_DIR	:= $(BUILDDIR)/barebox-rpi2-$(BAREBOX_RPI2_VERSION)
BAREBOX_RPI2_CONFIG	:= $(PTXDIST_PLATFORMCONFIGDIR)/barebox-rpi2.config
BAREBOX_RPI2_LICENSE	:= GPL-2.0
BAREBOX_RPI2_URL	:= $(call barebox-url, BAREBOX_RPI2)
BAREBOX_RPI2_SOURCE	:= $(SRCDIR)/$(BAREBOX_RPI2).$(BAREBOX_RPI2_SUFFIX)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

BAREBOX_RPI2_BLACKLIST := \
	TARGET_HARDEN_RELRO \
	TARGET_HARDEN_BINDNOW \
	TARGET_HARDEN_PIE \
	TARGET_DEBUG

BAREBOX_RPI2_CONF_ENV := KCONFIG_NOTIMESTAMP=1
BAREBOX_RPI2_CONF_OPT := $(call barebox-opts, BAREBOX_RPI2)

BAREBOX_RPI2_MAKE_ENV := $(BAREBOX_RPI2_CONF_ENV)
BAREBOX_RPI2_MAKE_OPT := $(BAREBOX_RPI2_CONF_OPT)

BAREBOX_RPI2_IMAGES := images/barebox-raspberry-pi-2.img
BAREBOX_RPI2_IMAGES := $(addprefix $(BAREBOX_RPI2_DIR)/,$(BAREBOX_RPI2_IMAGES))

ifdef PTXCONF_BAREBOX_RPI2
$(BAREBOX_RPI2_CONFIG):
	@echo
	@echo "****************************************************************************"
	@echo " Please generate a bareboxconfig with 'ptxdist menuconfig barebox-rpi2'"
	@echo "****************************************************************************"
	@echo
	@echo
	@exit 1
endif

$(STATEDIR)/barebox-rpi2.prepare: $(BAREBOX_RPI2_CONFIG)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

BAREBOX_RPI2_INSTALL_OPT := \
	$(call barebox-opts, BAREBOX_RPI2)

$(STATEDIR)/barebox-rpi2.install:
	@$(call targetinfo)
	@$(foreach image, $(BAREBOX_RPI2_IMAGES), \
		install -m 644 \
			$(image) $(IMAGEDIR)/$(notdir $(image))-rpi2;)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/barebox-rpi2.clean:
	@$(call targetinfo)
	@$(call clean_pkg, BAREBOX_RPI2)
	@$(foreach image, $(BAREBOX_RPI2_IMAGES), \
		rm -fv $(IMAGEDIR)/$(notdir $(image));)

# ----------------------------------------------------------------------------
# oldconfig / menuconfig
# ----------------------------------------------------------------------------

barebox-rpi2_oldconfig barebox-rpi2_menuconfig barebox-rpi2_nconfig: $(STATEDIR)/barebox-rpi2.extract
	@$(call world/kconfig, BAREBOX_RPI2, $(subst barebox-rpi2_,,$@))

# vim: syntax=make
