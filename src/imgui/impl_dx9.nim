# impl_dx9.nim
import nimgl/imgui
import d3d9
import winim/lean

type
  ImguiVertex* = object
    pos*: array[3, float32]
    col*: uint32
    uv*:  array[2, float32]

const
  D3DFVF_IMGUI* = (D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1)
  D3DLOCK_DISCARD* = 0x2000'u32

var
  g_Device*: ptr IDirect3DDevice9 = nil
  g_VB*: ptr IDirect3DVertexBuffer9 = nil
  g_IB*: ptr IDirect3DIndexBuffer9 = nil
  g_FontTexture*: ptr IDirect3DTexture9 = nil
  g_VBSize* = 5000
  g_IBSize* = 10000

template IMGUI_COL_TO_DX9_ARGB*(col: uint32): uint32 =
  uint32((col and 0xFF00FF00'u32) or ((col and 0x00FF0000'u32) shr 16) or ((col and 0x000000FF'u32) shl 16))

proc igDX9SetupRenderState*(drawData: ptr ImDrawData) =
  var vp: D3DVIEWPORT9
  vp.X = 0
  vp.Y = 0
  vp.Width = uint32(drawData.displaySize.x)
  vp.Height = uint32(drawData.displaySize.y)
  vp.MinZ = 0.0
  vp.MaxZ = 1.0
  g_Device.SetViewport(vp.addr)

  g_Device.SetPixelShader(nil)
  g_Device.SetVertexShader(nil)

  g_Device.SetRenderState(D3DRS_FILLMODE, DWORD(D3DFILL_SOLID.int32))
  g_Device.SetRenderState(D3DRS_SHADEMODE, DWORD(D3DSHADE_GOURAUD.int32))
  g_Device.SetRenderState(D3DRS_ZWRITEENABLE, 0)
  g_Device.SetRenderState(D3DRS_ALPHATESTENABLE, 0)
  g_Device.SetRenderState(D3DRS_CULLMODE, DWORD(D3DCULL_NONE.int32))
  g_Device.SetRenderState(D3DRS_ZENABLE, 0)
  g_Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 1)
  g_Device.SetRenderState(D3DRS_BLENDOP, DWORD(D3DBLENDOP_ADD.int32))
  g_Device.SetRenderState(D3DRS_SRCBLEND, DWORD(D3DBLEND_SRCALPHA.int32))
  g_Device.SetRenderState(D3DRS_DESTBLEND, DWORD(D3DBLEND_INVSRCALPHA.int32))
  g_Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 1)
  g_Device.SetRenderState(D3DRS_SRCBLENDALPHA, DWORD(D3DBLEND_ONE.int32))
  g_Device.SetRenderState(D3DRS_DESTBLENDALPHA, DWORD(D3DBLEND_INVSRCALPHA.int32))
  g_Device.SetRenderState(D3DRS_SCISSORTESTENABLE, 1)
  g_Device.SetRenderState(D3DRS_FOGENABLE, 0)
  g_Device.SetRenderState(D3DRS_RANGEFOGENABLE, 0)
  g_Device.SetRenderState(D3DRS_SPECULARENABLE, 0)
  g_Device.SetRenderState(D3DRS_STENCILENABLE, 0)
  g_Device.SetRenderState(D3DRS_CLIPPING, 1)
  g_Device.SetRenderState(D3DRS_LIGHTING, 0)

  g_Device.SetTextureStageState(0, D3DTSS_COLOROP, DWORD(D3DTOP_MODULATE.int32))
  g_Device.SetTextureStageState(0, D3DTSS_COLORARG1, DWORD(D3DTA_TEXTURE))
  g_Device.SetTextureStageState(0, D3DTSS_COLORARG2, DWORD(D3DTA_DIFFUSE))
  g_Device.SetTextureStageState(0, D3DTSS_ALPHAOP, DWORD(D3DTOP_MODULATE.int32))
  g_Device.SetTextureStageState(0, D3DTSS_ALPHAARG1, DWORD(D3DTA_TEXTURE))
  g_Device.SetTextureStageState(0, D3DTSS_ALPHAARG2, DWORD(D3DTA_DIFFUSE))
  g_Device.SetTextureStageState(1, D3DTSS_COLOROP, DWORD(D3DTOP_DISABLE.int32))
  g_Device.SetTextureStageState(1, D3DTSS_ALPHAOP, DWORD(D3DTOP_DISABLE.int32))

  g_Device.SetSamplerState(0, D3DSAMP_MINFILTER, DWORD(D3DTEXF_LINEAR.int32))
  g_Device.SetSamplerState(0, D3DSAMP_MAGFILTER, DWORD(D3DTEXF_LINEAR.int32))
  g_Device.SetSamplerState(0, D3DSAMP_ADDRESSU, DWORD(D3DTADDRESS_CLAMP.int32))
  g_Device.SetSamplerState(0, D3DSAMP_ADDRESSV, DWORD(D3DTADDRESS_CLAMP.int32))

  let L = drawData.displayPos.x + 0.5'f32
  let R = drawData.displayPos.x + drawData.displaySize.x + 0.5'f32
  let T = drawData.displayPos.y + 0.5'f32
  let B = drawData.displayPos.y + drawData.displaySize.y + 0.5'f32

  var matIdentity: D3DMATRIX
  matIdentity.m = [
    [1.0, 0.0, 0.0, 0.0],
    [0.0, 1.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, 0.0],
    [0.0, 0.0, 0.0, 1.0]
  ]

  var matProjection: D3DMATRIX
  matProjection.m = [
    [ 2.0'f32 / (R - L), 0.0'f32,             0.0'f32, 0.0'f32 ],
    [ 0.0'f32,           2.0'f32 / (T - B),   0.0'f32, 0.0'f32 ],
    [ 0.0'f32,           0.0'f32,             0.5'f32, 0.0'f32 ],
    [ (L + R) / (L - R), (T + B) / (B - T),   0.5'f32, 1.0'f32 ]
  ]

  g_Device.SetTransform(D3DTS_WORLD, matIdentity.addr)
  g_Device.SetTransform(D3DTS_VIEW, matIdentity.addr)
  g_Device.SetTransform(D3DTS_PROJECTION, matProjection.addr)

proc igDX9CreateFontsTexture*(): bool {.discardable.} =
  let io = igGetIO()

  var pixels: ptr char = nil
  var w: int32 = 0
  var h: int32 = 0
  var bpp: int32 = 0
  io.fonts.getTexDataAsRGBA32(pixels.addr, w.addr, h.addr, bpp.addr)

  if g_FontTexture != nil:
    g_FontTexture.Release()
    g_FontTexture = nil

  if FAILED g_Device.CreateTexture(UINT(w), UINT(h), 1, DWORD(D3DUSAGE_DYNAMIC.int32), D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT, g_FontTexture.addr, nil):
    return false

  var lr: D3DLOCKED_RECT
  if FAILED g_FontTexture.LockRect(0, lr.addr, nil, 0):
    return false

  let srcPitch = int(w) * int(bpp)
  let dstPitch = int(lr.Pitch)
  let srcBase = cast[ptr uint8](pixels)
  let dstBase = cast[ptr uint8](lr.pBits)

  for y in 0 ..< int(h):
    let srcRow = cast[pointer](cast[uint](srcBase) + uint(y * srcPitch))
    let dstRow = cast[pointer](cast[uint](dstBase) + uint(y * dstPitch))
    copyMem(dstRow, srcRow, srcPitch)

  g_FontTexture.UnlockRect(0)
  io.fonts.texID = cast[ImTextureID](g_FontTexture)
  true

proc igDX9CreateDeviceObjects*(): bool {.discardable.} =
  if g_Device == nil: return false
  if g_FontTexture == nil:
    if not igDX9CreateFontsTexture(): return false
  true

proc igDX9InvalidateDeviceObjects*() =
  if g_VB != nil: g_VB.Release(); g_VB = nil
  if g_IB != nil: g_IB.Release(); g_IB = nil
  if g_FontTexture != nil:
    g_FontTexture.Release()
    g_FontTexture = nil
    igGetIO().fonts.texID = nil

proc igDX9NewFrame*() =
  discard igDX9CreateDeviceObjects()

proc igDX9Init*(device: ptr IDirect3DDevice9): bool {.discardable.} =
  g_Device = device
  g_Device.AddRef()
  let io = igGetIO()
  io.backendRendererName = "imgui_impl_dx9_nim"
  io.backendFlags = cast[ImGuiBackendFlags](
    io.backendFlags.int32 or ImGuiBackendFlags.RendererHasVtxOffset.int32
  )
  true

proc igDX9Shutdown*() =
  igDX9InvalidateDeviceObjects()
  if g_Device != nil:
    g_Device.Release()
    g_Device = nil

proc igDX9RenderDrawData*(drawData: ptr ImDrawData) =
  if drawData == nil: return
  if drawData.displaySize.x <= 0 or drawData.displaySize.y <= 0: return
  if g_Device == nil: return

  if g_VB == nil or g_VBSize < drawData.totalVtxCount:
    if g_VB != nil: g_VB.Release(); g_VB = nil
    g_VBSize = drawData.totalVtxCount + 5000
    let usage = DWORD((D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY).int32)
    if FAILED g_Device.CreateVertexBuffer(UINT(g_VBSize * sizeof(ImguiVertex)), usage, DWORD(D3DFVF_IMGUI), D3DPOOL_DEFAULT, g_VB.addr, nil):
      return

  if g_IB == nil or g_IBSize < drawData.totalIdxCount:
    if g_IB != nil: g_IB.Release(); g_IB = nil
    g_IBSize = drawData.totalIdxCount + 10000
    let usage = DWORD((D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY).int32)
    let fmt = (if sizeof(ImDrawIdx) == 2: D3DFMT_INDEX16 else: D3DFMT_INDEX32)
    if FAILED g_Device.CreateIndexBuffer(UINT(g_IBSize * sizeof(ImDrawIdx)), usage, fmt, D3DPOOL_DEFAULT, g_IB.addr, nil):
      return

  var stateBlock: ptr IDirect3DStateBlock9 = nil
  if FAILED g_Device.CreateStateBlock(D3DSBT_ALL, stateBlock.addr): return
  if FAILED stateBlock.Capture():
    stateBlock.Release()
    return

  var lastWorld, lastView, lastProj: D3DMATRIX
  g_Device.GetTransform(D3DTS_WORLD, lastWorld.addr)
  g_Device.GetTransform(D3DTS_VIEW, lastView.addr)
  g_Device.GetTransform(D3DTS_PROJECTION, lastProj.addr)

  var vtxPtr: pointer = nil
  var idxPtr: pointer = nil

  if FAILED g_VB.Lock(0, UINT(drawData.totalVtxCount * sizeof(ImguiVertex)), vtxPtr.addr, DWORD(D3DLOCK_DISCARD)):
    stateBlock.Release()
    return

  if FAILED g_IB.Lock(0, UINT(drawData.totalIdxCount * sizeof(ImDrawIdx)), idxPtr.addr, DWORD(D3DLOCK_DISCARD)):
    g_VB.Unlock()
    stateBlock.Release()
    return

  var vtxDst = cast[ptr UncheckedArray[ImguiVertex]](vtxPtr)
  var idxDst = cast[ptr UncheckedArray[ImDrawIdx]](idxPtr)

  var vtxOffset = 0
  var idxOffset = 0

  for n in 0 ..< drawData.cmdListsCount:
    let cmdList = drawData.cmdLists[n]

    for i in 0 ..< cmdList.vtxBuffer.size:
      let src = cmdList.vtxBuffer.data[i]
      vtxDst[vtxOffset + i].pos[0] = src.pos.x
      vtxDst[vtxOffset + i].pos[1] = src.pos.y
      vtxDst[vtxOffset + i].pos[2] = 0.0'f32
      vtxDst[vtxOffset + i].col = IMGUI_COL_TO_DX9_ARGB(src.col)
      vtxDst[vtxOffset + i].uv[0] = src.uv.x
      vtxDst[vtxOffset + i].uv[1] = src.uv.y

    let bytes = cmdList.idxBuffer.size * sizeof(ImDrawIdx)
    copyMem(
      cast[pointer](addr idxDst[idxOffset]),
      cast[pointer](cmdList.idxBuffer.data),
      bytes
    )

    vtxOffset += cmdList.vtxBuffer.size
    idxOffset += cmdList.idxBuffer.size

  g_VB.Unlock()
  g_IB.Unlock()

  g_Device.SetStreamSource(0, g_VB, 0, UINT(sizeof(ImguiVertex)))
  g_Device.SetIndices(g_IB)
  g_Device.SetFVF(DWORD(D3DFVF_IMGUI))

  igDX9SetupRenderState(drawData)

  var globalVtxOffset = 0
  var globalIdxOffset = 0
  let clipOff = drawData.displayPos

  for n in 0 ..< drawData.cmdListsCount:
    let cmdList = drawData.cmdLists[n]

    for cmdI in 0 ..< cmdList.cmdBuffer.size:
      let pcmd = cmdList.cmdBuffer.data[cmdI].addr

      if pcmd.userCallback != nil:
        pcmd.userCallback(cmdList, pcmd)
      else:
        let clipMinX = pcmd.clipRect.x - clipOff.x
        let clipMinY = pcmd.clipRect.y - clipOff.y
        let clipMaxX = pcmd.clipRect.z - clipOff.x
        let clipMaxY = pcmd.clipRect.w - clipOff.y
        if clipMaxX <= clipMinX or clipMaxY <= clipMinY:
          continue

        var r: DXRECT
        r.left   = clipMinX.int32
        r.top    = clipMinY.int32
        r.right  = clipMaxX.int32
        r.bottom = clipMaxY.int32

        discard g_Device.SetScissorRect(r.addr) 

        g_Device.SetTexture(0, cast[ptr IDirect3DTexture9](pcmd.textureId))

        let baseVtx = INT(int(pcmd.vtxOffset) + globalVtxOffset)
        let startIdx = UINT(int(pcmd.idxOffset) + globalIdxOffset)
        let primCount = UINT(int(pcmd.elemCount) div 3)

        g_Device.DrawIndexedPrimitive(
          D3DPT_TRIANGLELIST,
          baseVtx,
          0,
          UINT(cmdList.vtxBuffer.size),
          startIdx,
          primCount
        )

    globalIdxOffset += cmdList.idxBuffer.size
    globalVtxOffset += cmdList.vtxBuffer.size

  g_Device.SetTransform(D3DTS_WORLD, lastWorld.addr)
  g_Device.SetTransform(D3DTS_VIEW, lastView.addr)
  g_Device.SetTransform(D3DTS_PROJECTION, lastProj.addr)

  stateBlock.Apply()
  stateBlock.Release()
