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
dcl_temps 8
rcp r0.x, cb0[0].x
rcp r0.y, cb0[1].x
mov r0.zw, l(0,0,0,0)
mov r1.xyzw, l(0,0,0,-3)
mov r2.x, l(-1)
loop 
  breakc_z r2.x
  itof r3.x, r1.w
  mov r2.yzw, r1.xxyz
  mov r3.zw, r0.zzzw
  mov r4.xy, l(-3,-1,0,0)
  loop 
    breakc_z r4.y
    mov r4.zw, l(0,0,0,-2)
    mov r5.x, l(-1)
    loop 
      breakc_z r5.x
      iadd r5.y, r1.w, r4.w
      itof r6.x, r5.y
      itof r7.x, r4.w
      mov r5.y, r4.z
      mov r5.zw, l(0,0,-2,-1)
      loop 
        breakc_z r5.w
        iadd r6.z, r4.x, r5.z
        itof r6.y, r6.z
        mad r6.yz, r6.xxyx, l(0.000000, 0.000391, 0.000694, 0.000000), v1.xxyx
        sample_l_indexable(texture2d)(float,float,float,float) r6.yzw, r6.yzyy, t0.wxyz, s0, l(0.000000)
        itof r7.y, r5.z
        mad r7.yz, r7.xxyx, l(0.000000, 0.000391, 0.000694, 0.000000), v1.xxyx
        sample_l_indexable(texture2d)(float,float,float,float) r7.yzw, r7.yzyy, t0.wxyz, s0, l(0.000000)
        add r6.yzw, r6.yyzw, -r7.yyzw
        dp3 r6.y, r6.yzwy, r6.yzwy
        add r5.y, r5.y, r6.y
        iadd r5.z, r5.z, l(1)
        ige r5.w, l(2), r5.z
      endloop 
      mov r4.z, r5.y
      iadd r4.w, r4.w, l(1)
      ige r5.x, l(2), r4.w
    endloop 
    itof r3.y, r4.x
    mad r5.xz, r3.xxyx, l(0.000391, 0.000000, 0.000694, 0.000000), v1.xxyx
    sample_l_indexable(texture2d)(float,float,float,float) r5.xzw, r5.xzxx, t0.xwyz, s0, l(0.000000)
    mul r3.y, r0.x, r4.z
    imul null, r4.w, r4.x, r4.x
    imad r4.w, r1.w, r1.w, r4.w
    itof r4.w, r4.w
    mul r4.w, r0.y, r4.w
    mad r3.y, r3.y, l(0.040000), r4.w
    mul r3.y, r3.y, l(-1.442695)
    exp r3.y, r3.y
    lt r4.w, cb0[0].z, r3.y
    and r4.w, r4.w, l(0x3f800000)
    add r3.z, r3.z, r4.w
    add r3.w, r3.y, r3.w
    mad r2.yzw, r5.xxzw, r3.yyyy, r2.yyzw
    iadd r4.x, r4.x, l(1)
    ige r4.y, l(3), r4.x
  endloop 
  mov r1.xyz, r2.yzwy
  mov r0.zw, r3.zzzw
  iadd r1.w, r1.w, l(1)
  ige r2.x, l(3), r1.w
endloop 
div r0.xyw, r1.xyxz, r0.wwww
mul r1.x, cb0[0].w, l(49.000000)
lt r0.z, r1.x, r0.z
if_nz r0.z
  sample_indexable(texture2d)(float,float,float,float) r1.xyz, v1.xyxx, t0.xyzw, s0
  add r0.z, -cb0[0].y, l(1.000000)
  add r1.xyz, -r0.xywx, r1.xyzx
  mad o0.xyz, r0.zzzz, r1.xyzx, r0.xywx
  ret 
else 
  sample_indexable(texture2d)(float,float,float,float) r1.xyz, v1.xyxx, t0.xyzw, s0
  add r1.xyz, -r0.xywx, r1.xyzx
  mad o0.xyz, cb0[0].yyyy, r1.xyzx, r0.xywx
  ret 
endif 
ret 
// Approximately 81 instruction slots used
