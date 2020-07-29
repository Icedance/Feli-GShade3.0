#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ColorInversion.fx"
#line 32
uniform int nInversionSelector <
ui_type = "combo";
ui_items = "All\0Red\0Green\0Blue\0Red & Green\0Red & Blue\0Green & Blue\0None\0";
ui_label = "The color(s) to invert.";
> = 0;
#line 38
uniform float nInversionRed <
ui_type = "slider";
ui_label = "Red";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.001;
> = 1.0;
#line 46
uniform float nInversionGreen <
ui_type = "slider";
ui_label = "Green";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.001;
> = 1.0;
#line 54
uniform float nInversionBlue <
ui_type = "slider";
ui_label = "Blue";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.001;
> = 1.0;
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
#line 62 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ColorInversion.fx"
#line 64
float4 SV_ColorInversion(float4 pos : SV_Position, float2 col : TEXCOORD) : SV_TARGET
{
float4 inversion = tex2D(ReShade::BackBuffer, col);
inversion.r = inversion.r * nInversionRed;
inversion.g = inversion.g * nInversionGreen;
inversion.b = inversion.b * nInversionBlue;
if (nInversionSelector == 0)
{
inversion.r = 1.0f - inversion.r;
inversion.g = 1.0f - inversion.g;
inversion.b = 1.0f - inversion.b;
}
else if (nInversionSelector == 1)
{
inversion.r = 1.0f - inversion.r;
}
else if (nInversionSelector == 2)
{
inversion.g = 1.0f - inversion.g;
}
else if (nInversionSelector == 3)
{
inversion.b = 1.0f - inversion.b;
}
else if (nInversionSelector == 4)
{
inversion.r = 1.0f - inversion.r;
inversion.g = 1.0f - inversion.g;
}
else if (nInversionSelector == 5)
{
inversion.r = 1.0f - inversion.r;
inversion.b = 1.0f - inversion.b;
}
else if (nInversionSelector == 6)
{
inversion.g = 1.0f - inversion.g;
inversion.b = 1.0f - inversion.b;
}
else
{
return inversion;
}
return inversion;
}
#line 110
technique ColorInversion
{
pass
{
VertexShader = PostProcessVS;
PixelShader = SV_ColorInversion;
}
}

