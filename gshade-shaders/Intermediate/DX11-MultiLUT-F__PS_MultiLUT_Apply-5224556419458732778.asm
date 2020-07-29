//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   int fLUT_LutSelector;              // Offset:    0 Size:     4
//   float fLUT_Intensity;              // Offset:    4 Size:     4
//   float fLUT_AmountChroma;           // Offset:    8 Size:     4
//   float fLUT_AmountLuma;             // Offset:   12 Size:     4
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
// V__texMultiLUT                    texture  float4          2d             t4      1 
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
dcl_constantbuffer CB0[1], immediateIndexed
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t4
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 3
sample_indexable(texture2d)(float,float,float,float) r0.xyzw, v1.xyxx, t0.xyzw, s0
mul r1.x, r0.z, l(31.000000)
frc r1.x, r1.x
mad r1.y, r0.z, l(31.000000), -r1.x
mad r1.zw, r0.xxxy, l(0.000000, 0.000000, 31.000000, 31.000000), l(0.000000, 0.000000, 0.500000, 0.500000)
mul r1.zw, r1.zzzw, l(0.000000, 0.000000, 0.000977, 0.001838)
mad r2.x, r1.y, l(0.031250), r1.z
add r2.z, r2.x, l(0.031250)
itof r1.y, cb0[0].x
mad r2.y, r1.y, l(0.058824), r1.w
sample_indexable(texture2d)(float,float,float,float) r1.yzw, r2.zyzz, t4.wxyz, s0
sample_indexable(texture2d)(float,float,float,float) r2.xyz, r2.xyxx, t4.xyzw, s0
add r1.yzw, r1.yyzw, -r2.xxyz
mad r1.xyz, r1.xxxx, r1.yzwy, r2.xyzx
add r1.xyz, -r0.xyzx, r1.xyzx
mov r1.w, l(0)
mad r1.xyzw, cb0[0].yyyy, r1.xyzw, r0.xyzw
dp4 r2.x, r1.xyzw, r1.xyzw
rsq r2.y, r2.x
dp4 r2.z, r0.xyzw, r0.xyzw
rsq r2.w, r2.z
sqrt r2.xz, r2.xxzx
mul r0.xyzw, r0.xyzw, r2.wwww
mad r1.xyzw, r1.xyzw, r2.yyyy, -r0.xyzw
mad r0.xyzw, cb0[0].zzzz, r1.xyzw, r0.xyzw
add r1.x, -r2.z, r2.x
mad r1.x, cb0[0].w, r1.x, r2.z
mul o0.xyzw, r0.xyzw, r1.xxxx
ret 
// Approximately 29 instruction slots used