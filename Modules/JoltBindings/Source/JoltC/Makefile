JOLTC_HEADERS=$(wildcard JoltC*.h)
JPH_DEFINES=JPH_PROFILE_ENABLED JPH_DEBUG_RENDERER JPH_OBJECT_STREAM
CPP_FLAGS=-fno-rtti

all: libJoltC.a example

JoltC.o: JoltC.cpp $(JOLTC_HEADERS)
	g++ $(CPP_FLAGS) -g -O0 -I. -I../JoltPhysics $(addprefix -D,$(JPH_DEFINES)) -c JoltC.cpp -o JoltC.o

libJoltC.a: JoltC.o
	ar -rcs libJoltC.a JoltC.o

example.o: libJoltC.a JoltC.h example.c
	g++ $(CPP_FLAGS) -g -O0 -I. $(addprefix -D,$(JPH_DEFINES)) -c example.c -o example.o

example: example.o
	g++ $(CPP_FLAGS) -g example.o libJoltC.a libJolt.a -o example

clean:
	rm -f *.o

fclean: clean
	rm -f example
	rm -f libJoltC.a

re:	fclean all

.PHONY: clean fclean re all
