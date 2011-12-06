# Build this in the Omegahat tree via
#     make install INSTALL_ARGS="--configure-args='--with-libstree=/home2/duncan/local'"

build: configure clean
	R CMD build $(BUILD_ARGS) ../Rlibstree

check: configure
	R CMD check $(CHECK_ARGS) ../Rlibstree

install: configure
	R CMD INSTALL $(INSTALL_ARGS) .

configure: configure.in
	   autoconf

VERSIONS=0.4.2 0.4.3
clean:
	-for v in $(VERSIONS) ; do \
	  $(MAKE) -C inst/libstree-$$v  clean ;\
	done
	-rm -fr include lib share local

