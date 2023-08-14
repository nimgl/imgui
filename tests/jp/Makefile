# - $ make
#     Build "imgui_test.exe" --- test program
#
# - $ make test
#     Build test executables and "cimgui.dll"
#
# - $ make dll
#     Build  "cimgui.dll" that statically linked with libstdc++-6.dll and etc
#
ifeq ($(OS),Windows_NT)
	EXE = .exe
endif

NIMCACHE = .nimcache

OPT += -d:release
OPT += -d:strip
OPT += --nimcache:$(NIMCACHE)
#OPT += --verbosity:3

# All static link
OPT +=  --passL:-static
# Use cimgui.dll
#OPT += -d:cimguiDLL --passL:-static

TARGET = imgui_test

all:
	@# All static link
	nim cpp $(OPT) $(TARGET)
	@# Use cimgui.dll
	@#nim c $(OPT) $(TARGET)

.PHONY: clean test

clean:
	@-rm $(TARGET)$(EXE)
	@-rm -fr $(NIMCACHE)

TEST  = test
TNULL = tnull

test: dll Makefile
	nim cpp $(OPT) -o:$(TEST)Cpp$(EXE)  ../$(TEST)
	nim c   $(OPT) -o:$(TEST)$(EXE)     ../$(TEST)
	@#
	nim cpp $(OPT) -o:$(TNULL)Cpp$(EXE) ../$(TNULL)
	nim c   $(OPT) -o:$(TNULL)$(EXE)    ../$(TNULL)

cleantest:
	@- rm test{,Cpp}$(EXE)
	@- rm tnull{,Cpp}$(EXE)

#
CIMGUI_DIR = ../../src/imgui/private/cimgui
#VPATH = $(CIMGUI_DIR),$(CIMGUI_DIR)/imgui

SRCS +=  $(CIMGUI_DIR)/cimgui.cpp
SRCS +=  $(wildcard $(CIMGUI_DIR)/imgui/*.cpp)
OBJS += $(SRCS:.cpp=.o)

CXXFLAGS += -O2 -fno-exceptions -fno-rtti

ifeq ($(OS), Windows_NT)
	ECHO_MESSAGE = "Windows"

	OUTPUTNAME = cimgui.dll

	CXXFLAGS += -I./imgui/
	CXXFLAGS += -Wall
	CXXFLAGS += -shared
	LINKFLAGS += -limm32
	# Let include libstdc++-6.dll and etc
	CXXFLAGS += -static
	# Enable input method (IME)
	CXXFLAGS += -DIMGUI_ENABLE_WIN32_DEFAULT_IME_FUNCTIONS
  # Delele debug info
	LINKFLAGS += -s
	CFLAGS = $(CXXFLAGS)
endif

dll:$(OUTPUTNAME)
	@echo Build complete for $(ECHO_MESSAGE)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OUTPUTNAME):$(OBJS)  Makefile
	$(CXX) -o $(OUTPUTNAME) $(OBJS) $(CXXFLAGS) $(LINKFLAGS)

cleandll:
	@-rm $(OUTPUTNAME)
	@-rm $(OBJS)

cleanall: clean cleandll cleantest

.PHONY:  dll cleandll cleanall cleantest
