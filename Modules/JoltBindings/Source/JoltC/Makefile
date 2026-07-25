JOLTC_HEADERS=$(wildcard JoltC*.h)

all: libJoltC.a example

JoltC.o: JoltC.cpp $(JOLTC_HEADERS)
	g++ -I. -I../JoltPhysics -c JoltC.cpp -o JoltC.o

libJoltC.a: JoltC.o
	ar -rcs libJoltC.a JoltC.o

example.o: libJoltC.a JoltC.h example.c
	gcc -I. -c example.c -o example.o

example: example.o
	gcc libJoltC.a example.o -o example
