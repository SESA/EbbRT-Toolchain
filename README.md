# EbbRT-toolchain
Instructions to download and/or build the EbbRT baremetal toolchain.

### Download Binaries
By default `make` will download and install the binaries of the latest tag/release


###Build From Source (optional)


Set `BINARIES-DOWNLOAD = false` and run `make`

Build Requirments
- **autoconf2.64** This can be installed on a debian or ubuntu machine with `apt-get install autoconf2.64`
- **Automake1.12** This must the default `automake` target in your PATH 
