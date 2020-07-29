#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FilmicAnamorphSharpen.fx"
#line 16
uniform float Strength <
ui_label = "Strength";
ui_category = "Settings";
ui_type = "slider";
ui_min = 0.0; ui_max = 100.0; ui_step = 0.01;
> = 60.0;
#line 23
uniform float Offset <
ui_label = "Radius";
ui_type = "slider";
ui_tooltip = "High-pass cross offset in pixels";
ui_category = "Settings";
ui_min = 0.0; ui_max = 2.0; ui_step = 0.01;
> = 0.1;
#line 32
uniform float Clamp <
ui_label = "Clamping";
ui_category = "Settings";
ui_type = "slider";
ui_min = 0.5; ui_max = 1.0; ui_step = 0.001;
> = 0.65;
#line 39
uniform bool UseMask <
ui_label = "Sharpen only center";
ui_category = "Settings";
ui_tooltip = "Sharpen only in center of the image";
> = false;
#line 45
uniform bool DepthMask <
ui_label = "Enable depth rim masking";
ui_tooltip = "Depth high-pass mask switch";
ui_category = "Depth mask";
ui_category_closed = true;
> = true;
#line 52
uniform int DepthMaskContrast <
ui_label = "Edges mask strength";
ui_tooltip = "Depth high-pass mask amount";
ui_category = "Depth mask";
ui_type = "slider";
ui_min = 0; ui_max = 2000; ui_step = 1;
> = 128;
#line 60
uniform int Coefficient <
ui_tooltip = "For digital video signal use BT.709, for analog (like VGA) use BT.601";
ui_label = "YUV coefficients";
ui_type = "radio";
ui_items = "BT.709 - digital\0BT.601 - analog\0";
ui_category = "Additional settings";
ui_category_closed = true;
> = 0;
#line 69
uniform bool Preview <
ui_label = "Preview sharpen layer";
ui_tooltip = "Preview sharpen layer and mask for adjustment.\n"
"If you don't see red strokes,\n"
"try changing Preprocessor Definitions in the Settings tab.";
ui_category = "Debug View";
ui_category_closed = true;
> = false;
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ReShade.fxh"
#line 44
namespace ReShade
{
float GetAspectRatio() { return 1024 * (1.0 / 720); }
float2 GetPixelSize() { return float2((1.0 / 1024), (1.0 / 720)); }
float2 GetScreenSize() { return float2(1024, 720); }
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
#line 83 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FilmicAnamorphSharpen.fx"
#line 86
static const float3 Luma709 = float3(0.2126, 0.7152, 0.0722);
#line 88
static const float3 Luma601 = float3(0.299, 0.587, 0.114);
#line 91
float Overlay(float LayerA, float LayerB)
{
const float MinA = min(LayerA, 0.5);
const float MinB = min(LayerB, 0.5);
const float MaxA = max(LayerA, 0.5);
const float MaxB = max(LayerB, 0.5);
return 2.0 * (MinA * MinB + MaxA + MaxB - MaxA * MaxB) - 1.5;
}
#line 101
float Overlay(float LayerAB)
{
const float MinAB = min(LayerAB, 0.5);
const float MaxAB = max(LayerAB, 0.5);
return 2.0 * (MinAB * MinAB + MaxAB + MaxAB - MaxAB * MaxAB) - 1.5;
}
#line 109
float3 FilmicAnamorphSharpenPS(float4 pos : SV_Position, float2 UvCoord : TEXCOORD) : SV_Target
{
#line 112
float3 Source = tex2D(ReShade::BackBuffer, UvCoord).rgb;
#line 115
float Mask;
if (UseMask)
{
#line 119
Mask = 1.0-length(UvCoord*2.0-1.0);
Mask = Overlay(Mask) * Strength;
#line 122
if (Mask <= 0) return Source;
}
else Mask = Strength;
#line 127
float2 Pixel =  float2((1.0 / 1024), (1.0 / 720));
#line 130
float3 LumaCoefficient;
if (bool(Coefficient))
LumaCoefficient = Luma601;
else
LumaCoefficient = Luma709;
#line 136
if (DepthMask)
{
#line 139
const float2 PixelOffset = Pixel * Offset;
const float2 DepthPixel = PixelOffset + Pixel;
Pixel = PixelOffset;
#line 144
const float SourceDepth = ReShade::GetLinearizedDepth(UvCoord);
#line 146
const float2 NorSouWesEst[4] = {
float2(UvCoord.x, UvCoord.y + Pixel.y),
float2(UvCoord.x, UvCoord.y - Pixel.y),
float2(UvCoord.x + Pixel.x, UvCoord.y),
float2(UvCoord.x - Pixel.x, UvCoord.y)
};
#line 153
const float2 DepthNorSouWesEst[4] = {
float2(UvCoord.x, UvCoord.y + DepthPixel.y),
float2(UvCoord.x, UvCoord.y - DepthPixel.y),
float2(UvCoord.x + DepthPixel.x, UvCoord.y),
float2(UvCoord.x - DepthPixel.x, UvCoord.y)
};
#line 162
float HighPassColor = 0.0, DepthMask = 0.0;
#line 164
[unroll]for(int s = 0; s < 4; s++)
{
HighPassColor += dot(tex2D(ReShade::BackBuffer, NorSouWesEst[s]).rgb, LumaCoefficient);
DepthMask += ReShade::GetLinearizedDepth(NorSouWesEst[s])
+ ReShade::GetLinearizedDepth(DepthNorSouWesEst[s]);
}
#line 171
HighPassColor = 0.5 - 0.5 * (HighPassColor * 0.25 - dot(Source, LumaCoefficient));
#line 173
DepthMask = 1.0 - DepthMask * 0.125 + SourceDepth;
DepthMask = min(1.0, DepthMask) + 1.0 - max(1.0, DepthMask);
DepthMask = saturate(DepthMaskContrast * DepthMask + 1.0 - DepthMaskContrast);
#line 178
HighPassColor = lerp(0.5, HighPassColor, Mask * DepthMask);
#line 186
if (Clamp != 1.0)
HighPassColor = clamp(HighPassColor, 1.0 - Clamp, Clamp);
#line 189
const float3 Sharpen = float3(
Overlay(Source.r, HighPassColor),
Overlay(Source.g, HighPassColor),
Overlay(Source.b, HighPassColor)
);
#line 195
if(Preview) 
{
const float PreviewChannel = lerp(HighPassColor, HighPassColor * DepthMask, 0.5);
return float3(
1.0 - DepthMask * (1.0 - HighPassColor),
PreviewChannel,
PreviewChannel
);
}
#line 205
return Sharpen;
}
else
{
Pixel *= Offset;
#line 211
const float2 NorSouWesEst[4] = {
float2(UvCoord.x, UvCoord.y + Pixel.y),
float2(UvCoord.x, UvCoord.y - Pixel.y),
float2(UvCoord.x + Pixel.x, UvCoord.y),
float2(UvCoord.x - Pixel.x, UvCoord.y)
};
#line 219
float HighPassColor = 0.0;
[unroll]
for(int s = 0; s < 4; s++)
HighPassColor += dot(tex2D(ReShade::BackBuffer, NorSouWesEst[s]).rgb, LumaCoefficient);
#line 227
HighPassColor = 0.5 - 0.5 * (HighPassColor * 0.25 - dot(Source, LumaCoefficient));
#line 230
HighPassColor = lerp(0.5, HighPassColor, Mask);
#line 238
if (Clamp != 1.0)
HighPassColor = clamp(HighPassColor, 1.0 - Clamp, Clamp);
#line 241
const float3 Sharpen = float3(
Overlay(Source.r, HighPassColor),
Overlay(Source.g, HighPassColor),
Overlay(Source.b, HighPassColor)
);
#line 248
if (Preview)
return HighPassColor;
else
return float3(Overlay(Source.r, HighPassColor), Overlay(Source.g, HighPassColor), Overlay(Source.b, HighPassColor));
}
}
#line 260
technique FilmicAnamorphSharpen < ui_label = "Filmic Anamorphic Sharpen"; >
{
pass
{
VertexShader = PostProcessVS;
PixelShader = FilmicAnamorphSharpenPS;
}
}

