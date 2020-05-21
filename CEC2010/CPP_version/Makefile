CC=g++
LDLIBS=-lshark
LDFLAGS= -Wl,-rpath
CXXFLAGS=-Wall -pedantic -ggdb
OBJECTS=main.o RunParameter.o Benchmarks.o\
F1.o F2.o F3.o F4.o F5.o F6.o F7.o F8.o F9.o F10.o\
F11.o F12.o F13.o F14.o F15.o F16.o F17.o F18.o F19.o F20.o 
#OBJECTS = main.o RunParameter.o F2.o Benchmarks.o

main: $(OBJECTS)
	$(CC) $(CXXFLAGS) -o main $(OBJECTS) $(LDLIBS)

main.o: main.cpp Header.h RunParameter.h Benchmarks.h\
F1.h F2.h F3.h F4.h F5.h F6.h F7.h F8.h F9.h F10.h\
F11.h F12.h F13.h F14.h F15.h F16.h F17.h F18.h F19.h F20.h
	$(CC) $(CXXFLAGS) -c main.cpp 

Benchmarks.o: RunParameter.h Benchmarks.h Benchmarks.cpp
	$(CC) $(CXXFLAGS) -c Benchmarks.cpp

RunParameter.o: RunParameter.h RunParameter.cpp
	$(CC) $(CXXFLAGS) -c RunParameter.cpp

Archive.o: Archive.h Archive.cpp
	$(CC) $(CXXFLAGS) -c Archive.cpp

F1.o: F1.h Benchmarks.h F1.cpp
	$(CC) $(CXXFLAGS) -c F1.cpp

F2.o: F2.h Benchmarks.h F2.cpp
	$(CC) $(CXXFLAGS) -c F2.cpp
	
F3.o: F3.h Benchmarks.h F3.cpp
	$(CC) $(CXXFLAGS) -c F3.cpp

F4.o: F4.h Benchmarks.h F4.cpp
	$(CC) $(CXXFLAGS) -c F4.cpp

F5.o: F5.h Benchmarks.h F5.cpp
	$(CC) $(CXXFLAGS) -c F5.cpp

F6.o: F6.h Benchmarks.h F6.cpp
	$(CC) $(CXXFLAGS) -c F6.cpp

F7.o: F7.h Benchmarks.h F7.cpp
	$(CC) $(CXXFLAGS) -c F7.cpp

F8.o: F8.h Benchmarks.h F8.cpp
	$(CC) $(CXXFLAGS) -c F8.cpp

F9.o: F9.h Benchmarks.h F9.cpp
	$(CC) $(CXXFLAGS) -c F9.cpp

F10.o: F10.h Benchmarks.h F10.cpp
	$(CC) $(CXXFLAGS) -c F10.cpp

F11.o: F11.h Benchmarks.h F11.cpp
	$(CC) $(CXXFLAGS) -c F11.cpp

F12.o: F12.h Benchmarks.h F12.cpp
	$(CC) $(CXXFLAGS) -c F12.cpp

F13.o: F13.h Benchmarks.h F13.cpp
	$(CC) $(CXXFLAGS) -c F13.cpp

F14.o: F14.h Benchmarks.h F14.cpp
	$(CC) $(CXXFLAGS) -c F14.cpp

F15.o: F15.h Benchmarks.h F15.cpp
	$(CC) $(CXXFLAGS) -c F15.cpp
	
F16.o: F16.h Benchmarks.h F16.cpp
	$(CC) $(CXXFLAGS) -c F16.cpp

F17.o: F17.h Benchmarks.h F17.cpp
	$(CC) $(CXXFLAGS) -c F17.cpp
	
F18.o: F18.h Benchmarks.h F18.cpp
	$(CC) $(CXXFLAGS) -c F18.cpp
	
F19.o: F19.h Benchmarks.h F19.cpp
	$(CC) $(CXXFLAGS) -c F19.cpp

F20.o: F20.h Benchmarks.h F20.cpp
	$(CC) $(CXXFLAGS) -c F20.cpp

.PHONY : clean
clean:
	rm -f main out $(OBJECTS)
