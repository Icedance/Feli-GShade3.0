#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ColShift.fx"
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
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ColShift.fx"
#line 3
uniform float HardRedCutoff <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Hard Red Cutoff";
> = float(0.85);
#line 9
uniform float SoftRedCutoff <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Soft Red Cutoff";
> = float(0.6);
#line 15
uniform float HardGreenCutoff <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Hard Green Cutoff";
> = float(0.6);
#line 21
uniform float SoftGreenCutoff <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Soft Green Cutoff";
> = float(0.85);
#line 27
uniform float BlueCutoff <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Blue Cutoff";
> = float(0.3);
#line 33
uniform bool Yellow <
ui_type = "checkbox";
ui_label = "Yellow instead of Green";
> = false;
#line 39
float3 ColShiftPass(float4 position: SV_Position, float2 texcoord: TexCoord): SV_Target
{
const float3 input = tex2D(ReShade::BackBuffer, texcoord).rgb;
if (input.r >= HardRedCutoff && input.g <= HardGreenCutoff && input.b <= BlueCutoff)
{
if (Yellow)
return input.rrb;
else
return input.grb;
}
#line 50
if (input.r >= SoftRedCutoff && input.g <= SoftGreenCutoff && input.b <= BlueCutoff)
{
const float alphaR = (input.r - SoftRedCutoff) / (HardRedCutoff - SoftRedCutoff);
if (Yellow)
return lerp(input.rgb, input.rrb, alphaR);
else
return lerp(input.rgb, input.grb, alphaR);
}
#line 59
return input;
}
#line 62
technique ColShift
{
pass
{
VertexShader = PostProcessVS;
PixelShader = ColShiftPass;
}
}

