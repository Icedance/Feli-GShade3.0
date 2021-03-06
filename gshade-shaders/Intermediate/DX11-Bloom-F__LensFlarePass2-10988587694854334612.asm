//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// __s0                              sampler      NA          NA             s0      1 
// V__texLensFlare2                  texture  float4          2d            t16      1 
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
dcl_resource_texture2d (float,float,float,float) t16
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 3
add r0.xyzw, v1.xyxy, l(-0.010417, 0.000000, -0.009375, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r0.zwzz, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r0.xyzw, r0.xyxx, t16.xyzw, s0
mul r1.xyzw, r1.xyzw, l(0.016436, 0.016436, 0.016436, 0.016436)
mad r0.xyzw, r0.xyzw, l(0.011254, 0.011254, 0.011254, 0.011254), r1.xyzw
add r1.xyzw, v1.xyxy, l(-0.008333, 0.000000, -0.007292, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.023066, 0.023066, 0.023066, 0.023066), r0.xyzw
mad r0.xyzw, r1.xyzw, l(0.031105, 0.031105, 0.031105, 0.031105), r0.xyzw
add r1.xyzw, v1.xyxy, l(-0.006250, 0.000000, -0.005208, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.040306, 0.040306, 0.040306, 0.040306), r0.xyzw
mad r0.xyzw, r1.xyzw, l(0.050187, 0.050187, 0.050187, 0.050187), r0.xyzw
add r1.xyzw, v1.xyxy, l(-0.004167, 0.000000, -0.003125, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.060049, 0.060049, 0.060049, 0.060049), r0.xyzw
mad r0.xyzw, r1.xyzw, l(0.069041, 0.069041, 0.069041, 0.069041), r0.xyzw
add r1.xyzw, v1.xyxy, l(-0.002083, 0.000000, -0.001042, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.076276, 0.076276, 0.076276, 0.076276), r0.xyzw
mad r0.xyzw, r1.xyzw, l(0.080977, 0.080977, 0.080977, 0.080977), r0.xyzw
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, v1.xyxx, t16.xyzw, s0
mad r0.xyzw, r1.xyzw, l(0.082607, 0.082607, 0.082607, 0.082607), r0.xyzw
add r1.xyzw, v1.xyxy, l(0.001042, 0.000000, 0.002083, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.080977, 0.080977, 0.080977, 0.080977), r0.xyzw
mad r0.xyzw, r1.xyzw, l(0.076276, 0.076276, 0.076276, 0.076276), r0.xyzw
add r1.xyzw, v1.xyxy, l(0.003125, 0.000000, 0.004167, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.069041, 0.069041, 0.069041, 0.069041), r0.xyzw
mad r0.xyzw, r1.xyzw, l(0.060049, 0.060049, 0.060049, 0.060049), r0.xyzw
add r1.xyzw, v1.xyxy, l(0.005208, 0.000000, 0.006250, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.050187, 0.050187, 0.050187, 0.050187), r0.xyzw
mad r0.xyzw, r1.xyzw, l(0.040306, 0.040306, 0.040306, 0.040306), r0.xyzw
add r1.xyzw, v1.xyxy, l(0.007292, 0.000000, 0.008333, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.031105, 0.031105, 0.031105, 0.031105), r0.xyzw
mad r0.xyzw, r1.xyzw, l(0.023066, 0.023066, 0.023066, 0.023066), r0.xyzw
add r1.xyzw, v1.xyxy, l(0.009375, 0.000000, 0.010417, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyxx, t16.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, r1.zwzz, t16.xyzw, s0
mad r0.xyzw, r2.xyzw, l(0.016436, 0.016436, 0.016436, 0.016436), r0.xyzw
mad o0.xyzw, r1.xyzw, l(0.011254, 0.011254, 0.011254, 0.011254), r0.xyzw
ret 
// Approximately 53 instruction slots used
