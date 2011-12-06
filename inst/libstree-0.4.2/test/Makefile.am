## Process this file with automake to produce Makefile.in

INCLUDES = -I$(top_srcdir) -I$(top_srcdir)/src -W -Wall
LIBS = $(top_builddir)/src/.libs/libstree.a

bin_PROGRAMS = lcstext lcshex lrstext deltest buildtest addtest addremovetest

lcstext_SOURCES          = lcstext.c
lcshex_SOURCES           = lcshex.c
lrstext_SOURCES          = lrstext.c
deltest_SOURCES          = deltest.c
buildtest_SOURCES        = buildtest.c
addtest_SOURCES          = addtest.c
addremovetest_SOURCES    = addremovetest.c

# don't install any of this stuff
install-binPROGRAMS:
uninstall-binPROGRAMS:
