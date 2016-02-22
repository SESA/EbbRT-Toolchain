newlib: newlib-install

$(NEWLIB-SRC-PATH): | $(NEWLIB-TAR-PATH) $(SRCDIR)
	$(TAR) -xf $(NEWLIB-TAR-PATH) -C $(SRCDIR)
	$(PATCH) -p1 -l -s -d $(NEWLIB-SRC-PATH) -i $(NEWLIB-PATCH-PATH)

$(NEWLIB-TAR-PATH): | $(SRCDIR)
	$(WGET) $(NEWLIB-URL) -O $(NEWLIB-TAR-PATH)

$(NEWLIB-BUILD-PATH): | $(BUILDDIR)
	$(MKDIR) $(BUILDDIR)/$(NEWLIB)

$(NEWLIB-CONFIGURE-FLAG): | $(BINUTILS-INSTALL-FLAG) $(GCC-INSTALL-FLAG) $(NEWLIB-SRC-PATH) $(NEWLIB-BUILD-PATH)
	$(CD) $(NEWLIB-SRC-PATH)/newlib/libc/sys && autoconf2.64 && \
	$(CD) $(NEWLIB-SRC-PATH)/newlib/libc/sys/ebbrt && autoreconf && \
	$(CD) $(NEWLIB-BUILD-PATH) && $(NEWLIB-SRC-PATH)/configure \
		--target=$(TARGET) --prefix=$(PREFIX) \
		--with-gmp=$(PREFIX) --with-mpft=$(PREFIX) \
		--with-mpc=$(PREFIX) --enable-newlib-hw-fd

$(NEWLIB-BUILD-FLAG): | $(NEWLIB-CONFIGURE-FLAG)
	$(MAKE) $(NEWLIB-CFLAGS) -C $(NEWLIB-BUILD-PATH)
	$(TOUCH) $(NEWLIB-BUILD-FLAG)
	
$(NEWLIB-INSTALL-FLAG): | $(NEWLIB-BUILD-FLAG)
	$(MAKE) install -C $(NEWLIB-BUILD-PATH) && \
	$(TOUCH) $(NEWLIB-INSTALL-FLAG)

newlib-fetch: $(NEWLIB-SRC-PATH)

newlib-config: $(NEWLIB-CONFIGURE-FLAG)

newlib-build: $(NEWLIB-BUILD-FLAG)

newlib-install: $(NEWLIB-INSTALL-FLAG)
