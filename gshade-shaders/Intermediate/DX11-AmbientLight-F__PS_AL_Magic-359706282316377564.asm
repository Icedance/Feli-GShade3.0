//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   bool alDebug;                      // Offset:    0 Size:     4
//   float alInt;                       // Offset:    4 Size:     4
//   float alThreshold;                 // Offset:    8 Size:     4 [unused]
//   bool AL_Dither;                    // Offset:   12 Size:     4
//   bool AL_Adaptation;                // Offset:   16 Size:     4
//   float alAdapt;                     // Offset:   20 Size:     4
//   float alAdaptBaseMult;             // Offset:   24 Size:     4
//   int alAdaptBaseBlackLvL;           // Offset:   28 Size:     4
//   bool AL_Dirt;                      // Offset:   32 Size:     4
//   bool AL_DirtTex;                   // Offset:   36 Size:     4
//   bool AL_Vibrance;                  // Offset:   40 Size:     4
//   int AL_Adaptive;                   // Offset:   44 Size:     4
//   float alDirtInt;                   // Offset:   48 Size:     4
//   float alDirtOVInt;                 // Offset:   52 Size:     4
//   bool AL_Lens;                      // Offset:   56 Size:     4
//   float alLensThresh;                // Offset:   60 Size:     4
//   float alLensInt;                   // Offset:   64 Size:     4
//   float2 AL_t;                       // Offset:   68 Size:     8
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
// V__alInTex                        texture  float4          2d             t4      1 
// V__detectLowTex                   texture  float4          2d            t10      1 
// V__dirtTex                        texture  float4          2d            t12      1 
// V__dirtOVRTex                     texture  float4          2d            t14      1 
// V__dirtOVBTex                     texture  float4          2d            t16      1 
// V__lensDBTex                      texture  float4          2d            t18      1 
// V__lensDB2Tex                     texture  float4          2d            t20      1 
// V__lensDOVTex                     texture  float4          2d            t22      1 
// V__lensDUVTex                     texture  float4          2d            t24      1 
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
dcl_constantbuffer CB0[5], immediateIndexed
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t4
dcl_resource_texture2d (float,float,float,float) t10
dcl_resource_texture2d (float,float,float,float) t12
dcl_resource_texture2d (float,float,float,float) t14
dcl_resource_texture2d (float,float,float,float) t16
dcl_resource_texture2d (float,float,float,float) t18
dcl_resource_texture2d (float,float,float,float) t20
dcl_resource_texture2d (float,float,float,float) t22
dcl_resource_texture2d (float,float,float,float) t24
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 9
if_nz cb0[1].x
  sample_indexable(texture2d)(float,float,float,float) r0.xyz, l(0.500000, 0.500000, 0.000000, 0.000000), t10.xyzw, s0
  mul r0.xyz, r0.xyzx, r0.xyzx
  dp3 r0.x, r0.xyzx, l(0.013565, 0.038894, 0.003827, 0.000000)
  sqrt r0.x, r0.x
  mul r0.x, r0.x, l(1.250000)
  mul r0.y, r0.x, r0.x
  mad r0.x, r0.x, r0.x, l(1.000000)
  mul r0.x, r0.x, r0.y
  mul r0.x, r0.x, cb0[1].y
  mul r0.x, r0.x, cb0[0].y
  mul r0.x, r0.x, l(5.000000)
  if_nz cb0[0].x
    mul r0.zw, v1.xxxx, l(0.000000, 0.000000, 1000.000000, 1001.000061)
    ge r0.w, r0.w, -r0.w
    movc r1.xy, r0.wwww, l(1.001000,0.999001,0,0), l(-1.001000,-0.999001,0,0)
    mul r0.z, r0.z, r1.y
    frc r0.z, r0.z
    mul r0.z, r0.z, r1.x
    lt r0.w, v1.y, l(0.010000)
    mul r0.y, r0.y, l(10.000000)
    lt r0.y, v1.x, r0.y
    lt r0.z, r0.z, l(0.300000)
    and r0.y, r0.z, r0.y
    and r0.y, r0.y, r0.w
    if_nz r0.y
      mov o0.xyzw, l(1.000000,0.500000,0.300000,0)
      ret 
    endif 
    lt r0.y, l(0.010000), v1.y
    lt r0.w, v1.y, l(0.020000)
    and r0.y, r0.w, r0.y
    mul r0.w, cb0[0].y, l(1.500000)
    div r0.w, r0.x, r0.w
    lt r0.w, v1.x, r0.w
    and r0.z, r0.z, r0.w
    and r0.y, r0.z, r0.y
    if_nz r0.y
      mov o0.xyzw, l(0.200000,1.000000,0.500000,0)
      ret 
    endif 
  endif 
else 
  mov r0.x, l(0)
endif 
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, v1.xyxx, t0.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, v1.xyxx, t4.xyzw, s0
min r2.xyzw, r2.xyzw, l(0.032500, 0.032500, 0.032500, 0.032500)
mul r3.xyzw, r2.xyzw, l(1.150000, 1.150000, 1.150000, 1.150000)
if_nz cb0[2].x
  sample_indexable(texture2d)(float,float,float,float) r4.xyzw, v1.xyxx, t12.xyzw, s0
  sample_indexable(texture2d)(float,float,float,float) r5.xyzw, v1.xyxx, t14.xyzw, s0
  sample_indexable(texture2d)(float,float,float,float) r6.xyzw, v1.xyxx, t16.xyzw, s0
  mul r4.xyzw, r3.xyzw, r4.xyzw
  mul r4.xyzw, r4.xyzw, cb0[3].xxxx
  mul r7.xyzw, r3.xyzw, r3.xyzw
  mul r7.xyzw, r7.xyzw, cb0[3].xxxx
  movc r4.xyzw, cb0[2].yyyy, r4.xyzw, r7.xyzw
  sincos r0.y, null, cb0[4].y
  mad r0.y, r0.y, l(0.500000), l(1.000000)
  mul r7.xyzw, r0.yyyy, r4.xyzw
  movc r4.xyzw, cb0[2].zzzz, r7.xyzw, r4.xyzw
  add r0.y, r3.y, r3.x
  mad r0.y, r2.z, l(1.150000), r0.y
  div r0.yzw, r3.xxyz, r0.yyyy
  mad r2.xyzw, r2.xyzw, l(1.150000, 1.150000, 1.150000, 1.150000), r4.xyzw
  mul r7.xyzw, r3.xyzw, r5.xyzw
  mul r7.xyzw, r7.xyzw, cb0[3].yyyy
  mad r7.xyzw, r7.xyzw, r0.zzzz, r3.xyzw
  add r4.xyzw, r4.xyzw, r7.xyzw
  mul r6.xyzw, r6.xyzw, r2.xyzw
  mul r7.xyzw, r6.xyzw, cb0[3].yyyy
  mad r4.xyzw, r7.xyzw, r0.wwww, r4.xyzw
  mul r5.xyzw, r5.xyzw, r2.xyzw
  mul r7.xyzw, r5.xyzw, cb0[3].yyyy
  mad r4.xyzw, r7.xyzw, r0.yyyy, r4.xyzw
  ieq r0.yz, cb0[2].wwww, l(0, 2, 1, 0)
  mad r6.xyzw, r6.xyzw, cb0[3].yyyy, r2.xyzw
  mad r2.xyzw, r5.xyzw, cb0[3].yyyy, r2.xyzw
  movc r2.xyzw, r0.zzzz, r6.xyzw, r2.xyzw
  movc r2.xyzw, r0.yyyy, r4.xyzw, r2.xyzw
  mul r0.yzw, r2.xxyz, l(0.000000, 85.000000, 85.000000, 85.000000)
  add r4.xy, v1.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
  add r4.x, |r4.y|, |r4.x|
  add r4.x, -r4.x, l(1.250000)
  add r4.x, r4.x, r4.x
  mul r3.xyz, r0.yzwy, r4.xxxx
else 
  mov r2.xyzw, r3.xyzw
endif 
if_nz cb0[3].z
  add r4.xyzw, -v1.xyxy, l(1.000000, 1.000000, 0.500000, 0.500000)
  sample_indexable(texture2d)(float,float,float,float) r5.xyzw, r4.xyxx, t4.xyzw, s0
  min r5.xyzw, r5.xyzw, l(0.030000, 0.030000, 0.030000, 0.030000)
  mul r6.xyzw, r5.xyzw, l(1.150000, 1.150000, 1.150000, 1.150000)
  max r0.y, r3.z, r3.y
  max r0.y, r0.y, r3.x
  add r0.z, v1.x, l(-0.500000)
  add r0.z, -|r0.z|, l(0.500000)
  mul r0.y, r0.z, r0.y
  mul r0.y, r0.y, r0.y
  mul r0.y, r0.y, r0.y
  mad r0.y, cb0[3].w, l(1.800000), -r0.y
  max r0.y, r0.y, l(0.000000)
  mul r0.z, |r4.w|, l(0.300000)
  max r0.z, r0.z, |r4.z|
  mul r0.y, r0.z, r0.y
  mad r0.z, -|r4.z|, l(1.200000), l(2.200000)
  mul r0.y, r0.z, r0.y
  mul r0.z, r0.y, cb0[4].x
  mad_sat r0.y, r0.y, cb0[4].x, -r0.x
  mov_sat r0.z, r0.z
  min r0.yz, r0.yyzy, l(0.000000, 0.850000, 0.850000, 0.000000)
  movc r0.y, cb0[1].x, r0.y, r0.z
  sample_indexable(texture2d)(float,float,float,float) r3.xyzw, v1.xyxx, t18.xyzw, s0
  sample_indexable(texture2d)(float,float,float,float) r4.xyzw, v1.xyxx, t20.xyzw, s0
  sample_indexable(texture2d)(float,float,float,float) r7.xyzw, v1.xyxx, t22.xyzw, s0
  sample_indexable(texture2d)(float,float,float,float) r8.xyzw, v1.xyxx, t24.xyzw, s0
  mul r3.xyzw, r3.xyzw, r6.xyzw
  mul r3.xyzw, r0.yyyy, r3.xyzw
  mad r3.xyzw, r3.xyzw, l(0.700000, 0.700000, 0.700000, 0.700000), r2.xyzw
  mul r6.xyzw, r6.xyzw, r8.xyzw
  mul r6.xyzw, r0.yyyy, r6.xyzw
  mul r8.xyzw, r6.xyzw, l(1.150000, 1.150000, 1.150000, 1.150000)
  mad r5.xyzw, r5.xyzw, l(1.150000, 1.150000, 1.150000, 1.150000), r8.xyzw
  mad r3.xyzw, r6.xyzw, l(1.150000, 1.150000, 1.150000, 1.150000), r3.xyzw
  mul r4.xyzw, r4.xyzw, r5.xyzw
  mul r4.xyzw, r0.yyyy, r4.xyzw
  mad r5.xyzw, r4.xyzw, l(0.700000, 0.700000, 0.700000, 0.700000), r5.xyzw
  mad r3.xyzw, r4.xyzw, l(0.700000, 0.700000, 0.700000, 0.700000), r3.xyzw
  mul r4.xyzw, r7.xyzw, r5.xyzw
  mul r4.xyzw, r0.yyyy, r4.xyzw
  mul r5.xyzw, r0.yyyy, r5.xyzw
  mul r5.xyzw, r5.xyzw, l(0.500000, 0.500000, 0.500000, 0.500000)
  mad r4.xyzw, r4.xyzw, l(0.575000, 0.575000, 0.575000, 0.575000), r5.xyzw
  add r2.xyzw, r3.xyzw, r4.xyzw
endif 
eq r0.yzw, r1.xxyz, l(0.000000, 1.000000, 1.000000, 1.000000)
and r0.y, r0.z, r0.y
and r0.y, r0.w, r0.y
if_nz r0.y
  mov o0.xyzw, l(1.000000,1.000000,1.000000,1.000000)
  ret 
endif 
dp2 r0.y, v1.xyxx, l(160.000000, 382.500031, 0.000000, 0.000000)
add r0.y, r0.y, l(0.250000)
frc r0.y, r0.y
mad r0.y, r0.y, l(-0.000587), l(0.000293)
movc r0.y, cb0[0].w, r0.y, l(0)
if_nz cb0[1].x
  mul r0.z, r0.x, cb0[1].z
  mul r0.z, r0.z, l(0.750000)
  add r0.w, r1.y, r1.x
  add r0.w, r1.z, r0.w
  mad r0.w, -r0.w, l(0.333333), l(1.000000)
  itof r3.x, cb0[1].w
  log r0.w, |r0.w|
  mul r0.w, r0.w, r3.x
  exp r0.w, r0.w
  mad_sat r0.z, -r0.z, r0.w, l(1.000000)
  mul r1.xyz, r0.zzzz, r1.xyzx
  add r3.xyzw, -r1.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
  add r4.xyzw, -r2.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
  mad r3.xyzw, -r3.xyzw, r4.xyzw, r0.yyyy
  add r3.xyzw, -r1.xyzw, r3.xyzw
  add r0.z, -r0.x, cb0[0].y
  mov_sat r0.w, r0.z
  add r3.xyzw, r3.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
  mad r4.xyzw, r0.wwww, r3.xyzw, r1.xyzw
  add r0.w, r4.y, r4.x
  add r0.w, r4.z, r0.w
  lt r5.x, l(0.008000), r0.w
  if_nz r5.x
    mov o0.xyzw, r4.xyzw
    ret 
  else 
    mul_sat r0.z, r0.z, l(0.850000)
    mul r0.z, r0.w, r0.z
    mad o0.xyzw, r0.zzzz, r3.xyzw, r1.xyzw
    ret 
  endif 
else 
  add r3.xyzw, -r1.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
  add r2.xyzw, -r2.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
  mad r2.xyzw, -r3.xyzw, r2.xyzw, r0.yyyy
  add r0.xyzw, r0.xxxx, r2.xyzw
  add r0.xyzw, -r1.xyzw, r0.xyzw
  add r0.xyzw, r0.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
  mad r2.xyzw, cb0[0].yyyy, r0.xyzw, r1.xyzw
  add r3.x, r2.y, r2.x
  add r3.x, r2.z, r3.x
  lt r3.y, l(0.008000), r3.x
  if_nz r3.y
    mov o0.xyzw, r2.xyzw
    ret 
  else 
    mul_sat r2.x, cb0[0].y, l(0.850000)
    mul r2.x, r3.x, r2.x
    mad o0.xyzw, r2.xxxx, r0.xyzw, r1.xyzw
    ret 
  endif 
endif 
ret 
// Approximately 203 instruction slots used
