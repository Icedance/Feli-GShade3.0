#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Spotlight3.fx"
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
#line 9 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Spotlight3.fx"
#line 11
uniform float u3XCenter <
ui_label = "X Position";
ui_type = "slider";
ui_min = -1.0; ui_max = 1.0;
ui_tooltip = "X coordinate of beam center. Axes start from upper left screen corner.";
> = 0;
#line 18
uniform float u3YCenter <
ui_label = "Y Position";
ui_type = "slider";
ui_min = -1.0; ui_max = 1.0;
ui_tooltip = "Y coordinate of beam center. Axes start from upper left screen corner.";
> = 0;
#line 25
uniform float u3Brightness <
ui_label = "Brightness";
ui_tooltip =
"Spotlight halo brightness.\n"
"\nDefault: 10.0";
ui_type = "slider";
ui_min = 0.0;
ui_max = 100.0;
ui_step = 0.01;
> = 10.0;
#line 36
uniform float u3Size <
ui_label = "Size";
ui_tooltip =
"Spotlight halo size in pixels.\n"
"\nDefault: 420.0";
ui_type = "slider";
ui_min = 10.0;
ui_max = 1000.0;
ui_step = 1.0;
> = 420.0;
#line 47
uniform float3 u3Color <
ui_label = "Color";
ui_tooltip =
"Spotlight halo color.\n"
"\nDefault: R:255 G:230 B:200";
ui_type = "color";
> = float3(255, 230, 200) / 255.0;
#line 55
uniform float u3Distance <
ui_label = "Distance";
ui_tooltip =
"The distance that the spotlight can illuminate.\n"
"Only works if the game has depth buffer access.\n"
"\nDefault: 0.1";
ui_type = "slider";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.001;
> = 0.1;
#line 67
uniform bool u3BlendFix <
ui_label = "Toggle Blend Fix";
ui_tooltip = "Enable to use the original blending mode.";
> = 0;
#line 72
uniform bool u3ToggleTexture <
ui_label = "Toggle Texture";
ui_tooltip = "Enable or disable the spotlight texture.";
> = 1;
#line 77
uniform bool u3ToggleDepth <
ui_label = "Toggle Depth";
ui_tooltip = "Enable or disable depth.";
> = 1;
#line 82
sampler2D s3Color {
Texture = ReShade::BackBufferTex;
SRGBTexture = true;
MinFilter = POINT;
MagFilter = POINT;
};
#line 91
float4 PS_3Spotlight(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET {
const float2 res =  float2(2560, 1440);
const float2 uCenter = uv - float2(u3XCenter, -u3YCenter);
float2 coord = res * uCenter;
#line 96
float halo = distance(coord, res * 0.5);
float spotlight = u3Size - min(halo, u3Size);
spotlight /= u3Size;
#line 102
if (u3ToggleTexture == 0)
{
float defects = sin(spotlight * 30.0) * 0.5 + 0.5;
defects = lerp(defects, 1.0, spotlight * 2.0);
#line 107
static const float contrast = 0.125;
#line 109
defects = 0.5 * (1.0 - contrast) + defects * contrast;
spotlight *= defects * 4.0;
}
else
{
spotlight *= 2.0;
}
#line 117
if (u3ToggleDepth == 1)
{
float depth = 1.0 - ReShade::GetLinearizedDepth(uv);
depth = pow(abs(depth), 1.0 / u3Distance);
spotlight *= depth;
}
#line 124
float3 colored_spotlight = spotlight * u3Color;
colored_spotlight *= colored_spotlight * colored_spotlight;
#line 127
float3 result = 1.0 + colored_spotlight * u3Brightness;
#line 129
float3 color = tex2D(s3Color, uv).rgb;
color *= result;
#line 132
if (!u3BlendFix)
#line 134
color = max(color, (result - 1.0) * 0.001);
#line 136
return float4(color, 1.0);
}
#line 139
technique Spotlight3 {
pass {
VertexShader = PostProcessVS;
PixelShader = PS_3Spotlight;
SRGBWriteEnable = true;
}
}

