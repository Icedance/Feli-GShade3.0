//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   int MXAO_GLOBAL_SAMPLE_QUALITY_PRESET;// Offset:    0 Size:     4 [unused]
//   float MXAO_SAMPLE_RADIUS;          // Offset:    4 Size:     4 [unused]
//   float MXAO_SAMPLE_NORMAL_BIAS;     // Offset:    8 Size:     4 [unused]
//   float MXAO_GLOBAL_RENDER_SCALE;    // Offset:   12 Size:     4
//   float MXAO_SSAO_AMOUNT;            // Offset:   16 Size:     4
//   float MXAO_SAMPLE_RADIUS_SECONDARY;// Offset:   20 Size:     4 [unused]
//   float MXAO_AMOUNT_FINE;            // Offset:   24 Size:     4 [unused]
//   float MXAO_AMOUNT_COARSE;          // Offset:   28 Size:     4 [unused]
//   float MXAO_GAMMA;                  // Offset:   32 Size:     4 [unused]
//   int MXAO_DEBUG_VIEW_ENABLE;        // Offset:   36 Size:     4
//   int MXAO_BLEND_TYPE;               // Offset:   40 Size:     4
//   float MXAO_FADE_DEPTH_START;       // Offset:   44 Size:     4
//   float MXAO_FADE_DEPTH_END;         // Offset:   48 Size:     4
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// __s0                              sampler      NA          NA             s0      1 
// V__ReShade__BackBufferTex         texture  float4          2d             t0      1 
// V__ReShade__DepthBufferTex        texture  float4          2d             t2      1 
// V__MXAO_ColorTex                  texture  float4          2d             t4      1 
// V__MXAO_DepthTex                  texture  float4          2d             t6      1 
// V__MXAO_NormalTex                 texture  float4          2d             t8      1 
// V__MXAO_CullingTex                texture  float4          2d            t10      1 
// _Globals                          cbuffer      NA          NA            cb0      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_POSITION              0   xyzw        0      POS   float       
// TEXCOORD                 0   xy          1     NONE   float   xy  
// TEXCOORD                 1     zw        1     NONE   float     zw
// TEXCOORD                 2   x           2     NONE   float       
// TEXCOORD                 4    yzw        2     NONE   float       
// TEXCOORD                 5   xyz         3     NONE   float       
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_TARGET                0   xyzw        0   TARGET   float   xyzw
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[4], immediateIndexed
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t2
dcl_resource_texture2d (float,float,float,float) t4
dcl_resource_texture2d (float,float,float,float) t6
dcl_resource_texture2d (float,float,float,float) t8
dcl_resource_texture2d (float,float,float,float) t10
dcl_input_ps linear v1.xy
dcl_input_ps linear v1.zw
dcl_output o0.xyzw
dcl_temps 5
dcl_indexableTemp x0[5], 4
div r0.x, l(0.750000), cb0[0].w
sample_l_indexable(texture2d)(float,float,float,float) r0.y, v1.xyxx, t0.xwyz, s0, l(0.000000)
sample_l_indexable(texture2d)(float,float,float,float) r1.xyz, v1.xyxx, t8.xyzw, s0, l(0.000000)
mad r1.xyz, r1.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(-1.000000, -1.000000, -1.000000, 0.000000)
sample_l_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t6.yzxw, s0, l(0.000000)
mad r2.xy, v1.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
mov r2.z, l(1.000000)
mul r2.xyz, r0.zzzz, r2.xyzx
dp3 r0.w, r2.xyzx, r2.xyzx
rsq r0.w, r0.w
mul r2.xyz, r0.wwww, r2.xyzx
dp3 r0.w, r1.xyzx, r2.xyzx
mov_sat r0.w, -r0.w
div r0.w, l(0.150000), r0.w
mov r2.y, r0.y
mov r1.w, l(0)
mov r2.xz, l(1.000000,0,-1,0)
loop 
  breakc_z r2.z
  mov x0[0].xy, l(1.500000,0.500000,0,0)
  mov x0[1].xy, l(-1.500000,-0.500000,0,0)
  mov x0[2].xy, l(-0.500000,1.500000,0,0)
  mov x0[3].xy, l(0.500000,-1.500000,0,0)
  mov x0[4].xy, l(1.500000,2.500000,0,0)
  mov r3.xy, x0[r1.w + 0].xyxx
  mul r3.xy, r0.xxxx, r3.xyxx
  mad r3.xy, r3.xyxx, l(0.000391, 0.000726, 0.000000, 0.000000), v1.xyxx
  sample_l_indexable(texture2d)(float,float,float,float) r2.w, r3.xyxx, t0.xyzw, s0, l(0.000000)
  sample_l_indexable(texture2d)(float,float,float,float) r4.xyz, r3.xyxx, t8.xyzw, s0, l(0.000000)
  mad r4.xyz, r4.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(-1.000000, -1.000000, -1.000000, 0.000000)
  sample_l_indexable(texture2d)(float,float,float,float) r3.x, r3.xyxx, t6.xyzw, s0, l(0.000000)
  add r3.x, -r0.z, r3.x
  dp3 r3.y, r4.xyzx, r1.xyzx
  add_sat r3.y, -r3.y, l(1.000000)
  add_sat r3.x, r0.w, -|r3.x|
  add r3.y, -r3.y, l(0.650000)
  max r3.y, r3.y, l(0.000000)
  mul r3.x, r3.y, r3.x
  mul r3.x, r3.x, l(4.000000)
  min r3.x, r3.x, l(1.000000)
  add r3.y, r3.x, r3.x
  mad r2.y, r2.w, r3.y, r2.y
  mad r2.x, r3.x, l(2.000000), r2.x
  iadd r1.w, r1.w, l(1)
  ilt r2.z, r1.w, l(4)
endloop 
div r0.x, r2.y, r2.x
sample_indexable(texture2d)(float,float,float,float) r0.yzw, v1.xyxx, t4.wxyz, s0
sample_l_indexable(texture2d)(float,float,float,float) r1.x, v1.xyxx, t2.xyzw, s0, l(0.000000)
mad r1.y, -r1.x, l(999.000000), l(1000.000000)
div r1.x, r1.x, r1.y
dp3 r1.y, r0.yzwy, l(0.212600, 0.715200, 0.072200, 0.000000)
add r1.y, -r1.y, l(1.000000)
mad r0.x, -r0.x, r0.x, l(1.000000)
mul r1.z, cb0[1].x, l(4.000000)
log r0.x, |r0.x|
mul r0.x, r0.x, r1.z
exp r0.x, r0.x
add r0.x, -r0.x, l(1.000000)
add r1.z, -cb0[2].w, cb0[3].x
add r1.x, r1.x, -cb0[2].w
div r1.z, l(1.000000, 1.000000, 1.000000, 1.000000), r1.z
mul_sat r1.x, r1.z, r1.x
mad r1.z, r1.x, l(-2.000000), l(3.000000)
mul r1.x, r1.x, r1.x
mul r1.x, r1.x, r1.z
mad r0.x, r1.x, -r0.x, r0.x
ieq r1.x, cb0[2].y, l(1)
if_z cb0[2].z
  mul r1.z, r1.y, r0.x
  mad r2.xyz, -r1.zzzz, r0.yzwy, r0.yzwy
else 
  ieq r1.z, cb0[2].z, l(1)
  if_nz r1.z
    mul r1.z, r1.y, r0.x
    mad_sat r1.z, -r1.z, l(1.200000), l(1.000000)
    mul r2.xyz, r0.yzwy, r1.zzzz
  else 
    mad r1.y, -r0.x, r1.y, l(1.000000)
    mul r1.yzw, r0.yyzw, r1.yyyy
    ieq r3.xy, cb0[2].zzzz, l(2, 3, 0, 0)
    log r4.xyz, |r0.yzwy|
    mul r4.xyz, r4.xyzx, l(2.200000, 2.200000, 2.200000, 0.000000)
    exp r4.xyz, r4.xyzx
    mad r4.xyz, -r0.xxxx, r4.xyzx, r4.xyzx
    log r4.xyz, |r4.xyzx|
    mul r4.xyz, r4.xyzx, l(0.454545, 0.454545, 0.454545, 0.000000)
    exp r4.xyz, r4.xyzx
    movc r0.yzw, r3.yyyy, r4.xxyz, r0.yyzw
    movc r2.xyz, r3.xxxx, r1.yzwy, r0.yzwy
  endif 
endif 
if_nz r1.x
  add r0.x, -r0.x, l(1.000000)
  mov_sat r2.xyz, r0.xxxx
else 
  ieq r0.x, cb0[2].y, l(2)
  if_nz r0.x
    add r0.xyzw, v1.zwzw, l(0.003125, 0.005810, -0.003125, 0.005810)
    sample_indexable(texture2d)(float,float,float,float) r0.x, r0.xyxx, t10.xyzw, s0
    sample_indexable(texture2d)(float,float,float,float) r0.y, r0.zwzz, t10.yxzw, s0
    add r0.x, r0.y, r0.x
    add r1.xyzw, v1.zwzw, l(0.003125, -0.005810, -0.003125, -0.005810)
    sample_indexable(texture2d)(float,float,float,float) r0.y, r1.xyxx, t10.yxzw, s0
    add r0.x, r0.y, r0.x
    sample_indexable(texture2d)(float,float,float,float) r0.y, r1.zwzz, t10.yxzw, s0
    add r0.x, r0.y, r0.x
    lt r0.x, l(0.000001), r0.x
    and r2.xyz, r0.xxxx, l(0x3f800000, 0x3f800000, 0x3f800000, 0)
  else 
    mov_sat r2.xyz, r2.xyzx
  endif 
endif 
mov o0.xyz, r2.xyzx
mov o0.w, l(1.000000)
ret 
// Approximately 116 instruction slots used
