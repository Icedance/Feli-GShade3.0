#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\Monochrome.fx"
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
#line 41 "C:\FFXIV\game\gshade-shaders\Shaders\Monochrome.fx"
#line 43
uniform int Monochrome_preset <
ui_type = "combo";
ui_label = "Preset";
ui_tooltip = "Choose a preset";
#line 48
ui_items = "Custom\0"
"Monitor or modern TV\0"
"Equal weight\0"
"Agfa 200X\0"
"Agfapan 25\0"
"Agfapan 100\0"
"Agfapan 400\0"
"Ilford Delta 100\0"
"Ilford Delta 400\0"
"Ilford Delta 400 Pro & 3200\0"
"Ilford FP4\0"
"Ilford HP5\0"
"Ilford Pan F\0"
"Ilford SFX\0"
"Ilford XP2 Super\0"
"Kodak Tmax 100\0"
"Kodak Tmax 400\0"
"Kodak Tri-X\0";
> = 0;
#line 68
uniform float3 Monochrome_conversion_values <
ui_type = "color";
ui_label = "Custom Conversion values";
> = float3(0.21, 0.72, 0.07);
#line 80
uniform float Monochrome_color_saturation <
ui_label = "Saturation";
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
> = 0.0;
#line 86
float3 MonochromePass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
const float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
#line 90
float3 Coefficients = float3(0.21, 0.72, 0.07);
#line 92
const float3 Coefficients_array[18] =
{
Monochrome_conversion_values, 
float3(0.21, 0.72, 0.07), 
float3(0.3333333, 0.3333334, 0.3333333), 
float3(0.18, 0.41, 0.41), 
float3(0.25, 0.39, 0.36), 
float3(0.21, 0.40, 0.39), 
float3(0.20, 0.41, 0.39), 
float3(0.21, 0.42, 0.37), 
float3(0.22, 0.42, 0.36), 
float3(0.31, 0.36, 0.33), 
float3(0.28, 0.41, 0.31), 
float3(0.23, 0.37, 0.40), 
float3(0.33, 0.36, 0.31), 
float3(0.36, 0.31, 0.33), 
float3(0.21, 0.42, 0.37), 
float3(0.24, 0.37, 0.39), 
float3(0.27, 0.36, 0.37), 
float3(0.25, 0.35, 0.40) 
};
#line 114
Coefficients = Coefficients_array[Monochrome_preset];
#line 117
const float3 grey = dot(Coefficients, color);
#line 120
return saturate(lerp(grey, color, Monochrome_color_saturation));
}
#line 123
technique Monochrome
{
pass
{
VertexShader = PostProcessVS;
PixelShader = MonochromePass;
}
}

