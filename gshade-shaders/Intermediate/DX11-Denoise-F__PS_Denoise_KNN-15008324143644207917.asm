//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   float NoiseLevel;                  // Offset:    0 Size:     4
//   float LerpCoefficeint;             // Offset:    4 Size:     4
//   float WeightThreshold;             // Offset:    8 Size:     4
//   float CounterThreshold;            // Offset:   12 Size:     4
//   float GaussianSigma;               // Offset:   16 Size:     4
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
// SV_TARGET                0   xyz         0   TARGET   float   xyz 
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[2], immediateIndexed
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_input_ps linear v1.xy
dcl_output o0.xyz
dcl_temps 7
sample_indexable(texture2d)(float,float,float,float) r0.xyz, v1.xyxx, t0.xyzw, s0
rcp r0.w, cb0[0].x
rcp r1.x, cb0[1].x
mov r1.yzw, l(0,0,0,0)
mov r2.xyzw, l(0,0,-3,-1)
loop 
  breakc_z r2.w
  itof r3.x, r2.z
  mov r4.xyz, r1.yzwy
  mov r3.zw, r2.xxxy
  mov r4.w, l(-3)
  mov r5.x, l(-1)
  loop 
    breakc_z r5.x
    itof r3.y, r4.w
    mad r5.yz, r3.xxyx, l(0.000000, 0.000391, 0.000694, 0.000000), v1.xxyx
    sample_l_indexable(texture2d)(float,float,float,float) r5.yzw, r5.yzyy, t0.wxyz, s0, l(0.000000)
    add r6.xyz, r0.xyzx, -r5.yzwy
    dp3 r3.y, r6.xyzx, r6.xyzx
    imul null, r6.x, r4.w, r4.w
    imad r6.x, r2.z, r2.z, r6.x
    itof r6.x, r6.x
    mul r6.x, r1.x, r6.x
    mad r3.y, r3.y, r0.w, r6.x
    mul r3.y, r3.y, l(-1.442695)
    exp r3.y, r3.y
    lt r6.x, cb0[0].z, r3.y
    and r6.x, r6.x, l(0x3f800000)
    add r3.z, r3.z, r6.x
    add r3.w, r3.y, r3.w
    mad r4.xyz, r5.yzwy, r3.yyyy, r4.xyzx
    iadd r4.w, r4.w, l(1)
    ige r5.x, l(3), r4.w
  endloop 
  mov r1.yzw, r4.xxyz
  mov r2.xy, r3.zwzz
  iadd r2.z, r2.z, l(1)
  ige r2.w, l(3), r2.z
endloop 
div r1.xyz, r1.yzwy, r2.yyyy
mul r0.w, cb0[0].w, l(49.000000)
lt r0.w, r0.w, r2.x
if_nz r0.w
  add r0.w, -cb0[0].y, l(1.000000)
  add r2.xyz, r0.xyzx, -r1.xyzx
  mad o0.xyz, r0.wwww, r2.xyzx, r1.xyzx
  ret 
else 
  add r0.xyz, r0.xyzx, -r1.xyzx
  mad o0.xyz, cb0[0].yyyy, r0.xyzx, r1.xyzx
  ret 
endif 
ret 
// Approximately 53 instruction slots used
