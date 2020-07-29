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
// V__ReShade__DepthBufferTex        texture  float4          2d             t2      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_POSITION              0   xyzw        0      POS   float       
// TEXCOORD                 0   xy          1     NONE   float   xy  
// TEXCOORD                 1     zw        1     NONE   float       
// TEXCOORD                 2   x           2     NONE   float       
// TEXCOORD                 4    yzw        2     NONE   float    yzw
// TEXCOORD                 5   xyz         3     NONE   float   xyz 
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_TARGET                0   xyzw        0   TARGET   float   xyzw
// SV_TARGET                1   xyzw        1   TARGET   float   xyzw
// SV_TARGET                2   xyzw        2   TARGET   float   xyzw
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t2
dcl_input_ps linear v1.xy
dcl_input_ps linear v2.yzw
dcl_input_ps linear v3.xyz
dcl_output o0.xyzw
dcl_output o1.xyzw
dcl_output o2.xyzw
dcl_temps 4
sample_indexable(texture2d)(float,float,float,float) o0.xyzw, v1.xyxx, t0.xyzw, s0
sample_l_indexable(texture2d)(float,float,float,float) r0.x, v1.xyxx, t2.xyzw, s0, l(0.000000)
mad r0.y, -r0.x, l(999.000000), l(1000.000000)
div r0.x, r0.x, r0.y
mul o1.xyzw, r0.xxxx, l(1000.000000, 1000.000000, 1000.000000, 1000.000000)
mad r0.yzw, v1.xxxy, v3.zzxy, v2.wwyz
mul r0.xyz, r0.xxxx, r0.yzwy
mul r0.xyz, r0.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
add r1.xyzw, v1.xyxy, l(0.000521, 0.000000, -0.000521, -0.000000)
sample_l_indexable(texture2d)(float,float,float,float) r0.w, r1.zwzz, t2.yzwx, s0, l(0.000000)
mad r2.x, -r0.w, l(999.000000), l(1000.000000)
div r0.w, r0.w, r2.x
mad r2.xyz, r1.wzzw, v3.yzxy, v2.zwyz
mul r2.xyz, r0.wwww, r2.xyzx
mad r2.xyz, -r2.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000), r0.zxyz
sample_l_indexable(texture2d)(float,float,float,float) r0.w, r1.xyxx, t2.yzwx, s0, l(0.000000)
mad r1.xyz, r1.yxxy, v3.yzxy, v2.zwyz
mad r1.w, -r0.w, l(999.000000), l(1000.000000)
div r0.w, r0.w, r1.w
mul r1.xyz, r0.wwww, r1.xyzx
mad r1.xyz, r1.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000), -r0.zxyz
lt r0.w, |r2.y|, |r1.y|
add r2.xyz, -r1.xyzx, r2.xyzx
and r0.w, r0.w, l(0x3f800000)
mad r1.xyz, r0.wwww, r2.xyzx, r1.xyzx
add r2.xyzw, v1.xyxy, l(0.000000, 0.000926, -0.000000, -0.000926)
sample_l_indexable(texture2d)(float,float,float,float) r0.w, r2.zwzz, t2.yzwx, s0, l(0.000000)
mad r1.w, -r0.w, l(999.000000), l(1000.000000)
div r0.w, r0.w, r1.w
mad r3.xyz, r2.zzwz, v3.zxyz, v2.wyzw
mul r3.xyz, r0.wwww, r3.xyzx
mad r3.xyz, -r3.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000), r0.xyzx
sample_l_indexable(texture2d)(float,float,float,float) r0.w, r2.xyxx, t2.yzwx, s0, l(0.000000)
mad r2.xyz, r2.xxyx, v3.zxyz, v2.wyzw
mad r1.w, -r0.w, l(999.000000), l(1000.000000)
div r0.w, r0.w, r1.w
mul r2.xyz, r0.wwww, r2.xyzx
mad r0.xyz, r2.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000), -r0.xyzx
lt r0.w, |r3.x|, |r0.x|
add r2.xyz, -r0.xyzx, r3.xyzx
and r0.w, r0.w, l(0x3f800000)
mad r0.xyz, r0.wwww, r2.xyzx, r0.xyzx
mul r2.xyz, r1.xyzx, r0.xyzx
mad r0.xyz, r0.zxyz, r1.yzxy, -r2.xyzx
dp3 r0.w, r0.xyzx, r0.xyzx
rsq r0.w, r0.w
mul r0.xyz, r0.wwww, r0.xyzx
mad o2.xyz, r0.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
mov o2.w, l(0)
ret 
// Approximately 50 instruction slots used
