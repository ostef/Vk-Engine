TARGET=libJoltC.a
JOLTC_HEADERS=$(wildcard JoltC*.h)

all: libJoltC.a

JoltC.o: JoltC.cpp $(JOLTC_HEADERS)
	g++ -I. -IJoltPhysics -c JoltC.cpp -o JoltC.o

libJoltC.a: JoltC.o
	ar -rcs libJoltC.a JoltC.o
