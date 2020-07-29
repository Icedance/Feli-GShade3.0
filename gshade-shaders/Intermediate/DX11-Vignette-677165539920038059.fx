#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Vignette.fx"
#line 10
uniform int Type <
ui_type = "combo";
ui_items = "Original\0New\0TV style\0Untitled 1\0Untitled 2\0Untitled 3\0Untitled 4\0";
> = 0;
uniform float Ratio <
ui_type = "slider";
ui_min = 0.15; ui_max = 6.0;
ui_tooltip = "Sets a width to height ratio. 1.00 (1/1) is perfectly round, while 1.60 (16/10) is 60 % wider than it's high.";
> = 1.0;
uniform float Radius <
ui_type = "slider";
ui_min = -1.0; ui_max = 3.0;
ui_tooltip = "lower values = stronger radial effect from center";
> = 2.0;
uniform float Amount <
ui_type = "slider";
ui_min = -2.0; ui_max = 1.0;
ui_tooltip = "Strength of black. -2.00 = Max Black, 1.00 = Max White.";
> = -1.0;
uniform int Slope <
ui_type = "slider";
ui_min = 2; ui_max = 16;
ui_tooltip = "How far away from the center the change should start to really grow strong (odd numbers cause a larger fps drop than even numbers).";
> = 2;
uniform float2 Center <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_tooltip = "Center of effect for 'Original' vignette type. 'New' and 'TV style' do not obey this setting.";
> = float2(0.5, 0.5);
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
#line 40 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Vignette.fx"
#line 42
float4 VignettePass(float4 vpos : SV_Position, float2 tex : TexCoord) : SV_Target
{
float4 color = tex2D(ReShade::BackBuffer, tex);
#line 46
if (Type == 0)
{
#line 49
float2 distance_xy = tex - Center;
#line 52
distance_xy *= float2(((1.0 / 1440) / (1.0 / 2560)), Ratio);
#line 55
distance_xy /= Radius;
const float distance = dot(distance_xy, distance_xy);
#line 59
color.rgb *= (1.0 + pow(distance, Slope * 0.5) * Amount); 
}
#line 62
if (Type == 1) 
{
tex = -tex * tex + tex;
color.rgb = saturate((((1.0 / 1440) / (1.0 / 2560))*((1.0 / 1440) / (1.0 / 2560)) * Ratio * tex.x + tex.y) * 4.0) * color.rgb;
}
#line 68
if (Type == 2) 
{
tex = -tex * tex + tex;
color.rgb = saturate(tex.x * tex.y * 100.0) * color.rgb;
}
#line 74
if (Type == 3)
{
tex = abs(tex - 0.5);
float tc = dot(float4(-tex.x, -tex.x, tex.x, tex.y), float4(tex.y, tex.y, 1.0, 1.0)); 
#line 79
tc = saturate(tc - 0.495);
color.rgb *= (pow((1.0 - tc * 200), 4) + 0.25); 
}
#line 83
if (Type == 4)
{
tex = abs(tex - 0.5);
float tc = dot(float4(-tex.x, -tex.x, tex.x, tex.y), float4(tex.y, tex.y, 1.0, 1.0)); 
#line 88
tc = saturate(tc - 0.495) - 0.0002;
color.rgb *= (pow((1.0 - tc * 200), 4) + 0.0); 
}
#line 92
if (Type == 5) 
{
tex = abs(tex - 0.5);
float tc = tex.x * (-2.0 * tex.y + 1.0) + tex.y; 
#line 97
tc = saturate(tc - 0.495);
color.rgb *= (pow((-tc * 200 + 1.0), 4) + 0.25); 
#line 100
}
#line 102
if (Type == 6) 
{
#line 105
const float tex_xy = dot(float4(tex, tex), float4(-tex, 1.0, 1.0)); 
color.rgb = saturate(tex_xy * 4.0) * color.rgb;
}
#line 109
return color;
}
#line 112
technique Vignette
{
pass
{
VertexShader = PostProcessVS;
PixelShader = VignettePass;
}
}

