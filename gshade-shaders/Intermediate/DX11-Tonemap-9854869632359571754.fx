#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Tonemap.fx"
#line 7
uniform float Gamma <
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
ui_tooltip = "Adjust midtones. 1.0 is neutral. This setting does exactly the same as the one in Lift Gamma Gain, only with less control.";
> = 1.0;
uniform float Exposure <
ui_type = "slider";
ui_min = -1.0; ui_max = 1.0;
ui_tooltip = "Adjust exposure";
> = 0.0;
uniform float Saturation <
ui_type = "slider";
ui_min = -1.0; ui_max = 1.0;
ui_tooltip = "Adjust saturation";
> = 0.0;
#line 23
uniform float Bleach <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_tooltip = "Brightens the shadows and fades the colors";
> = 0.0;
#line 29
uniform float Defog <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_tooltip = "How much of the color tint to remove";
> = 0.0;
uniform float3 FogColor <
ui_type = "color";
ui_label = "Defog Color";
ui_tooltip = "Which color tint to remove";
> = float3(0.0, 0.0, 1.0);
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ReShade.fxh"
#line 44
namespace ReShade
{
float GetAspectRatio() { return 2560 * (1.0 / 1377); }
float2 GetPixelSize() { return float2((1.0 / 2560), (1.0 / 1377)); }
float2 GetScreenSize() { return float2(2560, 1377); }
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
#line 41 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Tonemap.fx"
#line 43
float3 TonemapPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
float3 color = saturate(tex2D(ReShade::BackBuffer, texcoord).rgb - Defog * FogColor * 2.55); 
color *= pow(2.0f, Exposure); 
color = pow(color, Gamma); 
#line 49
const float lum = dot(float3(0.2126, 0.7152, 0.0722), color);
#line 51
const float3 A2 = Bleach * color;
#line 53
color += ((1.0f - A2) * (A2 * lerp(2.0f * color * lum, 1.0f - 2.0f * (1.0f - lum) * (1.0f - color), saturate(10.0 * (lum - 0.45)))));
#line 59
const float3 diffcolor = (color - dot(color, (1.0 / 3.0))) * Saturation;
#line 61
color = (color + diffcolor) / (1 + diffcolor); 
#line 63
return color;
}
#line 66
technique Tonemap
{
pass
{
VertexShader = PostProcessVS;
PixelShader = TonemapPass;
}
}

