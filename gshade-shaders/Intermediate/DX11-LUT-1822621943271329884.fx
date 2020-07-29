#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\LUT.fx"
#line 57
uniform int fLUT_Selector <
ui_type = "combo";
ui_items = "GShade/Angelite\0LUT - Warm.fx\0Autumn\0ninjafada Gameplay\0ReShade 3/4\0Sleeps_Hungry\0Feli\0";
ui_label = "The LUT file to use.";
ui_tooltip = "Set this to whichever your preset requires!";
ui_bind = "LUTTexture_Source";
> = 0;
#line 70
uniform float fLUT_AmountChroma <
ui_type = "slider";
ui_min = 0.00; ui_max = 1.00;
ui_label = "LUT chroma amount";
ui_tooltip = "Intensity of color/chroma change of the LUT.";
> = 1.00;
#line 77
uniform float fLUT_AmountLuma <
ui_type = "slider";
ui_min = 0.00; ui_max = 1.00;
ui_label = "LUT luma amount";
ui_tooltip = "Intensity of luma change of the LUT.";
> = 1.00;
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
#line 88 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\LUT.fx"
#line 120
texture texLUT < source =   "lut_Feli.png" ; > { Width =   32 *   32; Height =   32; Format = RGBA8; };
sampler	SamplerLUT 	{ Texture = texLUT; };
#line 127
void PS_LUT_Apply(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 res : SV_Target0)
{
res = tex2D(ReShade::BackBuffer, texcoord.xy);
#line 131
float2 texelsize = 1.0 /   32;
texelsize.x /=   32;
#line 134
float3 lutcoord = float3((res.xy *   32 - res.xy + 0.5) * texelsize.xy, res.z *   32 - res.z);
const float lerpfact = frac(lutcoord.z);
lutcoord.x += (lutcoord.z - lerpfact) * texelsize.y;
#line 138
const float3 lutcolor = lerp(tex2D(SamplerLUT, lutcoord.xy).xyz, tex2D(SamplerLUT, float2(lutcoord.x+texelsize.y,lutcoord.y)).xyz,lerpfact);
#line 140
res.xyz = lerp(normalize(res.xyz), normalize(lutcolor.xyz), fLUT_AmountChroma) *
lerp(length(res.xyz),    length(lutcolor.xyz),    fLUT_AmountLuma);
res.w = 1.0;
}
#line 150
technique LUT
{
pass LUT_Apply
{
VertexShader = PostProcessVS;
PixelShader = PS_LUT_Apply;
}
}
