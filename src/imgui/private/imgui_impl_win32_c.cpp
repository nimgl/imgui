// Builds imgui_impl_win32.cpp with C linkage so impl_win32.nim can importc it.
// The backend has "extern IMGUI_IMPL_API" in it, which doesn't compile when
// IMGUI_IMPL_API is defined as extern "C", so the functions are declared
// extern "C" here first and keep that linkage in the backend.
#undef IMGUI_IMPL_API
#define IMGUI_IMPL_API
#include <windows.h>
#include "imgui.h"

extern "C" {
bool    ImGui_ImplWin32_Init(void* hwnd);
bool    ImGui_ImplWin32_InitForOpenGL(void* hwnd);
void    ImGui_ImplWin32_Shutdown();
void    ImGui_ImplWin32_NewFrame();
LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
void    ImGui_ImplWin32_EnableDpiAwareness();
float   ImGui_ImplWin32_GetDpiScaleForHwnd(void* hwnd);
float   ImGui_ImplWin32_GetDpiScaleForMonitor(void* monitor);
}

#include "imgui/backends/imgui_impl_win32.cpp"
