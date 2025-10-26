all:
	echo ""


CIMGUI_DIR = src/imgui/private/cimgui

copylibs:
	-rm -fr   $(CIMGUI_DIR)
	-mkdir -p $(CIMGUI_DIR)/generator
	-mkdir -p $(CIMGUI_DIR)/imgui
	-cp -fr ../../imguin_git/libs/cimgui/generator  $(CIMGUI_DIR)/
	-cp -fr ../../imguin_git/libs/cimgui/imgui      $(CIMGUI_DIR)/
	-cp -f  ../../imguin_git/libs/cimgui/*          $(CIMGUI_DIR)/
	rm -fr  $(CIMGUI_DIR)/imgui/examples

gen:
	nimble gen
	$(MAKE) -C tools patch
