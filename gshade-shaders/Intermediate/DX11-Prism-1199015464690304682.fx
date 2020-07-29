#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Prism.fx"
#line 20
uniform int Aberration <
ui_label = "Aberration scale in pixels";
ui_type = "slider";
ui_min = -48; ui_max = 48;
> = 6;
#line 26
uniform float Curve <
ui_label = "Aberration curve";
ui_type = "slider";
ui_min = 0.0; ui_max = 4.0; ui_step = 0.01;
> = 1.0;
#line 32
uniform bool Automatic <
ui_label = "Automatic sample count";
ui_tooltip = "Amount of samples will be adjusted automatically";
ui_category = "Performance";
ui_category_closed = true;
> = true;
#line 39
uniform int SampleCount <
ui_label = "Samples";
ui_tooltip = "Amount of samples (only even numbers are accepted, odd numbers will be clamped)";
ui_type = "slider";
ui_min = 6; ui_max = 32;
ui_category = "Performance";
> = 8;
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
#line 52 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Prism.fx"
#line 55
float3 Spectrum(float Hue)
{
const float Hue4 = Hue * 4.0;
float3 HueColor = saturate(1.5 - abs(Hue4 - float3(1.0, 2.0, 1.0)));
HueColor.xz += saturate(Hue4 - 3.5);
HueColor.z = 1.0 - HueColor.z;
return HueColor;
}
#line 65
sampler SamplerColor
{
Texture = ReShade::BackBufferTex;
AddressU = MIRROR;
AddressV = MIRROR;
};
#line 72
void ChromaticAberrationPS(float4 vois : SV_Position, float2 texcoord : TexCoord, out float3 BluredImage : SV_Target)
{
#line 75
float Samples;
if (Automatic)
Samples = clamp(2.0 * ceil(abs(Aberration) * 0.5) + 2.0, 6.0, 48.0); 
else
Samples = floor(SampleCount * 0.5) * 2.0; 
#line 82
const float Sample = 1.0 / Samples;
#line 85
float2 RadialCoord = texcoord - 0.5;
RadialCoord.x *=  (1024 * (1.0 / 720));
#line 89
const float Mask = pow(2.0 * length(RadialCoord) * rsqrt( (1024 * (1.0 / 720)) *  (1024 * (1.0 / 720)) + 1.0), Curve);
#line 91
const float OffsetBase = Mask * Aberration * (1.0 / 720) * 2.0;
#line 94
if(abs(OffsetBase) < (1.0 / 720))
BluredImage = tex2D(SamplerColor, texcoord).rgb;
else
{
BluredImage = 0.0;
for (float P = 0.0; P < Samples; P++)
{
float Progress = P * Sample;
#line 104
float2 Position = RadialCoord / (OffsetBase * (Progress - 0.5) + 1.0);
#line 106
Position.x /=  (1024 * (1.0 / 720));
#line 108
Position += 0.5;
#line 111
BluredImage += Spectrum(Progress) * tex2Dlod(SamplerColor, float4(Position, 0.0, 0.0)).rgb;
}
BluredImage *= 2.0 * Sample;
}
}
#line 122
technique ChromaticAberration < ui_label = "Chromatic Aberration"; >
{
pass
{
VertexShader = PostProcessVS;
PixelShader = ChromaticAberrationPS;
}
}

