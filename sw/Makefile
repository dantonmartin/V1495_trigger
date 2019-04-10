CC       := gcc
CCFLAGS1 := -Wall -g -fPIC -shared
CCFLAGS2 := -Wall -g

V1495lib.so: V1495lib.c V1495lib.h
	$(CC) -L/usr/local/lib64 $(CCFLAGS1) -o $@ $< -lCAENComm

test: test.c V1495lib.so
	$(CC) $(CCFLAGS2) -o $@ $< V1495lib.so
