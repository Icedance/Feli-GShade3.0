//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   float fBloom_Intensity;            // Offset:    0 Size:     4 [unused]
//   float fBloom_Threshold;            // Offset:    4 Size:     4 [unused]
//   float fDirt_Intensity;             // Offset:    8 Size:     4 [unused]
//   float fExposure;                   // Offset:   12 Size:     4 [unused]
//   float fAdapt_Speed;                // Offset:   16 Size:     4
//   float fAdapt_Sensitivity;          // Offset:   20 Size:     4
//   float2 f2Adapt_Clip;               // Offset:   24 Size:     8
//   int iAdapt_Precision;              // Offset:   32 Size:     4
//   bool bAdapt_IgnoreOccludedByUI;    // Offset:   36 Size:     4
//   float fAdapt_IgnoreTreshold;       // Offset:   40 Size:     4
//   uint iDebug;                       // Offset:   44 Size:     4 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// __s0                              sampler      NA          NA             s0      1 
// __s1                              sampler      NA          NA             s1      1 
// V__ReShade__BackBufferTex         texture  float4          2d             t0      1 
// V__tMagicBloom_Small              texture  float4          2d            t20      1 
// V__tMagicBloom_LastAdapt          texture  float4          2d            t24      1 
// _Globals                          cbuffer      NA          NA            cb0      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_POSITION              0   xyzw        0      POS   float       
// TEXCOORD                 0   xy          1     NONE   float       
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_TARGET                0   x           0   TARGET   float   x   
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[3], immediateIndexed
dcl_sampler s0, mode_default
dcl_sampler s1, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t20
dcl_resource_texture2d (float,float,float,float) t24
dcl_output o0.x
dcl_temps 1
iadd r0.x, -cb0[2].x, l(9)
itof r0.x, r0.x
sample_l_indexable(texture2d)(float,float,float,float) r0.x, l(0.500000, 0.500000, 0.000000, 0.000000), t20.xyzw, s0, r0.x
mul r0.x, r0.x, cb0[1].y
max r0.x, r0.x, cb0[1].z
min r0.x, r0.x, cb0[1].w
sample_indexable(texture2d)(float,float,float,float) r0.y, l(0.000000, 0.000000, 0.000000, 0.000000), t24.yxzw, s1
sample_indexable(texture2d)(float,float,float,float) r0.z, l(0.500000, 0.500000, 0.000000, 0.000000), t0.xywz, s0
lt r0.z, cb0[2].z, r0.z
ine r0.w, cb0[2].y, l(0)
and r0.z, r0.z, r0.w
if_nz r0.z
  eq r0.z, r0.y, l(0.000000)
  if_nz r0.z
    mov o0.x, r0.x
    ret 
  else 
    mov o0.x, r0.y
    ret 
  endif 
endif 
add r0.x, -r0.y, r0.x
mad o0.x, cb0[1].x, r0.x, r0.y
ret 
// Approximately 24 instruction slots used