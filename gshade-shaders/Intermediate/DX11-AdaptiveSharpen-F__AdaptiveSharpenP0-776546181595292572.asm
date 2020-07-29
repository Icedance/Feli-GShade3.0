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
// SV_TARGET                0   xy          0   TARGET   float   xy  
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_input_ps linear v1.xy
dcl_output o0.xy
dcl_temps 10
add r0.xyzw, v1.xyxy, l(-0.000391, -0.000694, 0.000000, -0.000694)
sample_indexable(texture2d)(float,float,float,float) r1.xyz, r0.zwzz, t0.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r0.xyz, r0.xyxx, t0.xyzw, s0
mov_sat r0.xyz, r0.xyzx
mov_sat r1.xyz, r1.xyzx
add r2.xyzw, v1.xyxy, l(0.000391, -0.000694, -0.000391, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r3.xyz, r2.zwzz, t0.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r2.xyz, r2.xyxx, t0.xyzw, s0
mov_sat r2.xyz, r2.xyzx
mov_sat r3.xyz, r3.xyzx
add r4.xyz, r1.xyzx, r3.xyzx
add r5.xyzw, v1.xyxy, l(0.000391, 0.000000, -0.000391, 0.000694)
sample_indexable(texture2d)(float,float,float,float) r6.xyz, r5.xyxx, t0.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r5.xyz, r5.zwzz, t0.xyzw, s0
mov_sat r5.xyz, r5.xyzx
mov_sat r6.xyz, r6.xyzx
add r4.xyz, r4.xyzx, r6.xyzx
add r7.xyzw, v1.xyxy, l(0.000000, 0.000694, 0.000391, 0.000694)
sample_indexable(texture2d)(float,float,float,float) r8.xyz, r7.xyxx, t0.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r7.xyz, r7.zwzz, t0.xyzw, s0
mov_sat r7.xyz, r7.xyzx
mov_sat r8.xyz, r8.xyzx
add r4.xyz, r4.xyzx, r8.xyzx
add r9.xyz, r0.xyzx, r2.xyzx
add r9.xyz, r5.xyzx, r9.xyzx
add r9.xyz, r7.xyzx, r9.xyzx
mad r4.xyz, r4.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), r9.xyzx
sample_indexable(texture2d)(float,float,float,float) r9.xyz, v1.xyxx, t0.xyzw, s0
mov_sat r9.xyz, r9.xyzx
mad r4.xyz, r9.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), r4.xyzx
mad r1.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r1.xyzx
mad r3.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r3.xyzx
add r1.xyz, |r1.xyzx|, |r3.xyzx|
mad r3.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r6.xyzx
add r1.xyz, r1.xyzx, |r3.xyzx|
mad r3.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r8.xyzx
add r1.xyz, r1.xyzx, |r3.xyzx|
mul r1.xyz, r1.xyzx, l(1.150000, 1.150000, 1.150000, 0.000000)
mad r3.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r9.xyzx
mul r6.xyz, r9.xyzx, r9.xyzx
dp3 r0.w, l(0.255800, 0.651100, 0.093100, 0.000000), r6.xyzx
sqrt o0.y, r0.w
mad r1.xyz, |r3.xyzx|, l(1.380000, 1.380000, 1.380000, 0.000000), r1.xyzx
mad r0.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r0.xyzx
mad r2.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r2.xyzx
add r0.xyz, |r0.xyzx|, |r2.xyzx|
mad r2.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r5.xyzx
add r0.xyz, r0.xyzx, |r2.xyzx|
mad r2.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r7.xyzx
add r0.xyz, r0.xyzx, |r2.xyzx|
mad r0.xyz, r0.xyzx, l(0.920000, 0.920000, 0.920000, 0.000000), r1.xyzx
add r1.xyzw, v1.xyxy, l(0.000000, -0.001389, -0.000781, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyz, r1.xyxx, t0.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyz, r1.zwzz, t0.xyzw, s0
mov_sat r1.xyz, r1.xyzx
mad r1.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r1.xyzx
mov_sat r2.xyz, r2.xyzx
mad r2.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r2.xyzx
add r1.xyz, |r1.xyzx|, |r2.xyzx|
add r2.xyzw, v1.xyxy, l(0.000781, 0.000000, 0.000000, 0.001389)
sample_indexable(texture2d)(float,float,float,float) r3.xyz, r2.xyxx, t0.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r2.xyz, r2.zwzz, t0.xyzw, s0
mov_sat r2.xyz, r2.xyzx
mad r2.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r2.xyzx
mov_sat r3.xyz, r3.xyzx
mad r3.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000), -r3.xyzx
mul r4.xyz, r4.xyzx, l(0.062500, 0.062500, 0.062500, 0.000000)
dp3 r0.w, r4.xyzx, l(-2.466667, -2.466667, -2.466667, 0.000000)
exp r0.w, r0.w
mad r0.w, r0.w, l(0.900000), l(0.266667)
min r0.w, r0.w, l(1.000000)
add r1.xyz, r1.xyzx, |r3.xyzx|
add r1.xyz, |r2.xyzx|, r1.xyzx
mad r0.xyz, r1.xyzx, l(0.230000, 0.230000, 0.230000, 0.000000), r0.xyzx
dp3 r0.x, r0.xyzx, r0.xyzx
sqrt r0.x, r0.x
mul o0.x, r0.w, r0.x
ret 
// Approximately 78 instruction slots used
