import ../../imgui
import d9nim/d3d9

type
  CustomVertex = object
    pos: array[3, float32]
    col: D3DCOLOR
    uv: array[2, float32]

const D3DFVF_CUSTOMVERTEX = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1

var
  gDevice: ptr IDirect3DDevice9
  gVB: ptr IDirect3DVertexBuffer9
  gIB: ptr IDirect3DIndexBuffer9
  gVertexBufferSize = 5000
  gIndexBufferSize = 10000
  gHasRgbaSupport = false

proc toDX9Color(col: uint32): uint32 {.inline.} =
  # ImGui is ABGR, D3DFMT_A8R8G8B8 / D3DCOLOR is ARGB
  (col and 0xFF00FF00'u32) or ((col and 0x00FF0000'u32) shr 16) or ((col and 0x000000FF'u32) shl 16)

# ImDrawCallback takes const pointers in C, so a direct assignment doesn't
# compile with newer gcc. Writing it through a void** avoids that.
template setDrawCallback(field: untyped, fn: proc) =
  cast[ptr pointer](addr field)[] = cast[pointer](fn)

proc resetRenderStateCallback(parentList: ptr ImDrawList, cmd: ptr ImDrawCmd) {.cdecl.} = discard
proc samplerLinearCallback(parentList: ptr ImDrawList, cmd: ptr ImDrawCmd) {.cdecl.} =
  gDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR)
  gDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR)
proc samplerNearestCallback(parentList: ptr ImDrawList, cmd: ptr ImDrawCmd) {.cdecl.} =
  gDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT)
  gDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT)

proc igDX9SetupRenderState(drawData: ptr ImDrawData) =
  let dev = gDevice
  var vp = D3DVIEWPORT9(X: 0, Y: 0, Width: DWORD(drawData.displaySize.x),
                        Height: DWORD(drawData.displaySize.y), MinZ: 0, MaxZ: 1)
  dev.SetViewport(addr vp)
  dev.SetPixelShader(nil)
  dev.SetVertexShader(nil)
  dev.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID)
  dev.SetRenderState(D3DRS_SHADEMODE, D3DSHADE_GOURAUD)
  dev.SetRenderState(D3DRS_ZWRITEENABLE, FALSE)
  dev.SetRenderState(D3DRS_ALPHATESTENABLE, FALSE)
  dev.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE)
  dev.SetRenderState(D3DRS_ZENABLE, FALSE)
  dev.SetRenderState(D3DRS_ALPHABLENDENABLE, TRUE)
  dev.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD)
  dev.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA)
  dev.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA)
  dev.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, TRUE)
  dev.SetRenderState(D3DRS_SRCBLENDALPHA, D3DBLEND_ONE)
  dev.SetRenderState(D3DRS_DESTBLENDALPHA, D3DBLEND_INVSRCALPHA)
  dev.SetRenderState(D3DRS_SCISSORTESTENABLE, TRUE)
  dev.SetRenderState(D3DRS_FOGENABLE, FALSE)
  dev.SetRenderState(D3DRS_RANGEFOGENABLE, FALSE)
  dev.SetRenderState(D3DRS_SPECULARENABLE, FALSE)
  dev.SetRenderState(D3DRS_STENCILENABLE, FALSE)
  dev.SetRenderState(D3DRS_CLIPPING, TRUE)
  dev.SetRenderState(D3DRS_LIGHTING, FALSE)
  dev.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE)
  dev.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE)
  dev.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE)
  dev.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE)
  dev.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE)
  dev.SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE)
  dev.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE)
  dev.SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE)
  dev.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR)
  dev.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR)
  dev.SetSamplerState(0, D3DSAMP_ADDRESSU, D3DTADDRESS_CLAMP)
  dev.SetSamplerState(0, D3DSAMP_ADDRESSV, D3DTADDRESS_CLAMP)

  # orthographic projection, the 0.5 offsets map pixel centers like D3D9 expects
  let
    L = drawData.displayPos.x + 0.5'f32
    R = drawData.displayPos.x + drawData.displaySize.x + 0.5'f32
    T = drawData.displayPos.y + 0.5'f32
    B = drawData.displayPos.y + drawData.displaySize.y + 0.5'f32
  var identity, projection: D3DMATRIX
  for i in 0 .. 3: identity.m[i][i] = 1
  projection.m = [
    [2'f32 / (R - L), 0, 0, 0],
    [0'f32, 2 / (T - B), 0, 0],
    [0'f32, 0, 0.5, 0],
    [(L + R) / (L - R), (T + B) / (B - T), 0.5, 1]]
  dev.SetTransform(D3DTS_WORLD, addr identity)
  dev.SetTransform(D3DTS_VIEW, addr identity)
  dev.SetTransform(D3DTS_PROJECTION, addr projection)

proc igDX9CheckFormatSupport(format: D3DFORMAT): bool =
  var d3d: ptr IDirect3D9
  if gDevice.GetDirect3D(addr d3d) != D3D_OK:
    return false
  var param: D3DDEVICE_CREATION_PARAMETERS
  var mode: D3DDISPLAYMODE
  if gDevice.GetCreationParameters(addr param) == D3D_OK and gDevice.GetDisplayMode(0, addr mode) == D3D_OK:
    result = d3d.CheckDeviceFormat(param.AdapterOrdinal, param.DeviceType, mode.Format,
      D3DUSAGE_DYNAMIC or D3DUSAGE_QUERY_FILTER or D3DUSAGE_QUERY_POSTPIXELSHADER_BLENDING,
      D3DRTYPE_TEXTURE, format) == D3D_OK
  discard d3d.Release()

proc igDX9CopyTextureRegion(useColors: bool, src: pointer, srcPitch: int, dst: pointer, dstPitch: int, w, h: int) =
  let convert = not gHasRgbaSupport and useColors
  for y in 0 ..< h:
    let srcRow = cast[ptr UncheckedArray[uint32]](cast[uint](src) + uint(srcPitch * y))
    let dstRow = cast[ptr UncheckedArray[uint32]](cast[uint](dst) + uint(dstPitch * y))
    if convert:
      for x in 0 ..< w: dstRow[x] = toDX9Color(srcRow[x])
    else:
      copyMem(dstRow, srcRow, w * 4)

proc igDX9UpdateTexture*(tex: ptr ImTextureData) =
  if tex.status == ImTextureStatus.WantCreate:
    var dxTex: ptr IDirect3DTexture9
    let format = if gHasRgbaSupport: D3DFMT_A8B8G8R8 else: D3DFMT_A8R8G8B8
    if gDevice.CreateTexture(UINT(tex.width), UINT(tex.height), 1, D3DUSAGE_DYNAMIC, format,
                             D3DPOOL_DEFAULT, addr dxTex, nil) < 0:
      return
    var lr: D3DLOCKED_RECT
    if dxTex.LockRect(0, addr lr, nil, 0) == D3D_OK:
      igDX9CopyTextureRegion(tex.useColors, tex.getPixels(), tex.width * 4, lr.pBits, lr.Pitch, tex.width, tex.height)
      dxTex.UnlockRect(0)
    tex.setTexID(cast[ImTextureID](dxTex))
    tex.setStatus(ImTextureStatus.OK)
  elif tex.status == ImTextureStatus.WantUpdates:
    let dxTex = cast[ptr IDirect3DTexture9](tex.texID)
    var rect = RECT(left: LONG(tex.updateRect.x), top: LONG(tex.updateRect.y),
                    right: LONG(tex.updateRect.x + tex.updateRect.w), bottom: LONG(tex.updateRect.y + tex.updateRect.h))
    var lr: D3DLOCKED_RECT
    if dxTex.LockRect(0, addr lr, addr rect, 0) == D3D_OK:
      for i in 0 ..< tex.updates.size:
        let r = tex.updates.data[i]
        let dst = cast[pointer](cast[uint](lr.pBits) + uint((int(r.x) - rect.left) * 4 + (int(r.y) - rect.top) * lr.Pitch))
        igDX9CopyTextureRegion(tex.useColors, tex.getPixelsAt(r.x.int32, r.y.int32), tex.width * 4, dst, lr.Pitch, r.w.int, r.h.int)
      dxTex.UnlockRect(0)
    tex.setStatus(ImTextureStatus.OK)
  elif tex.status == ImTextureStatus.WantDestroy:
    if tex.texID != 0:
      discard cast[ptr IDirect3DTexture9](tex.texID).Release()
      tex.setTexID(0)
    tex.setStatus(ImTextureStatus.Destroyed)

proc igDX9RenderDrawData*(drawData: ptr ImDrawData) =
  if drawData.displaySize.x <= 0 or drawData.displaySize.y <= 0:
    return
  let dev = gDevice

  let platformIO = igGetPlatformIO()
  for i in 0 ..< platformIO.textures.size:
    let tex = platformIO.textures.data[i]
    if tex.status != ImTextureStatus.OK:
      igDX9UpdateTexture(tex)

  if gVB == nil or gVertexBufferSize < drawData.totalVtxCount:
    release gVB
    gVertexBufferSize = drawData.totalVtxCount + 5000
    if dev.CreateVertexBuffer(UINT(gVertexBufferSize * sizeof(CustomVertex)), D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY,
                              D3DFVF_CUSTOMVERTEX, D3DPOOL_DEFAULT, addr gVB, nil) < 0:
      return
  if gIB == nil or gIndexBufferSize < drawData.totalIdxCount:
    release gIB
    gIndexBufferSize = drawData.totalIdxCount + 10000
    let format = if sizeof(ImDrawIdx) == 2: D3DFMT_INDEX16 else: D3DFMT_INDEX32
    if dev.CreateIndexBuffer(UINT(gIndexBufferSize * sizeof(ImDrawIdx)), D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY,
                             format, D3DPOOL_DEFAULT, addr gIB, nil) < 0:
      return

  # save the state the application had
  var stateBlock: ptr IDirect3DStateBlock9
  if dev.CreateStateBlock(D3DSBT_ALL, addr stateBlock) < 0:
    return
  if stateBlock.Capture() < 0:
    release stateBlock
    return
  var lastWorld, lastView, lastProjection: D3DMATRIX
  dev.GetTransform(D3DTS_WORLD, addr lastWorld)
  dev.GetTransform(D3DTS_VIEW, addr lastView)
  dev.GetTransform(D3DTS_PROJECTION, addr lastProjection)

  var vtxPtr, idxPtr: pointer
  if gVB.Lock(0, UINT(drawData.totalVtxCount * sizeof(CustomVertex)), addr vtxPtr, D3DLOCK_DISCARD) < 0:
    release stateBlock
    return
  if gIB.Lock(0, UINT(drawData.totalIdxCount * sizeof(ImDrawIdx)), addr idxPtr, D3DLOCK_DISCARD) < 0:
    gVB.Unlock()
    release stateBlock
    return
  var
    vtxDst = cast[ptr UncheckedArray[CustomVertex]](vtxPtr)
    idxDst = cast[uint](idxPtr)
    vtxCount = 0
  for n in 0 ..< drawData.cmdLists.size:
    let cmdList = drawData.cmdLists.data[n]
    for i in 0 ..< cmdList.vtxBuffer.size:
      let v = cmdList.vtxBuffer.data[i]
      vtxDst[vtxCount] = CustomVertex(pos: [v.pos.x, v.pos.y, 0], col: cast[D3DCOLOR](toDX9Color(v.col)), uv: [v.uv.x, v.uv.y])
      inc vtxCount
    let idxBytes = cmdList.idxBuffer.size * sizeof(ImDrawIdx)
    if idxBytes > 0:
      copyMem(cast[pointer](idxDst), cmdList.idxBuffer.data, idxBytes)
    idxDst += uint(idxBytes)
  gVB.Unlock()
  gIB.Unlock()
  dev.SetStreamSource(0, gVB, 0, UINT(sizeof(CustomVertex)))
  dev.SetIndices(gIB)
  dev.SetFVF(D3DFVF_CUSTOMVERTEX)

  igDX9SetupRenderState(drawData)

  var globalVtxOffset, globalIdxOffset: int
  let clipOff = drawData.displayPos
  for n in 0 ..< drawData.cmdLists.size:
    let cmdList = drawData.cmdLists.data[n]
    for cmdI in 0 ..< cmdList.cmdBuffer.size:
      let pcmd = cmdList.cmdBuffer.data[cmdI].addr
      if pcmd.userCallback != nil:
        if pcmd.userCallback == platformIO.drawCallback_ResetRenderState:
          igDX9SetupRenderState(drawData)
        else:
          pcmd.userCallback(cmdList, pcmd)
      else:
        let
          minX = pcmd.clipRect.x - clipOff.x
          minY = pcmd.clipRect.y - clipOff.y
          maxX = pcmd.clipRect.z - clipOff.x
          maxY = pcmd.clipRect.w - clipOff.y
        if maxX <= minX or maxY <= minY:
          continue
        var r = RECT(left: LONG(minX), top: LONG(minY), right: LONG(maxX), bottom: LONG(maxY))
        dev.SetScissorRect(addr r)
        dev.SetTexture(0, cast[ptr IDirect3DTexture9](pcmd.getTexID()))
        dev.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, INT(pcmd.vtxOffset.int + globalVtxOffset), 0,
                                 UINT(cmdList.vtxBuffer.size), UINT(pcmd.idxOffset.int + globalIdxOffset),
                                 UINT(pcmd.elemCount div 3))
    globalIdxOffset += cmdList.idxBuffer.size
    globalVtxOffset += cmdList.vtxBuffer.size

  # restore the application's state
  dev.SetTransform(D3DTS_WORLD, addr lastWorld)
  dev.SetTransform(D3DTS_VIEW, addr lastView)
  dev.SetTransform(D3DTS_PROJECTION, addr lastProjection)
  stateBlock.Apply()
  release stateBlock

proc igDX9CreateDeviceObjects*(): bool {.discardable.} =
  ## Textures and buffers are created on the next igDX9RenderDrawData.
  gDevice != nil

proc igDX9InvalidateDeviceObjects*() =
  ## Call before IDirect3DDevice9.Reset.
  if gDevice == nil:
    return
  let platformIO = igGetPlatformIO()
  for i in 0 ..< platformIO.textures.size:
    let tex = platformIO.textures.data[i]
    if tex.refCount == 1:
      tex.setStatus(ImTextureStatus.WantDestroy)
      igDX9UpdateTexture(tex)
  release gVB
  release gIB

proc igDX9NewFrame*() =
  assert gDevice != nil, "call igDX9Init first"

proc igDX9Init*(device: pointer): bool {.discardable.} =
  ## `device` is an IDirect3DDevice9*. Any `ptr` type converts to it.
  let io = igGetIO()
  io.backendRendererName = "imgui_impl_dx9"
  io.backendFlags = (io.backendFlags.int32 or ImGuiBackendFlags.RendererHasVtxOffset.int32 or
                     ImGuiBackendFlags.RendererHasTextures.int32).ImGuiBackendFlags
  let platformIO = igGetPlatformIO()
  platformIO.renderer_TextureMaxWidth = 4096
  platformIO.renderer_TextureMaxHeight = 4096
  setDrawCallback(platformIO.drawCallback_ResetRenderState, resetRenderStateCallback)
  setDrawCallback(platformIO.drawCallback_SetSamplerLinear, samplerLinearCallback)
  setDrawCallback(platformIO.drawCallback_SetSamplerNearest, samplerNearestCallback)
  gDevice = cast[ptr IDirect3DDevice9](device)
  discard gDevice.AddRef()
  gHasRgbaSupport = igDX9CheckFormatSupport(D3DFMT_A8B8G8R8)
  true

proc igDX9Shutdown*() =
  igDX9InvalidateDeviceObjects()
  release gDevice
  let io = igGetIO()
  io.backendRendererName = nil
  io.backendFlags = (io.backendFlags.int32 and not (ImGuiBackendFlags.RendererHasVtxOffset.int32 or
                     ImGuiBackendFlags.RendererHasTextures.int32)).ImGuiBackendFlags
  let platformIO = igGetPlatformIO()
  platformIO.drawCallback_ResetRenderState = nil
  platformIO.drawCallback_SetSamplerLinear = nil
  platformIO.drawCallback_SetSamplerNearest = nil
