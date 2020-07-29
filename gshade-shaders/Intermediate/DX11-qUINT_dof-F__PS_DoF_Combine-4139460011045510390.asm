//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   bool bADOF_AutofocusEnable;        // Offset:    0 Size:     4 [unused]
//   float2 fADOF_AutofocusCenter;      // Offset:    4 Size:     8 [unused]
//   float fADOF_AutofocusRadius;       // Offset:   12 Size:     4 [unused]
//   float fADOF_AutofocusSpeed;        // Offset:   16 Size:     4 [unused]
//   float fADOF_ManualfocusDepth;      // Offset:   20 Size:     4 [unused]
//   float fADOF_NearBlurCurve;         // Offset:   24 Size:     4
//   float fADOF_FarBlurCurve;          // Offset:   28 Size:     4
//   float fADOF_HyperFocus;            // Offset:   32 Size:     4
//   float fADOF_RenderResolutionMult;  // Offset:   36 Size:     4
//   float fADOF_ShapeRadius;           // Offset:   40 Size:     4
//   float fADOF_SmootheningAmount;     // Offset:   44 Size:     4 [unused]
//   float fADOF_BokehIntensity;        // Offset:   48 Size:     4 [unused]
//   int iADOF_BokehMode;               // Offset:   52 Size:     4 [unused]
//   int iADOF_ShapeVertices;           // Offset:   56 Size:     4 [unused]
//   int iADOF_ShapeQuality;            // Offset:   60 Size:     4 [unused]
//   float fADOF_ShapeCurvatureAmount;  // Offset:   64 Size:     4 [unused]
//   float fADOF_ShapeRotation;         // Offset:   68 Size:     4 [unused]
//   float fADOF_ShapeAnamorphRatio;    // Offset:   72 Size:     4
//   float fADOF_ShapeChromaAmount;     // Offset:   76 Size:     4 [unused]
//   int iADOF_ShapeChromaMode;         // Offset:   80 Size:     4 [unused]
//   float FRAME_TIME;                  // Offset:   84 Size:     4 [unused]
//   int FRAME_COUNT;                   // Offset:   88 Size:     4 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// __s0                              sampler      NA          NA             s0      1 
// V__qUINT__BackBufferTex           texture  float4          2d             t0      1 
// V__qUINT__DepthBufferTex          texture  float4          2d             t2      1 
// V__ADOF_FocusTex                  texture  float4          2d             t4      1 
// V__CommonTex1                     texture  float4          2d            t10      1 
// _Globals                          cbuffer      NA          NA            cb0      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_POSITION              0   xyzw        0      POS   float       
// TEXCOORD                 0   xyzw        1     NONE   float   xy  
// TEXCOORD                 1   xyzw        2     NONE   float       
// TEXCOORD                 2   xy          3     NONE   float       
// TEXCOORD                 3   xy          4     NONE   float       
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
dcl_resource_texture2d (float,float,float,float) t2
dcl_resource_texture2d (float,float,float,float) t4
dcl_resource_texture2d (float,float,float,float) t10
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 3
mul r0.xy, v1.xyxx, cb0[2].yyyy
sample_indexable(texture2d)(float,float,float,float) r0.xyz, r0.xyxx, t10.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r1.xyz, v1.xyxx, t0.xyzw, s0
sample_l_indexable(texture2d)(float,float,float,float) r0.w, v1.xyxx, t2.yzwx, s0, l(0.000000)
mad r1.w, -r0.w, l(999.000000), l(1000.000000)
div_sat r2.x, r0.w, r1.w
sample_indexable(texture2d)(float,float,float,float) r2.y, v1.xyxx, t4.yxzw, s0
div_sat r2.yz, r2.xxyx, cb0[2].xxxx
lt r0.w, r2.y, r2.z
if_nz r0.w
  div r0.w, r2.y, r2.z
  add r0.w, r0.w, l(-1.000000)
  mul r1.w, cb0[1].z, cb0[1].z
  mul r1.w, r1.w, l(-0.500000)
  round_z r1.w, r1.w
  exp r1.w, r1.w
  mul r0.w, r0.w, r1.w
else 
  add r1.w, -r2.z, r2.y
  mul r2.y, cb0[1].w, cb0[1].w
  round_z r2.y, r2.y
  exp r2.y, r2.y
  mad r2.y, r2.z, r2.y, -r2.z
  div_sat r0.w, r1.w, r2.y
endif 
lt r1.w, r2.x, l(0.000034)
movc r0.w, r1.w, l(0), |r0.w|
mul r1.w, r0.w, cb0[4].z
mul r1.w, r1.w, cb0[2].z
mad r1.w, r1.w, l(1.536000), l(-0.250000)
mul_sat r1.w, r1.w, l(0.571429)
rsq r1.w, r1.w
div r1.w, l(1.000000, 1.000000, 1.000000, 1.000000), r1.w
add r0.xyz, r0.xyzx, -r1.xyzx
mad o0.xyz, r1.wwww, r0.xyzx, r1.xyzx
mul r0.x, r0.w, l(4.000000)
min r0.x, r0.x, l(1.000000)
mad o0.w, r0.x, l(0.500000), l(0.500000)
ret 
// Approximately 39 instruction slots used
