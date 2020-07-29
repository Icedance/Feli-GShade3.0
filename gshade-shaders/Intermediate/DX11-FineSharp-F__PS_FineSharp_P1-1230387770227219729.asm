//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// __s0                              sampler      NA          NA             s0      1 
// V__ReShade__BackBufferTex         texture  float4          2d             t0      1 
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
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 2
add r0.xyzw, v1.xyxy, l(-0.000391, -0.000694, 0.000391, -0.000694)
sample_indexable(texture2d)(float,float,float,float) r0.x, r0.xyxx, t0.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r0.y, r0.zwzz, t0.yxzw, s0
add r0.x, r0.y, r0.x
add r1.xyzw, v1.xyxy, l(-0.000391, 0.000694, 0.000391, 0.000694)
sample_indexable(texture2d)(float,float,float,float) r0.y, r1.xyxx, t0.yxzw, s0
sample_indexable(texture2d)(float,float,float,float) r0.z, r1.zwzz, t0.yzxw, s0
add r0.x, r0.y, r0.x
add r0.x, r0.z, r0.x
add r1.xyzw, v1.xyxy, l(0.000000, -0.000694, -0.000391, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r0.y, r1.xyxx, t0.yxzw, s0
sample_indexable(texture2d)(float,float,float,float) r0.z, r1.zwzz, t0.yzxw, s0
add r0.y, r0.z, r0.y
add r1.xyzw, v1.xyxy, l(0.000391, 0.000000, 0.000000, 0.000694)
sample_indexable(texture2d)(float,float,float,float) r0.z, r1.xyxx, t0.yzxw, s0
sample_indexable(texture2d)(float,float,float,float) r0.w, r1.zwzz, t0.yzwx, s0
add r0.y, r0.z, r0.y
add r0.y, r0.w, r0.y
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, v1.xyxx, t0.xyzw, s0
mad r0.y, r1.x, l(2.000000), r0.y
mov o0.yzw, r1.yyzw
mad r0.x, r0.y, l(2.000000), r0.x
mul o0.x, r0.x, l(0.062500)
ret 
// Approximately 24 instruction slots used