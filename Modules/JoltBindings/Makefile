TARGET=libJoltC.a

all: libJoltC.a

JoltC.o: JoltC.cpp
	g++ -I. -IJoltPhysics -c JoltC.cpp -o JoltC.o

libJoltC.a: JoltC.o
	ar -rcs libJoltC.a JoltC.o
