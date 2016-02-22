gcc: gcc-install

$(GCC-SRC-PATH): | $(GCC-TAR-PATH) $(SRCDIR)
	$(TAR) -xf $(GCC-TAR-PATH) -C $(SRCDIR)
	$(CD) $(GCC-SRC-PATH) && ./contrib/download_prerequisites
	$(PATCH) -p1 -l -s -d $(GCC-SRC-PATH) -i $(GCC-PATCH-PATH)

$(GCC-TAR-PATH): | $(SRCDIR)
	$(WGET) $(GCC-URL) -O $(GCC-TAR-PATH)

$(GCC-BUILD-PATH): | $(BUILDDIR)
	$(MKDIR) $(BUILDDIR)/$(GCC)

$(GCC-CONFIGURE-FLAG): | $(GCC-SRC-PATH) $(GCC-BUILD-PATH) 
	$(CD) $(GCC-SRC-PATH)/libstdc++-v3 && autoconf2.64 && \
	$(CD) $(GCC-SRC-PATH)/libgcc && autoconf2.64 && \
	$(CD) $(GCC-SRC-PATH)/gcc && autoconf2.64 && \
	$(CD) $(GCC-BUILD-PATH) && $(GCC-SRC-PATH)/configure \
		--target=$(TARGET) --prefix=$(PREFIX) \
		--enable-languages=c,c++ --disable-libssp \
		--without-headers --disable-nls --with-newlib \
		--enable-threads=ebbrt

$(GCC-BUILD-FLAG): | $(GCC-CONFIGURE-FLAG)
	$(MAKE) all-gcc  -C $(GCC-BUILD-PATH)
	$(TOUCH) $(GCC-BUILD-FLAG)

$(GCC-INSTALL-FLAG): | $(GCC-BUILD-FLAG)
	$(MAKE) install-gcc -C $(GCC-BUILD-PATH)
	$(TOUCH) $(GCC-INSTALL-FLAG)

$(GCC-ALL-BUILD-FLAG): | $(BINUTILS-INSTALL-FLAG) $(GCC-INSTALL-FLAG) $(NEWLIB-INSTALL-FLAG)
	$(MAKE) $(GCC-CFLAGS) all -C $(GCC-BUILD-PATH)
	$(TOUCH) $(GCC-ALL-BUILD-FLAG)

$(GCC-ALL-INSTALL-FLAG): | $(GCC-ALL-BUILD-FLAG)
	$(MAKE) install -C $(GCC-BUILD-PATH)
	$(TOUCH) $(GCC-ALL-INSTALL-FLAG)

gcc-fetch: $(GCC-SRC-PATH)

gcc-configure: $(GCC-CONFIGURE-FLAG)

gcc-build: $(GCC-BUILD-FLAG)

gcc-install: $(GCC-INSTALL-FLAG)

gcc-all-build: $(GCC-ALL-BUILD-FLAG)

gcc-all-install: $(GCC-ALL-INSTALL-FLAG)

