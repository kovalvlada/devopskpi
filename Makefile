# Makefile to build the C++ program

CXX = g++
CXXFLAGS = -Wall -std=c++11
TARGET = funca_program
SRCS = main.cpp funca.cpp
OBJS = $(SRCS:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(TARGET) $(OBJS)
