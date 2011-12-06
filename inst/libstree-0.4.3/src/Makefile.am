## Process this file with automake to produce Makefile.in

INCLUDES = -I$(top_srcdir) -W -Wall

lib_LTLIBRARIES = libstree.la

pkgincludedir   = $(includedir)/stree

pkginclude_HEADERS = \
	lst_macros.h \
	lst_stree.h \
	lst_string.h \
	lst_structs.h \
	lst_algorithms.h \
	lst_timestamp.h

include_HEADERS = \
	libstree.h

libstree_la_SOURCES = \
	lst_stree.h lst_stree.c \
	lst_string.h lst_string.c \
	lst_algorithms.h lst_algorithms.c \
	lst_debug.h lst_debug.c \
	lst_structs.h lst_macros.h \
	lst_timestamp.h

libstree_la_LDFLAGS = -module
