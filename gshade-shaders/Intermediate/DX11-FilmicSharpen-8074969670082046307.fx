#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FilmicSharpen.fx"
#line 16
uniform float Strength <
ui_label = "Strength";
ui_type = "slider";
ui_min = 0.0; ui_max = 100.0; ui_step = 0.01;
> = 60.0;
#line 22
uniform float Offset <
ui_label = "Radius";
ui_tooltip = "High-pass cross offset in pixels";
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0; ui_step = 0.001;
> = 0.1;
#line 29
uniform float Clamp <
ui_label = "Clamping";
ui_type = "slider";
ui_min = 0.5; ui_max = 1.0; ui_step = 0.001;
> = 0.65;
#line 35
uniform bool UseMask <
ui_label = "Sharpen only center";
ui_tooltip = "Sharpen only in center of the image";
> = false;
#line 40
uniform int Coefficient <
ui_tooltip = "For digital video signal use BT.709, for analog (like VGA) use BT.601";
ui_label = "YUV coefficients";
ui_type = "radio";
ui_items = "BT.709 - digital\0BT.601 - analog\0";
ui_category = "Additional settings";
ui_category_closed = true;
> = 0;
#line 49
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
#line 63 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FilmicSharpen.fx"
#line 66
static const float3 Luma709 = float3(0.2126, 0.7152, 0.0722);
#line 68
static const float3 Luma601 = float3(0.299, 0.587, 0.114);
#line 71
float Overlay(float LayerA, float LayerB)
{
const float MinA = min(LayerA, 0.5);
const float MinB = min(LayerB, 0.5);
const float MaxA = max(LayerA, 0.5);
const float MaxB = max(LayerB, 0.5);
return 2.0 * (MinA * MinB + MaxA + MaxB - MaxA * MaxB) - 1.5;
}
#line 81
float Overlay(float LayerAB)
{
const float MinAB = min(LayerAB, 0.5);
const float MaxAB = max(LayerAB, 0.5);
return 2.0 * (MinAB * MinAB + MaxAB + MaxAB - MaxAB * MaxAB) - 1.5;
}
#line 89
float3 FilmicSharpenPS(float4 pos : SV_Position, float2 UvCoord : TEXCOORD) : SV_Target
{
#line 92
const float3 Source = tex2D(ReShade::BackBuffer, UvCoord).rgb;
#line 95
float Mask; if (UseMask)
{
#line 98
Mask = 1.0-length(UvCoord*2.0-1.0);
Mask = Overlay(Mask) * Strength;
#line 101
if (Mask <= 0) return Source;
}
else Mask = Strength;
#line 106
const float2 Pixel =  float2((1.0 / 2560), (1.0 / 1440)) * Offset;
#line 109
const float2 NorSouWesEst[4] = {
float2(UvCoord.x, UvCoord.y + Pixel.y),
float2(UvCoord.x, UvCoord.y - Pixel.y),
float2(UvCoord.x + Pixel.x, UvCoord.y),
float2(UvCoord.x - Pixel.x, UvCoord.y)
};
#line 117
float3 LumaCoefficient;
if (bool(Coefficient))
LumaCoefficient = Luma601;
else
LumaCoefficient = Luma709;
#line 124
float HighPass = 0.0;
[unroll]
for(int i=0; i<4; i++)
HighPass += dot(tex2D(ReShade::BackBuffer, NorSouWesEst[i]).rgb, LumaCoefficient);
#line 129
HighPass = 0.5 - 0.5 * (HighPass * 0.25 - dot(Source, LumaCoefficient));
#line 132
HighPass = lerp(0.5, HighPass, Mask);
#line 135
if (Clamp != 1.0)
HighPass = clamp(HighPass, 1.0 - Clamp, Clamp);
#line 138
const float3 Sharpen = float3(
Overlay(Source.r, HighPass),
Overlay(Source.g, HighPass),
Overlay(Source.b, HighPass)
);
#line 144
if (Preview)
return HighPass;
else
return Sharpen;
}
#line 155
technique FilmicSharpen < ui_label = "Filmic Sharpen"; >
{
pass
{
VertexShader = PostProcessVS;
PixelShader = FilmicSharpenPS;
}
}

