#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\AspectRatioComposition.fx"
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
#line 6 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\AspectRatioComposition.fx"
#line 27
uniform int2 iUIAspectRatio <
ui_type = "slider";
ui_label = "Aspect Ratio";
ui_tooltip = "To control aspect ratio with a float\nadd 'ASPECT_RATIO_FLOAT' to preprocessor.\nOptional: 'ASPECT_RATIO_MAX=xyz'";
ui_min = 0; ui_max =  25;
> = int2(16, 9);
#line 35
uniform int iUIGridType <
ui_type = "combo";
ui_label = "Grid Type";
ui_items = "Off\0Fractions\0Golden Ratio\0";
> = 0;
#line 41
uniform int iUIGridFractions <
ui_type = "slider";
ui_label = "Fractions";
ui_tooltip = "Set 'Grid Type' to 'Fractions'";
ui_min = 1; ui_max = 5;
> = 3;
#line 48
uniform float4 UIGridColor <
ui_type = "color";
ui_label = "Grid Color";
> = float4(0.0, 0.0, 0.0, 1.0);
#line 57
float3 DrawGrid(float3 backbuffer, float3 gridColor, float aspectRatio, float fraction, float4 vpos)
{
float borderSize;
float fractionWidth;
#line 62
float3 retVal = backbuffer;
#line 64
if(aspectRatio <  (1024 * (1.0 / 720)))
{
borderSize = (1024 - 720 * aspectRatio) / 2.0;
fractionWidth = (1024 - 2 * borderSize) / fraction;
#line 69
if(vpos.x < borderSize || vpos.x > (1024 - borderSize))
retVal = gridColor;
#line 72
if((vpos.y % (720 / fraction)) < 1)
retVal = gridColor;
#line 75
if(((vpos.x - borderSize) % fractionWidth) < 1)
retVal = gridColor;
}
else
{
borderSize = (720 - 1024 / aspectRatio) / 2.0;
fractionWidth = (720 - 2 * borderSize) / fraction;
#line 83
if(vpos.y < borderSize || vpos.y > (720 - borderSize))
retVal = gridColor;
#line 86
if((vpos.x % (1024 / fraction)) < 1)
retVal = gridColor;
#line 89
if(((vpos.y - borderSize) % fractionWidth) < 1)
retVal = gridColor;
#line 92
}
#line 94
if(vpos.x <= 1 || vpos.x >= 1024-1 || vpos.y <= 1 || vpos.y >= 720-1)
retVal = gridColor;
#line 97
return retVal;
}
#line 104
float3 AspectRatioComposition_PS(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
float3 retVal = color;
#line 109
float userAspectRatio;
#line 114
userAspectRatio = (float)iUIAspectRatio.x / (float)iUIAspectRatio.y;
#line 117
if(iUIGridType == 1)
retVal = DrawGrid(color, UIGridColor.rgb, userAspectRatio, iUIGridFractions, vpos);
else if(iUIGridType == 2)
{
retVal = DrawGrid(color, UIGridColor.rgb, userAspectRatio,  1.6180339887, vpos);
retVal = DrawGrid(retVal, UIGridColor.rgb, userAspectRatio,  1.6180339887, float4(1024, 720, 0, 0) - vpos);
}
#line 125
return lerp(color, retVal, UIGridColor.w);
}
#line 128
technique AspectRatioComposition
{
pass
{
VertexShader = PostProcessVS;
PixelShader = AspectRatioComposition_PS;
}
}
