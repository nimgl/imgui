
struct ID3D11Device;
struct ID3D11DeviceContext;
struct ID3D11SamplerState;
struct ID3D11Buffer;
 bool ImGui_ImplDX11_Init(ID3D11Device* device, ID3D11DeviceContext* device_context);
 void ImGui_ImplDX11_Shutdown();
 void ImGui_ImplDX11_NewFrame();
 void ImGui_ImplDX11_RenderDrawData(ImDrawData* draw_data);
 bool ImGui_ImplDX11_CreateDeviceObjects();
 void ImGui_ImplDX11_InvalidateDeviceObjects();
 void ImGui_ImplDX11_UpdateTexture(ImTextureData* tex);
struct ImGui_ImplDX11_RenderState
{
    ID3D11Device* Device;
    ID3D11DeviceContext* DeviceContext;
    ID3D11Buffer* VertexConstantBuffer;
};
 ImGui_ImplDX11_RenderState* ImGui_ImplDX11_GetRenderState();