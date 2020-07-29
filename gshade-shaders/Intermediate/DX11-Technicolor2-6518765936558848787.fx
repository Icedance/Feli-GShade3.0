#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Technicolor2.fx"
#line 8
uniform float3 ColorStrength <
ui_type = "color";
ui_tooltip = "Higher means darker and more intense colors.";
> = float3(0.2, 0.2, 0.2);
#line 13
uniform float Brightness <
ui_type = "slider";
ui_min = 0.5; ui_max = 1.5;
ui_tooltip = "Higher means brighter image.";
> = 1.0;
uniform float Saturation <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.5;
ui_tooltip = "Additional saturation control since this effect tends to oversaturate the image.";
> = 1.0;
#line 24
uniform float Strength <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_tooltip = "Adjust the strength of the effect.";
> = 1.0;
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ReShade.fxh"
#line 44
namespace ReShade
{
float GetAspectRatio() { return 1920 * (1.0 / 1080); }
float2 GetPixelSize() { return float2((1.0 / 1920), (1.0 / 1080)); }
float2 GetScreenSize() { return float2(1920, 1080); }
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
#line 30 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Technicolor2.fx"
#line 32
float3 TechnicolorPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
float3 color = saturate(tex2D(ReShade::BackBuffer, texcoord).rgb);
#line 36
float3 temp = 1.0 - color;
float3 target = temp.grg;
float3 target2 = temp.bbr;
float3 temp2 = color * target;
temp2 *= target2;
#line 42
temp = temp2 * ColorStrength;
temp2 *= Brightness;
#line 45
target = temp.grg;
target2 = temp.bbr;
#line 48
temp = color - target;
temp += temp2;
temp2 = temp - target2;
#line 52
color = lerp(color, temp2, Strength);
#line 54
return lerp(dot(color, 0.333), color, Saturation);
}
#line 57
technique Technicolor2
{
pass
{
VertexShader = PostProcessVS;
PixelShader = TechnicolorPass;
}
}

