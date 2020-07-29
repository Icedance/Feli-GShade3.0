#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\Border.fx"
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
#line 20 "C:\FFXIV\game\gshade-shaders\Shaders\Border.fx"
#line 22
uniform float2 border_width <
ui_type = "slider";
ui_label = "Size";
ui_tooltip = "Measured in pixels. If this is set to zero then the ratio will be used instead.";
ui_min = 0.0; ui_max = (2560 * 0.5);
ui_step = 1.0;
> = float2(0.0, 1.0);
#line 30
uniform float border_ratio <
ui_type = "input";
ui_label = "Size Ratio";
ui_tooltip = "Set the desired ratio for the visible area.";
> = 2.35;
#line 36
uniform float4 border_color <
ui_type = "color";
ui_label = "Border Color";
> = float4(0.7, 0.0, 0.0, 1.0);
#line 41
float3 BorderPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
const float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
#line 45
float2 border_width_variable = border_width;
if (border_width.x == -border_width.y) 
if ( (2560 * (1.0 / 1440)) < border_ratio)
border_width_variable = float2(0.0, (1440 - (2560 / border_ratio)) * 0.5);
else
border_width_variable = float2((2560 - (1440 * border_ratio)) * 0.5, 0.0);
#line 52
const float2 border = ( float2((1.0 / 2560), (1.0 / 1440)) * border_width_variable); 
#line 54
if (all(saturate((-texcoord * texcoord + texcoord) - (-border * border + border)))) 
return color;
else
return lerp(color, border_color.rgb, border_color.a);
}
#line 60
technique Border
{
pass
{
VertexShader = PostProcessVS;
PixelShader = BorderPass;
}
}

