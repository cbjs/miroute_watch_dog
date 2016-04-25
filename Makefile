BUILDDIR := ./build/
BINARY = $(BUILDDIR)watch_dog

all : dir sample package

ROOTDIR = $(CURDIR)/../sdk
toolchain := $(ROOTDIR)/toolchain
CXX = $(toolchain)/bin/arm-xiaomi-linux-uclibcgnueabi-g++
CC =$(toolchain)/bin/arm-xiaomi-linux-uclibcgnueabi-gcc
LIB_DIR = -L$(ROOTDIR)/lib
CXXFLAGS += -I$(ROOTDIR)/include
LDFLAGS = -Wall -O2 -lxmrouter -lthrift -lssl -lcrypto -lconfig++ -ljson-c \
 -lboost_system -lboost_filesystem -lthriftnb -levent -lcurl -lz -lboost_thread \
 -liconv -lroutermain
TESTLDFLAGS = -lgtest

TESTS = \
				obj/test/request_test

CPPS := $(wildcard *.cc)
OBJS := $(addprefix obj/,$(CPPS:.cc=.o))
TEST_CPPS := $(wildcard testing/*.cc)
TEST_OBJS := $(addprefix obj/,$(TEST_CPPS:.cc=.o))

depend: .depend

.depend: $(CPPS)
	rm -f ./.depend
	$(CXX) $(CXXFLAGS) -MM $^ >> ./.depend
									
-include .depend

obj/%.o: %.cc
	@mkdir -p $$(dirname $@)
	$(CXX) -c -o $@ $(CXXFLAGS) $^

obj/test/%: obj/test.o obj/testing/%.o
	@mkdir -p obj/test
	$(CXX) -o $@ $^ $(LIB_DIR) $(LDFLAGS) $(TESTLDFLAGS)

test: $(TESTS)

dir : 
	mkdir -p $(BUILDDIR)

sample :
	$(CXX) $(CXXFLAGS) notifier.cc $(LIB_DIR) $(LDFLAGS) -o $(BINARY)   
	
clean:
	rm -r build obj

.PHONY : clean sample test

package: 
	cp start_script build/
	../sdk/plugin_packager_x64
