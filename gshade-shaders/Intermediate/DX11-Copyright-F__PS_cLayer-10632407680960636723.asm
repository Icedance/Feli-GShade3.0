//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   int cLayer_BlendMode;              // Offset:    0 Size:     4
//   float cLayer_Blend;                // Offset:    4 Size:     4
//   float cLayer_Scale;                // Offset:    8 Size:     4
//   float cLayer_ScaleX;               // Offset:   12 Size:     4
//   float cLayer_ScaleY;               // Offset:   16 Size:     4
//   float cLayer_PosX;                 // Offset:   20 Size:     4
//   float cLayer_PosY;                 // Offset:   24 Size:     4
//   int cLayer_SnapRotate;             // Offset:   28 Size:     4
//   float cLayer_Rotate;               // Offset:   32 Size:     4
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
// V__Copyright_Texture              texture  float4          2d             t4      1 
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
dcl_constantbuffer CB0[3], immediateIndexed
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t4
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 8
mul r0.x, cb0[0].w, cb0[0].z
mul r0.y, cb0[0].z, cb0[1].x
mul r0.xy, r0.xyxx, l(-0.252170, 0.103299, 0.000000, 0.000000)
switch cb0[1].w
  case l(1)
  mov r0.z, l(-1.570796)
  break 
  case l(2)
  mov r0.z, l(1.570796)
  break 
  case l(3)
  mov r0.z, l(0)
  break 
  case l(4)
  mov r0.z, l(3.141593)
  break 
  default 
  mul r0.z, cb0[2].x, l(0.017453)
  break 
endswitch 
div r0.x, l(1.000000, 1.000000, 1.000000, 1.000000), r0.x
div r0.y, l(1.000000, 1.000000, 1.000000, 1.000000), r0.y
sincos r1.x, r2.x, r0.z
mul r1.x, r1.x, l(-0.777778)
sincos r0.z, null, -r0.z
mul r1.w, r0.z, l(0.437500)
mul r1.yz, r2.xxxx, l(0.000000, -0.777778, 0.437500, 0.000000)
mov r2.xz, v1.xxyx
mov r2.yw, -cb0[1].yyyz
dp2 r2.x, r2.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
dp2 r2.y, r2.zwzz, l(1.000000, 1.000000, 0.000000, 0.000000)
dp2 r0.z, r2.xyxx, r1.ywyy
dp2 r0.w, r2.xyxx, r1.xzxx
mul r1.xy, r0.xyxx, r0.zwzz
sample_indexable(texture2d)(float,float,float,float) r0.xyzw, v1.xyxx, t0.xyzw, s0
add r1.xy, r1.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t4.xyzw, s0
mov_sat r1.zw, r1.xxxy
eq r1.xy, r1.zwzz, r1.xyxx
and r1.x, r1.y, r1.x
and r1.x, r1.x, l(0x3f800000)
mul r3.xyzw, r1.xxxx, r2.xyzw
switch cb0[0].x
  case l(1)
  min r4.xyz, r0.xyzx, r3.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(2)
  mul r2.w, r3.w, cb0[0].y
  mad r4.xyz, r0.xyzx, r3.xyzx, -r0.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(3)
  lt r4.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r3.xyzx
  and r2.w, r4.y, r4.x
  and r2.w, r4.z, r2.w
  add r4.xyz, -r0.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  div r4.xyz, r4.xyzx, r3.xyzx
  min r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r4.xyz, -r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  and r4.xyz, r2.wwww, r4.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(4)
  mad r4.xyz, r2.xyzx, r1.xxxx, r0.xyzx
  add r4.xyz, r4.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  max r4.xyz, r4.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(5)
  max r4.xyz, r0.xyzx, r3.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(6)
  add r4.xyz, -r0.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r5.xyz, -r2.xyzx, r1.xxxx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r4.xyz, -r4.xyzx, r5.xyzx, -r0.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(7)
  lt r4.xyz, r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  and r2.w, r4.y, r4.x
  and r2.w, r4.z, r2.w
  mad r4.xyz, -r2.xyzx, r1.xxxx, l(1.000000, 1.000000, 1.000000, 0.000000)
  div r4.xyz, r0.xyzx, r4.xyzx
  min r4.xyz, r4.xyzx, l(1.500000, 1.500000, 1.500000, 0.000000)
  movc r4.xyz, r2.wwww, r4.xyzx, l(1.000000,1.000000,1.000000,0)
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(8)
  mad r4.xyz, r2.xyzx, r1.xxxx, r0.xyzx
  min r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(9)
  mad r4.xyz, r2.xyzx, r1.xxxx, r0.xyzx
  min r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(10)
  ge r4.xyz, r0.xyzx, l(0.999999, 0.999999, 0.999999, 0.000000)
  or r2.w, r4.y, r4.x
  or r2.w, r4.z, r2.w
  mul r4.xyz, r3.xyzx, r3.xyzx
  add r5.xyz, -r0.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  div_sat r4.xyz, r4.xyzx, r5.xyzx
  movc r4.xyz, r2.wwww, r0.xyzx, r4.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(11)
  mul r4.xyz, r0.xyzx, r3.xyzx
  add r5.xyz, r4.xyzx, r4.xyzx
  add r6.xyz, -r0.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r6.xyz, r6.xyzx, r6.xyzx
  mad r7.xyz, -r2.xyzx, r1.xxxx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r6.xyz, -r6.xyzx, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  ge r7.xyz, r3.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  and r7.xyz, r7.xyzx, l(0x3f800000, 0x3f800000, 0x3f800000, 0)
  mad r4.xyz, -r4.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), r6.xyzx
  mad r4.xyz, r7.xyzx, r4.xyzx, r5.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(12)
  ge r4.xyz, l(0.500000, 0.500000, 0.500000, 0.000000), r3.xyzx
  and r2.w, r4.y, r4.x
  and r2.w, r4.z, r2.w
  mad r4.xyz, -r3.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
  mul r4.xyz, r0.xyzx, r4.xyzx
  add r5.xyz, -r0.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad_sat r4.xyz, -r4.xyzx, r5.xyzx, r0.xyzx
  mad r5.xyz, r3.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(-1.000000, -1.000000, -1.000000, 0.000000)
  ge r6.xyz, l(0.250000, 0.250000, 0.250000, 0.000000), r0.xyzx
  and r4.w, r6.y, r6.x
  and r4.w, r6.z, r4.w
  mad r6.xyz, r0.xyzx, l(16.000000, 16.000000, 16.000000, 0.000000), l(-12.000000, -12.000000, -12.000000, 0.000000)
  mad r6.xyz, r6.xyzx, r0.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000)
  mul r6.xyz, r0.xyzx, r6.xyzx
  sqrt r7.xyz, r0.xyzx
  movc r6.xyz, r4.wwww, r6.xyzx, r7.xyzx
  add r6.xyz, -r0.xyzx, r6.xyzx
  mad_sat r5.xyz, r5.xyzx, r6.xyzx, r0.xyzx
  movc r4.xyz, r2.wwww, r4.xyzx, r5.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(13)
  mul r4.xyz, r0.xyzx, r3.xyzx
  add r5.xyz, r4.xyzx, r4.xyzx
  mad r6.xyz, -r2.xyzx, r1.xxxx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r6.xyz, r6.xyzx, r6.xyzx
  add r7.xyz, -r0.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r6.xyz, -r6.xyzx, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  ge r7.xyz, r0.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  and r7.xyz, r7.xyzx, l(0x3f800000, 0x3f800000, 0x3f800000, 0)
  mad r4.xyz, -r4.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), r6.xyzx
  mad r4.xyz, r7.xyzx, r4.xyzx, r5.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(14)
  mul r4.xyz, r0.xyzx, r3.xyzx
  add r5.xyz, r4.xyzx, r4.xyzx
  add r6.xyz, -r0.xyzx, l(1.010000, 1.010000, 1.010000, 0.000000)
  add r6.xyz, r6.xyzx, r6.xyzx
  div r6.xyz, r3.xyzx, r6.xyzx
  ge r7.xyz, r0.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  and r7.xyz, r7.xyzx, l(0x3f800000, 0x3f800000, 0x3f800000, 0)
  mad r4.xyz, -r4.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), r6.xyzx
  mad r4.xyz, r7.xyzx, r4.xyzx, r5.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(15)
  lt r4.xyz, r3.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  or r2.w, r4.y, r4.x
  or r2.w, r4.z, r2.w
  mad r4.xyz, r3.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), r0.xyzx
  add r4.xyz, r4.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  max r4.xyz, r4.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  mad r5.xyz, r2.xyzx, r1.xxxx, l(-0.500000, -0.500000, -0.500000, 0.000000)
  mad r5.xyz, r5.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), r0.xyzx
  min r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  movc r4.xyz, r2.wwww, r4.xyzx, r5.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(16)
  lt r4.xyz, r3.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  or r2.w, r4.y, r4.x
  or r2.w, r4.z, r2.w
  add r4.xyz, r3.xyzx, r3.xyzx
  min r4.xyz, r0.xyzx, r4.xyzx
  mad r5.xyz, r2.xyzx, r1.xxxx, l(-0.500000, -0.500000, -0.500000, 0.000000)
  add r5.xyz, r5.xyzx, r5.xyzx
  max r5.xyz, r0.xyzx, r5.xyzx
  movc r4.xyz, r2.wwww, r4.xyzx, r5.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(17)
  mul r4.xyz, r0.xyzx, r3.xyzx
  add r5.xyz, r4.xyzx, r4.xyzx
  add r6.xyz, -r0.xyzx, l(1.010000, 1.010000, 1.010000, 0.000000)
  add r6.xyz, r6.xyzx, r6.xyzx
  div r6.xyz, r3.xyzx, r6.xyzx
  ge r7.xyz, r0.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  and r7.xyz, r7.xyzx, l(0x3f800000, 0x3f800000, 0x3f800000, 0)
  mad r4.xyz, -r4.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), r6.xyzx
  mad r4.xyz, r7.xyzx, r4.xyzx, r5.xyzx
  lt r4.xyz, r4.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  or r2.w, r4.y, r4.x
  or r2.w, r4.z, r2.w
  movc r2.w, r2.w, l(0), l(1.000000)
  mul r4.x, r3.w, cb0[0].y
  add r4.yzw, -r0.xxyz, r2.wwww
  mad r1.yzw, r4.xxxx, r4.yyzw, r0.xxyz
  break 
  case l(18)
  mad r4.xyz, -r2.xyzx, r1.xxxx, r0.xyzx
  mad r5.xyz, r2.xyzx, r1.xxxx, -r0.xyzx
  max r4.xyz, r4.xyzx, r5.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(19)
  mad r4.xyz, r2.xyzx, r1.xxxx, r0.xyzx
  mul r5.xyz, r0.xyzx, r3.xyzx
  mad r4.xyz, -r5.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), r4.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(20)
  mad r4.xyz, -r2.xyzx, r1.xxxx, r0.xyzx
  max r4.xyz, r4.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(21)
  mad r4.xyz, r2.xyzx, r1.xxxx, l(0.010000, 0.010000, 0.010000, 0.000000)
  div r4.xyz, r0.xyzx, r4.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(22)
  ge r4.xyz, r3.xyzx, l(0.999999, 0.999999, 0.999999, 0.000000)
  or r2.w, r4.y, r4.x
  or r2.w, r4.z, r2.w
  mul r4.xyz, r0.xyzx, r0.xyzx
  mad r5.xyz, -r2.xyzx, r1.xxxx, l(1.000000, 1.000000, 1.000000, 0.000000)
  div_sat r4.xyz, r4.xyzx, r5.xyzx
  movc r4.xyz, r2.wwww, r3.xyzx, r4.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(23)
  mad r4.xyz, r2.xyzx, r1.xxxx, r0.xyzx
  add_sat r4.xyz, r4.xyzx, l(-0.500000, -0.500000, -0.500000, 0.000000)
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(24)
  mad r4.xyz, -r2.xyzx, r1.xxxx, r0.xyzx
  add_sat r4.xyz, r4.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(25)
  max r2.w, r0.z, r0.y
  max r2.w, r0.x, r2.w
  min r4.x, r0.z, r0.y
  min r4.x, r0.x, r4.x
  add r4.y, r2.w, -r4.x
  max r2.w, r3.z, r3.y
  max r2.w, r2.w, r3.x
  eq r5.x, r2.w, r3.x
  min r5.y, r3.z, r3.y
  min r5.y, r3.x, r5.y
  eq r5.z, r3.z, r5.y
  and r5.w, r5.z, r5.x
  if_nz r5.w
    lt r5.w, r3.z, r3.x
    mad r6.xy, r2.yxyy, r1.xxxx, -r3.zzzz
    mul r6.x, r4.y, r6.x
    div r4.z, r6.x, r6.y
    and r6.xy, r4.yzyy, r5.wwww
    mov r6.z, l(0)
  else 
    eq r5.w, r3.y, r5.y
    and r5.x, r5.w, r5.x
    if_nz r5.x
      lt r5.x, r3.y, r3.x
      mad r7.xy, r2.zxzz, r1.xxxx, -r3.yyyy
      mul r6.w, r4.y, r7.x
      div r4.w, r6.w, r7.y
      and r6.xz, r4.yywy, r5.xxxx
      mov r6.y, l(0)
    else 
      eq r4.w, r2.w, r3.y
      and r5.x, r5.z, r4.w
      if_nz r5.x
        lt r5.x, r3.z, r3.y
        mad r7.xy, r2.xyxx, r1.xxxx, -r3.zzzz
        mul r5.z, r4.y, r7.x
        div r4.x, r5.z, r7.y
        and r6.xy, r4.xyxx, r5.xxxx
        mov r6.z, l(0)
      else 
        eq r5.x, r3.x, r5.y
        and r4.w, r4.w, r5.x
        if_nz r4.w
          lt r4.w, r3.x, r3.y
          mad r5.yz, r2.zzyz, r1.xxxx, -r3.xxxx
          mul r5.y, r4.y, r5.y
          div r4.z, r5.y, r5.z
          and r6.yz, r4.yyzy, r4.wwww
          mov r6.x, l(0)
        else 
          eq r2.w, r2.w, r3.z
          and r4.w, r5.w, r2.w
          lt r5.yz, r3.yyxy, r3.zzzz
          mad r7.xyzw, r2.xzyz, r1.xxxx, -r3.yyxx
          mul r7.xz, r4.yyyy, r7.xxzx
          div r4.xz, r7.xxzx, r7.yywy
          and r7.xz, r4.xxyx, r5.yyyy
          and r2.w, r5.x, r2.w
          and r4.yz, r4.zzyz, r5.zzzz
          mov r4.x, l(0)
          movc r4.xyz, r2.wwww, r4.xyzx, r3.xyzx
          mov r7.y, l(0)
          movc r6.xyz, r4.wwww, r7.xyzx, r4.xyzx
        endif 
      endif 
    endif 
  endif 
  dp3 r2.w, r0.xyzx, l(0.300000, 0.590000, 0.110000, 0.000000)
  dp3 r4.x, r6.xyzx, l(0.300000, 0.590000, 0.110000, 0.000000)
  add r2.w, r2.w, -r4.x
  add r4.xyz, r2.wwww, r6.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(26)
  max r2.w, r3.z, r3.y
  max r2.w, r2.w, r3.x
  min r4.x, r3.z, r3.y
  min r4.x, r3.x, r4.x
  add r4.y, r2.w, -r4.x
  max r2.w, r0.z, r0.y
  max r2.w, r0.x, r2.w
  eq r5.x, r0.x, r2.w
  min r5.y, r0.z, r0.y
  min r5.y, r0.x, r5.y
  eq r5.z, r0.z, r5.y
  and r5.w, r5.z, r5.x
  if_nz r5.w
    lt r5.w, r0.z, r0.x
    add r6.xy, -r0.zzzz, r0.yxyy
    mul r6.x, r4.y, r6.x
    div r4.z, r6.x, r6.y
    and r6.xy, r4.yzyy, r5.wwww
    mov r6.z, l(0)
  else 
    eq r5.w, r0.y, r5.y
    and r5.x, r5.w, r5.x
    if_nz r5.x
      lt r5.x, r0.y, r0.x
      add r7.xy, -r0.yyyy, r0.zxzz
      mul r6.w, r4.y, r7.x
      div r4.w, r6.w, r7.y
      and r6.xz, r4.yywy, r5.xxxx
      mov r6.y, l(0)
    else 
      eq r4.w, r0.y, r2.w
      and r5.x, r5.z, r4.w
      if_nz r5.x
        lt r5.x, r0.z, r0.y
        add r7.xy, -r0.zzzz, r0.xyxx
        mul r5.z, r4.y, r7.x
        div r4.x, r5.z, r7.y
        and r6.xy, r4.xyxx, r5.xxxx
        mov r6.z, l(0)
      else 
        eq r5.x, r0.x, r5.y
        and r4.w, r4.w, r5.x
        if_nz r4.w
          lt r4.w, r0.x, r0.y
          add r5.yz, -r0.xxxx, r0.zzyz
          mul r5.y, r4.y, r5.y
          div r4.z, r5.y, r5.z
          and r6.yz, r4.yyzy, r4.wwww
          mov r6.x, l(0)
        else 
          eq r2.w, r0.z, r2.w
          and r4.w, r5.w, r2.w
          lt r5.yz, r0.yyxy, r0.zzzz
          add r7.xyzw, -r0.yyxx, r0.xzyz
          mul r7.xz, r4.yyyy, r7.xxzx
          div r4.xz, r7.xxzx, r7.yywy
          and r7.xz, r4.xxyx, r5.yyyy
          and r2.w, r5.x, r2.w
          and r4.yz, r4.zzyz, r5.zzzz
          mov r4.x, l(0)
          movc r4.xyz, r2.wwww, r4.xyzx, r0.xyzx
          mov r7.y, l(0)
          movc r6.xyz, r4.wwww, r7.xyzx, r4.xyzx
        endif 
      endif 
    endif 
  endif 
  dp3 r2.w, r0.xyzx, l(0.300000, 0.590000, 0.110000, 0.000000)
  dp3 r4.x, r6.xyzx, l(0.300000, 0.590000, 0.110000, 0.000000)
  add r2.w, r2.w, -r4.x
  add r4.xyz, r2.wwww, r6.xyzx
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(27)
  dp3 r2.w, r0.xyzx, l(0.300000, 0.590000, 0.110000, 0.000000)
  dp3 r4.x, r3.xyzx, l(0.300000, 0.590000, 0.110000, 0.000000)
  add r2.w, r2.w, -r4.x
  mad r4.xyz, r2.xyzx, r1.xxxx, r2.wwww
  mul r2.w, r3.w, cb0[0].y
  add r4.xyz, -r0.xyzx, r4.xyzx
  mad r1.yzw, r2.wwww, r4.xxyz, r0.xxyz
  break 
  case l(28)
  dp3 r2.w, r3.xyzx, l(0.300000, 0.590000, 0.110000, 0.000000)
  dp3 r3.x, r0.xyzx, l(0.300000, 0.590000, 0.110000, 0.000000)
  add r3.xyz, r2.wwww, -r3.xxxx
  mul r2.w, r3.w, cb0[0].y
  mad r1.yzw, r2.wwww, r3.xxyz, r0.xxyz
  break 
  default 
  mul r2.w, r3.w, cb0[0].y
  mad r2.xyz, r2.xyzx, r1.xxxx, -r0.xyzx
  mad r1.yzw, r2.wwww, r2.xxyz, r0.xxyz
  break 
endswitch 
mov o0.xyz, r1.yzwy
mov o0.w, r0.w
ret 
// Approximately 475 instruction slots used
