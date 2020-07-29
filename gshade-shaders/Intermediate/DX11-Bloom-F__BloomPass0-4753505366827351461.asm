//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   int iBloomMixmode;                 // Offset:    0 Size:     4 [unused]
//   float fBloomThreshold;             // Offset:    4 Size:     4
//   float fBloomAmount;                // Offset:    8 Size:     4 [unused]
//   float fBloomSaturation;            // Offset:   12 Size:     4 [unused]
//   float3 fBloomTint;                 // Offset:   16 Size:    12 [unused]
//   bool bLensdirtEnable;              // Offset:   28 Size:     4 [unused]
//   int iLensdirtMixmode;              // Offset:   32 Size:     4 [unused]
//   float fLensdirtIntensity;          // Offset:   36 Size:     4 [unused]
//   float fLensdirtSaturation;         // Offset:   40 Size:     4 [unused]
//   float3 fLensdirtTint;              // Offset:   48 Size:    12 [unused]
//   bool bAnamFlareEnable;             // Offset:   60 Size:     4 [unused]
//   float fAnamFlareThreshold;         // Offset:   64 Size:     4
//   float fAnamFlareWideness;          // Offset:   68 Size:     4 [unused]
//   float fAnamFlareAmount;            // Offset:   72 Size:     4 [unused]
//   float fAnamFlareCurve;             // Offset:   76 Size:     4 [unused]
//   float3 fAnamFlareColor;            // Offset:   80 Size:    12 [unused]
//   bool bLenzEnable;                  // Offset:   92 Size:     4 [unused]
//   float fLenzIntensity;              // Offset:   96 Size:     4 [unused]
//   float fLenzThreshold;              // Offset:  100 Size:     4 [unused]
//   bool bChapFlareEnable;             // Offset:  104 Size:     4 [unused]
//   float fChapFlareTreshold;          // Offset:  108 Size:     4 [unused]
//   int iChapFlareCount;               // Offset:  112 Size:     4 [unused]
//   float fChapFlareDispersal;         // Offset:  116 Size:     4 [unused]
//   float fChapFlareSize;              // Offset:  120 Size:     4 [unused]
//   float3 fChapFlareCA;               // Offset:  128 Size:    12 [unused]
//   float fChapFlareIntensity;         // Offset:  140 Size:     4 [unused]
//   bool bGodrayEnable;                // Offset:  144 Size:     4 [unused]
//   float fGodrayDecay;                // Offset:  148 Size:     4 [unused]
//   float fGodrayExposure;             // Offset:  152 Size:     4 [unused]
//   float fGodrayWeight;               // Offset:  156 Size:     4 [unused]
//   float fGodrayDensity;              // Offset:  160 Size:     4 [unused]
//   float fGodrayThreshold;            // Offset:  164 Size:     4 [unused]
//   int iGodraySamples;                // Offset:  168 Size:     4 [unused]
//   float fFlareLuminance;             // Offset:  172 Size:     4 [unused]
//   float fFlareBlur;                  // Offset:  176 Size:     4 [unused]
//   float fFlareIntensity;             // Offset:  180 Size:     4 [unused]
//   float3 fFlareTint;                 // Offset:  192 Size:    12 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// __s0                              sampler      NA          NA             s0      1 
// V__ReShade__BackBufferTex         texture  float4          2d            t18      1 
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
dcl_resource_texture2d (float,float,float,float) t18
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 3
add r0.xyzw, v1.xyxy, l(0.001042, 0.001852, -0.001042, -0.001852)
sample_indexable(texture2d)(float,float,float,float) r1.xyz, r0.xyxx, t18.xyzw, s0
dp3 r0.x, r1.xyzx, l(0.333000, 0.333000, 0.333000, 0.000000)
add r1.xyz, r1.xyzx, -cb0[0].yyyy
add r1.w, r0.x, -cb0[4].x
max r1.xyzw, r1.xyzw, l(0.000000, 0.000000, 0.000000, 0.000000)
sample_indexable(texture2d)(float,float,float,float) r2.xyz, r0.zyzz, t18.xyzw, s0
sample_indexable(texture2d)(float,float,float,float) r0.xyz, r0.zwzz, t18.xyzw, s0
dp3 r0.w, r2.xyzx, l(0.333000, 0.333000, 0.333000, 0.000000)
add r2.xyz, r2.xyzx, -cb0[0].yyyy
add r2.w, r0.w, -cb0[4].x
max r2.xyzw, r2.xyzw, l(0.000000, 0.000000, 0.000000, 0.000000)
mad r1.xyzw, r1.xyzw, l(2.000000, 2.000000, 2.000000, 2.000000), r2.xyzw
dp3 r0.w, r0.xyzx, l(0.333000, 0.333000, 0.333000, 0.000000)
add r2.xyz, r0.xyzx, -cb0[0].yyyy
add r2.w, r0.w, -cb0[4].x
max r0.xyzw, r2.xyzw, l(0.000000, 0.000000, 0.000000, 0.000000)
add r0.xyzw, r0.xyzw, r1.xyzw
mul o0.xyzw, r0.xyzw, l(0.250000, 0.250000, 0.250000, 0.250000)
ret 
// Approximately 20 instruction slots used
