//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// __s0                              sampler      NA          NA             s0      1 
// V__tMagicBloom_5                  texture  float4          2d            t12      1 
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
dcl_resource_texture2d (float,float,float,float) t12
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 5
dcl_indexableTemp x0[9], 4
dcl_indexableTemp x1[9], 4
mov r0.xyzw, l(0,0,0,-4)
mov r1.x, l(-1)
loop 
  breakc_z r1.x
  iadd r1.yz, r0.wwww, l(0, 4, 1, 0)
  itof r2.x, r0.w
  mov r3.xyz, r0.xyzx
  mov r1.w, l(-4)
  mov r2.z, l(-1)
  loop 
    breakc_z r2.z
    mov x0[0].x, l(0.026996)
    mov x0[1].x, l(0.064759)
    mov x0[2].x, l(0.120985)
    mov x0[3].x, l(0.176033)
    mov x0[4].x, l(0.199471)
    mov x0[5].x, l(0.176033)
    mov x0[6].x, l(0.120985)
    mov x0[7].x, l(0.064759)
    mov x0[8].x, l(0.026996)
    iadd r4.xy, r1.wwww, l(4, 1, 0, 0)
    mov x1[0].x, l(0.026996)
    mov x1[1].x, l(0.064759)
    mov x1[2].x, l(0.120985)
    mov x1[3].x, l(0.176033)
    mov x1[4].x, l(0.199471)
    mov x1[5].x, l(0.176033)
    mov x1[6].x, l(0.120985)
    mov x1[7].x, l(0.064759)
    mov x1[8].x, l(0.026996)
    mov r2.w, x0[r1.y + 0].x
    mov r3.w, x1[r4.x + 0].x
    mul r2.w, r2.w, r3.w
    itof r2.y, r1.w
    mad r4.xz, r2.xxyx, l(0.016667, 0.000000, 0.029630, 0.000000), v1.xxyx
    sample_indexable(texture2d)(float,float,float,float) r4.xzw, r4.xzxx, t12.xwyz, s0
    mad r3.xyz, r4.xzwx, r2.wwww, r3.xyzx
    ige r2.z, l(4), r4.y
    mov r1.w, r4.y
  endloop 
  mov r0.xyz, r3.xyzx
  ige r1.x, l(4), r1.z
  mov r0.w, r1.z
endloop 
mul o0.xyz, r0.xyzx, l(1.023520, 1.023520, 1.023520, 0.000000)
mov o0.w, l(1.000000)
ret 
// Approximately 47 instruction slots used
