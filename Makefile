all:
	echo ""


CIMGUI_DIR = src/imgui/private/cimgui
NEW_CIMGUI_DIR = ../../imguin_git/libs/cimgui

copylibs:
	-rm -fr   $(CIMGUI_DIR)
	-mkdir -p $(CIMGUI_DIR)/generator
	-mkdir -p $(CIMGUI_DIR)/imgui
	-cp -fr   $(NEW_CIMGUI_DIR)/generator          $(CIMGUI_DIR)/
	-cp -fr   $(NEW_CIMGUI_DIR)/imgui              $(CIMGUI_DIR)/
	cp -f     $(NEW_CIMGUI_DIR)/*.*                $(CIMGUI_DIR)/
	cp -f     $(NEW_CIMGUI_DIR)/{LICENSE,Makefile} $(CIMGUI_DIR)/
	-rm -fr    $(CIMGUI_DIR)/imgui/examples
	-rm -fr    $(CIMGUI_DIR)/imgui/backends/docs
	-rm -fr    $(CIMGUI_DIR)/imgui/misc

gen:
	nimble gen
