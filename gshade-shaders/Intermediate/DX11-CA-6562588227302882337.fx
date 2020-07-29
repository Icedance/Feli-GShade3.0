#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\CA.fx"
#line 10
uniform float2 Shift <
ui_type = "slider";
ui_min = -10; ui_max = 10;
ui_tooltip = "Distance (X,Y) in pixels to shift the color components. For a slightly blurred look try fractional values (.5) between two pixels.";
> = float2(2.5, -0.5);
uniform float Strength <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
> = 0.5;
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
#line 20 "C:\FFXIV\game\gshade-shaders\Shaders\CA.fx"
#line 22
float3 ChromaticAberrationPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
float3 color, colorInput = tex2D(ReShade::BackBuffer, texcoord).rgb;
#line 26
color.r = tex2D(ReShade::BackBuffer, texcoord + ( float2((1.0 / 2560), (1.0 / 1440)) * Shift)).r;
color.g = colorInput.g;
color.b = tex2D(ReShade::BackBuffer, texcoord - ( float2((1.0 / 2560), (1.0 / 1440)) * Shift)).b;
#line 31
return lerp(colorInput, color, Strength);
}
#line 34
technique CAb
{
pass
{
VertexShader = PostProcessVS;
PixelShader = ChromaticAberrationPass;
}
}

