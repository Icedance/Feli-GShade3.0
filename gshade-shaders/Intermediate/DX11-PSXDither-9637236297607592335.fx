#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\PSXDither.fx"
#line 4
uniform bool useDither <
ui_label = "Use Dithering";
ui_tooltip = "Leave unchecked to disable dithering and only truncate raw color input.";
> = false;
#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\ReShade.fxh"
#line 44
namespace ReShade
{
float GetAspectRatio() { return 2560 * (1.0 / 1440); }
float2 GetPixelSize() { return float2((1.0 / 2560), (1.0 / 1440)); }
float2 GetScreenSize() { return float2(2560, 1440); }
#line 54
texture BackBufferTex : COLOR;
texture DepthBufferTex : DEPTH;
#line 57
sampler BackBuffer { Texture = BackBufferTex; };
sampler DepthBuffer { Texture = DepthBufferTex; };
#line 61
float GetLinearizedDepth(float2 texcoord)
{
#line 66
texcoord.x /=  1;
texcoord.y /=  1;
texcoord.x -=  0 / 2.000000001;
texcoord.y +=  0 / 2.000000001;
float depth = tex2Dlod(DepthBuffer, float4(texcoord, 0, 0)).x *  1;
#line 79
const float N = 1.0;
depth /= 1000.0 - depth * (1000.0 - N);
#line 82
return depth;
}
}
#line 87
void PostProcessVS(in uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD)
{
if (id == 2)
texcoord.x = 2.0;
else
texcoord.x = 0.0;
#line 94
if (id == 1)
texcoord.y = 2.0;
else
texcoord.y = 0.0;
#line 99
position = float4(texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}
#line 9 "C:\FFXIV\game\gshade-shaders\Shaders\PSXDither.fx"
#line 12
static const float4x4 psx_dither_table = float4x4
(
0.0,     8.0,     2.0,    10.0,
12.0,     4.0,    14.0,     6.0,
3.0,    11.0,     1.0,     9.0,
15.0,     7.0,    13.0,     5.0
);
#line 23
float3 DitherCrunch(in float4 pos : SV_Position, in float2 texcoord : TEXCOORD) : COLOR
{
float3 col = tex2D(ReShade::BackBuffer, texcoord).rgb * 255.0; 
#line 27
const int2 p = int2(texcoord);
if(useDither)
{
const float dither = psx_dither_table[p.x % 4][p.y % 4];
col += (dither / 2.0 - 4.0); 
}
col = lerp((uint3(col) & 0xf8), 0xf8, step(0xf8, col));
#line 37
return col / 255.0; 
}
#line 47
technique PSXDither
{
pass ps1
{
VertexShader = PostProcessVS;
PixelShader = DitherCrunch;
}
}

