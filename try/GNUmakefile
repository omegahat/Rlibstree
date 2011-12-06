ifneq (${OS}, Windows_NT)
  CFLAGS=-g -I../local/include
  LIBS=-L../local/libs -lstree
else
  CFLAGS=-g -Ic:/cygwin/usr/local/include
  LIBS=-Lc:/cygwin/usr/local/lib -lstree
endif


try: stringset.o
	$(CC) -o $@ $^ $(LIBS)
