# EBBRT BAREMETAL TOOLCHAIN
# v1.1

-include config.mk

TARGET=x86_64-pc-ebbrt

BINARIES-DOWNLOAD ?= true
BINARIES-VERSION ?= 1.1

BINUTILS-VERSION ?= 2.26
NEWLIB-VERSION ?= 2.0.0
GCC-VERSION ?= 5.3.0

CD ?= cd
CP ?= cp
MKDIR ?= mkdir
TAR ?= tar
TOUCH ?= touch
WGET ?= wget
PATCH ?= patch

PREFIX ?= $(CURDIR)/install
SRCDIR := $(CURDIR)/src
BUILDDIR := $(CURDIR)/build
INSTALLDIR := $(PREFIX)
PATCHDIR ?= $(CURDIR)/patches
export PATH := $(PREFIX)/bin:$(PATH)

BINARIES-TAR ?=  EbbRT-toolchain-$(BINARIES-VERSION).tar.bz2
BINARIES-URL ?= https://github.com/SESA/EbbRT-toolchain/releases/download/v$(BINARIES-VERSION)/$(BINARIES-TAR)
BINARIES-TAR-PATH := $(SRCDIR)/$(BINARIES-TAR)

BINUTILS := binutils-$(BINUTILS-VERSION)
BINUTILS-TAR := $(BINUTILS).tar.bz2
BINUTILS-PATCH := $(BINUTILS).patch
BINUTILS-TAR-PATH := $(SRCDIR)/$(BINUTILS-TAR)
BINUTILS-SRC-PATH := $(SRCDIR)/$(BINUTILS)
BINUTILS-BUILD-PATH := $(BUILDDIR)/$(BINUTILS)
BINUTILS-PATCH-PATH := $(PATCHDIR)/$(BINUTILS-PATCH)
BINUTILS-URL ?= ftp://ftp.gnu.org/gnu/binutils/$(BINUTILS-TAR)
BINUTILS-CONFIGURE-FLAG := $(BINUTILS-BUILD-PATH)/Makefile
BINUTILS-BUILD-FLAG := $(BINUTILS-BUILD-PATH)/binutils-built
BINUTILS-INSTALL-FLAG := $(BINUTILS-BUILD-PATH)/binutils-installed

GCC := gcc-$(GCC-VERSION)
GCC-TAR := $(GCC).tar.bz2
GCC-PATCH := $(GCC).patch
GCC-TAR-PATH := $(SRCDIR)/$(GCC-TAR)
GCC-SRC-PATH := $(SRCDIR)/$(GCC)
GCC-BUILD-PATH := $(BUILDDIR)/$(GCC)
GCC-PATCH-PATH := $(PATCHDIR)/$(GCC-PATCH)
GCC-URL ?= ftp://ftp.gnu.org/gnu/gcc/$(GCC)/$(GCC-TAR)
GCC-CONFIGURE-FLAG := $(GCC-BUILD-PATH)/Makefile
GCC-BUILD-FLAG := $(GCC-BUILD-PATH)/gcc-built
GCC-INSTALL-FLAG := $(GCC-BUILD-PATH)/gcc-install
GCC-ALL-BUILD-FLAG := $(GCC-BUILD-PATH)/gcc-all-built
GCC-ALL-INSTALL-FLAG := $(GCC-BUILD-PATH)/gcc-all-installed
GCC-CFLAGS ?= CFLAGS="-O4 -flto"

NEWLIB := newlib-$(NEWLIB-VERSION)
NEWLIB-TAR := $(NEWLIB).tar.gz
NEWLIB-PATCH := $(NEWLIB).patch
NEWLIB-TAR-PATH := $(SRCDIR)/$(NEWLIB-TAR)
NEWLIB-SRC-PATH := $(SRCDIR)/$(NEWLIB)
NEWLIB-BUILD-PATH := $(BUILDDIR)/$(NEWLIB)
NEWLIB-PATCH-PATH := $(PATCHDIR)/$(NEWLIB-PATCH)
NEWLIB-URL ?= ftp://sourceware.org/pub/newlib/$(NEWLIB-TAR)
NEWLIB-CONFIGURE-FLAG := $(NEWLIB-BUILD-PATH)/Makefile
NEWLIB-BUILD-FLAG := $(NEWLIB-BUILD-PATH)/newlib-built
NEWLIB-INSTALL-FLAG := $(NEWLIB-BUILD-PATH)/newlib-installed
NEWLIB-CFLAGS ?= CFLAGS="-O4 -flto"

.PHONY: all fetch install download clean binaries-install
	
all: install 

fetch: binutils-fetch newlib-fetch gcc-fetch

install: 
ifeq '$(BINARIES-DOWNLOAD)' 'true'
	 $(MAKE) binaries-install 
else 
	$(MAKE)  gcc-all-install
endif 

download: $(BINARIES-TAR-PATH) 

binaries-install: $(BINARIES-TAR-PATH) $(INSTALLDIR)
	$(TAR) -xf $(BINARIES-TAR-PATH) --strip-components 1 -C $(INSTALLDIR)

$(BINARIES-TAR-PATH): | $(SRCDIR)
	$(WGET) $(BINARIES-URL) -O $(BINARIES-TAR-PATH)

clean:
	-$(RM) -r $(SRCDIR) $(BUILDDIR) $(INSTALLDIR)

$(SRCDIR):
	$(MKDIR) $(SRCDIR)

$(BUILDDIR):
	$(MKDIR) $(BUILDDIR)

$(INSTALLDIR):
	$(MKDIR) $(INSTALLDIR)

include binutils.mk
include gcc.mk 
include newlib.mk
