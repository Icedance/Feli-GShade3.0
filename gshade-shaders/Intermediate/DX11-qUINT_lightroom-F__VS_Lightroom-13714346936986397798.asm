//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer _Globals
// {
//
//   bool LIGHTROOM_ENABLE_LUT;         // Offset:    0 Size:     4 [unused]
//   int LIGHTROOM_LUT_TILE_SIZE;       // Offset:    4 Size:     4 [unused]
//   int LIGHTROOM_LUT_TILE_COUNT;      // Offset:    8 Size:     4 [unused]
//   int LIGHTROOM_LUT_SCROLL;          // Offset:   12 Size:     4 [unused]
//   bool LIGHTROOM_ENABLE_CURVE_DISPLAY;// Offset:   16 Size:     4 [unused]
//   bool LIGHTROOM_ENABLE_CLIPPING_DISPLAY;// Offset:   20 Size:     4 [unused]
//   float LIGHTROOM_RED_HUESHIFT;      // Offset:   24 Size:     4
//   float LIGHTROOM_ORANGE_HUESHIFT;   // Offset:   28 Size:     4
//   float LIGHTROOM_YELLOW_HUESHIFT;   // Offset:   32 Size:     4
//   float LIGHTROOM_GREEN_HUESHIFT;    // Offset:   36 Size:     4
//   float LIGHTROOM_AQUA_HUESHIFT;     // Offset:   40 Size:     4
//   float LIGHTROOM_BLUE_HUESHIFT;     // Offset:   44 Size:     4
//   float LIGHTROOM_MAGENTA_HUESHIFT;  // Offset:   48 Size:     4
//   float LIGHTROOM_RED_EXPOSURE;      // Offset:   52 Size:     4 [unused]
//   float LIGHTROOM_ORANGE_EXPOSURE;   // Offset:   56 Size:     4 [unused]
//   float LIGHTROOM_YELLOW_EXPOSURE;   // Offset:   60 Size:     4 [unused]
//   float LIGHTROOM_GREEN_EXPOSURE;    // Offset:   64 Size:     4 [unused]
//   float LIGHTROOM_AQUA_EXPOSURE;     // Offset:   68 Size:     4 [unused]
//   float LIGHTROOM_BLUE_EXPOSURE;     // Offset:   72 Size:     4 [unused]
//   float LIGHTROOM_MAGENTA_EXPOSURE;  // Offset:   76 Size:     4 [unused]
//   float LIGHTROOM_RED_SATURATION;    // Offset:   80 Size:     4 [unused]
//   float LIGHTROOM_ORANGE_SATURATION; // Offset:   84 Size:     4 [unused]
//   float LIGHTROOM_YELLOW_SATURATION; // Offset:   88 Size:     4 [unused]
//   float LIGHTROOM_GREEN_SATURATION;  // Offset:   92 Size:     4 [unused]
//   float LIGHTROOM_AQUA_SATURATION;   // Offset:   96 Size:     4 [unused]
//   float LIGHTROOM_BLUE_SATURATION;   // Offset:  100 Size:     4 [unused]
//   float LIGHTROOM_MAGENTA_SATURATION;// Offset:  104 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_BLACK_LEVEL;// Offset:  108 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_WHITE_LEVEL;// Offset:  112 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_EXPOSURE;   // Offset:  116 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_GAMMA;      // Offset:  120 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_BLACKS_CURVE;// Offset:  124 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_SHADOWS_CURVE;// Offset:  128 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_MIDTONES_CURVE;// Offset:  132 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_HIGHLIGHTS_CURVE;// Offset:  136 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_WHITES_CURVE;// Offset:  140 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_CONTRAST;   // Offset:  144 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_SATURATION; // Offset:  148 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_VIBRANCE;   // Offset:  152 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_TEMPERATURE;// Offset:  156 Size:     4 [unused]
//   float LIGHTROOM_GLOBAL_TINT;       // Offset:  160 Size:     4 [unused]
//   bool LIGHTROOM_ENABLE_VIGNETTE;    // Offset:  164 Size:     4 [unused]
//   bool LIGHTROOM_VIGNETTE_SHOW_RADII;// Offset:  168 Size:     4 [unused]
//   float LIGHTROOM_VIGNETTE_RADIUS_INNER;// Offset:  172 Size:     4 [unused]
//   float LIGHTROOM_VIGNETTE_RADIUS_OUTER;// Offset:  176 Size:     4 [unused]
//   float LIGHTROOM_VIGNETTE_WIDTH;    // Offset:  180 Size:     4 [unused]
//   float LIGHTROOM_VIGNETTE_HEIGHT;   // Offset:  184 Size:     4 [unused]
//   float LIGHTROOM_VIGNETTE_AMOUNT;   // Offset:  188 Size:     4 [unused]
//   float LIGHTROOM_VIGNETTE_CURVE;    // Offset:  192 Size:     4 [unused]
//   int LIGHTROOM_VIGNETTE_BLEND_MODE; // Offset:  196 Size:     4 [unused]
//   float FRAME_TIME;                  // Offset:  200 Size:     4 [unused]
//   int FRAME_COUNT;                   // Offset:  204 Size:     4 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// _Globals                          cbuffer      NA          NA            cb0      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_VERTEXID              0   x           0   VERTID    uint   x   
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_POSITION              0   xyzw        0      POS   float   xyzw
// TEXCOORD                 0   xy          1     NONE   float   xy  
// TEXCOORD                 1   x           2     NONE   float   x   
// TEXCOORD                 2   x           3     NONE   float   x   
// TEXCOORD                 3   x           4     NONE   float   x   
// TEXCOORD                 4   x           5     NONE   float   x   
// TEXCOORD                 5   x           6     NONE   float   x   
// TEXCOORD                 6   x           7     NONE   float   x   
// TEXCOORD                 7   x           8     NONE   float   x   
//
vs_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[4], immediateIndexed
dcl_input_sgv v0.x, vertex_id
dcl_output_siv o0.xyzw, position
dcl_output o1.xy
dcl_output o2.x
dcl_output o3.x
dcl_output o4.x
dcl_output o5.x
dcl_output o6.x
dcl_output o7.x
dcl_output o8.x
dcl_temps 2
lt r0.x, l(0.000000), cb0[1].z
mul r0.y, cb0[1].z, l(0.083333)
mad r0.zw, cb0[1].zzzw, l(0.000000, 0.000000, 0.166667, 0.083333), l(0.000000, 0.000000, 1.000000, 0.083333)
movc r0.x, r0.x, r0.y, r0.z
mov o2.x, r0.x
mov o3.x, r0.w
mad r0.xyzw, cb0[2].xxyy, l(0.166667, 0.083333, 0.166667, 0.166667), l(0.166667, 0.166667, 0.333333, 0.333333)
lt r1.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), cb0[2].xyzx
movc r0.xy, r1.xyxx, r0.xzxx, r0.ywyy
mov o4.x, r0.x
mov o5.x, r0.y
mad r0.xyz, cb0[2].zzwz, l(0.166667, 0.166667, 0.166667, 0.000000), l(0.500000, 0.500000, 0.666667, 0.000000)
movc r0.x, r1.z, r0.x, r0.y
mov o6.x, r0.x
mov o7.x, r0.z
lt r0.x, l(0.000000), cb0[3].x
mad r0.yz, cb0[3].xxxx, l(0.000000, 0.166667, 0.166667, 0.000000), l(0.000000, 0.833333, 0.833333, 0.000000)
movc r0.x, r0.x, r0.y, r0.z
mov o8.x, r0.x
ieq r0.xy, v0.xxxx, l(2, 1, 0, 0)
and r0.xy, r0.xyxx, l(0x40000000, 0x40000000, 0, 0)
mad o0.xy, r0.xyxx, l(2.000000, -2.000000, 0.000000, 0.000000), l(-1.000000, 1.000000, 0.000000, 0.000000)
mov o1.xy, r0.xyxx
mov o0.zw, l(0,0,0,1.000000)
ret 
// Approximately 25 instruction slots used