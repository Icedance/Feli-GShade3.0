#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\CAS.fx"
#line 42
uniform float Contrast <
ui_type = "slider";
ui_label = "Contrast Adaptation";
ui_tooltip = "Adjusts the range the shader adapts to high contrast (0 is not all the way off).  Higher values = more high contrast sharpening.";
ui_min = 0.0; ui_max = 1.0;
> = 0.0;
#line 49
uniform float Sharpening <
ui_type = "slider";
ui_label = "Sharpening intensity";
ui_tooltip = "Adjusts sharpening intensity by averaging the original pixels to the sharpened result.  1.0 is the unmodified default.";
ui_min = 0.0; ui_max = 1.0;
> = 1.0;
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
#line 56 "C:\FFXIV\game\gshade-shaders\Shaders\CAS.fx"
texture TexCASColor : COLOR;
sampler sTexCASColor {Texture = TexCASColor; SRGBTexture = true;};
#line 60
float3 CASPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
#line 66
const float3 a = tex2Doffset(sTexCASColor, texcoord, int2(-1, -1)).rgb;
const float3 b = tex2Doffset(sTexCASColor, texcoord, int2(0, -1)).rgb;
const float3 c = tex2Doffset(sTexCASColor, texcoord, int2(1, -1)).rgb;
const float3 d = tex2Doffset(sTexCASColor, texcoord, int2(-1, 0)).rgb;
const float3 e = tex2Doffset(sTexCASColor, texcoord, int2(0, 0)).rgb;
const float3 f = tex2Doffset(sTexCASColor, texcoord, int2(1, 0)).rgb;
const float3 g = tex2Doffset(sTexCASColor, texcoord, int2(-1, 1)).rgb;
const float3 h = tex2Doffset(sTexCASColor, texcoord, int2(0, 1)).rgb;
const float3 i = tex2Doffset(sTexCASColor, texcoord, int2(1, 1)).rgb;
#line 81
float3 mnRGB = min(min(min(d, e), min(f, b)), h);
const float3 mnRGB2 = min(mnRGB, min(min(a, c), min(g, i)));
mnRGB += mnRGB2;
#line 85
float3 mxRGB = max(max(max(d, e), max(f, b)), h);
const float3 mxRGB2 = max(mxRGB, max(max(a, c), max(g, i)));
mxRGB += mxRGB2;
#line 91
const float3 wRGB = -rcp(rsqrt(saturate(min(mnRGB, 2.0 - mxRGB) * rcp(mxRGB))) * (8.0 - 3.0 * Contrast));
#line 96
return lerp(e, saturate((((b + d) + (f + h)) * wRGB + e) * rcp(1.0 + 4.0 * wRGB)), Sharpening);
}
#line 99
technique ContrastAdaptiveSharpen
{
pass
{
VertexShader = PostProcessVS;
PixelShader = CASPass;
SRGBWriteEnable = true;
}
}

