#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\DirectionalDepthBlur.fx"
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
#line 42 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\DirectionalDepthBlur.fx"
#line 44
namespace DirectionalDepthBlur
{
#line 57
uniform float FocusPlane <
ui_category = "Focusing";
ui_label= "Focus plane";
ui_type = "slider";
ui_min = 0.001; ui_max = 1.000;
ui_step = 0.001;
ui_tooltip = "The depth of the plane where the blur starts, related to the camera";
> = 0.010;
uniform float FocusRange <
ui_category = "Focusing";
ui_label= "Focus range";
ui_type = "slider";
ui_min = 0.001; ui_max = 1.000;
ui_step = 0.001;
ui_tooltip = "The range around the focus plane that's more or less not blurred.\n1.0 is the FocusPlaneMaxRange.";
> = 0.001;
uniform float FocusPlaneMaxRange <
ui_category = "Focusing";
ui_label= "Focus plane max range";
ui_type = "slider";
ui_min = 10; ui_max = 300;
ui_step = 1;
ui_tooltip = "The max range Focus Plane for when Focus Plane is 1.0.\n1000 is the horizon.";
> = 150;
uniform float BlurAngle <
ui_category = "Blur tweaking";
ui_label="Blur angle";
ui_type = "slider";
ui_min = 0.01; ui_max = 1.00;
ui_tooltip = "The angle of the blur direction";
ui_step = 0.01;
> = 1.0;
uniform float BlurLength <
ui_category = "Blur tweaking";
ui_label = "Blur length";
ui_type = "slider";
ui_min = 0.000; ui_max = 1.0;
ui_step = 0.001;
ui_tooltip = "The length of the blur strokes per pixel. 1.0 is the entire screen.";
> = 0.1;
uniform float BlurQuality <
ui_category = "Blur tweaking";
ui_label = "Blur quality";
ui_type = "slider";
ui_min = 0.01; ui_max = 1.0;
ui_step = 0.01;
ui_tooltip = "The quality of the blur. 1.0 means all pixels in the blur length are\nread, 0.5 means half of them are read.";
> = 0.5;
uniform float ScaleFactor <
ui_category = "Blur tweaking";
ui_label = "Scale factor";
ui_type = "slider";
ui_min = 0.010; ui_max = 1.000;
ui_step = 0.001;
ui_tooltip = "The scale factor for the pixels to blur. Lower values downscale the\nsource frame and will result in wider blur strokes.";
> = 1.000;
uniform int BlurType <
ui_category = "Blur tweaking";
ui_type = "combo";
ui_min= 0; ui_max=1;
ui_items="Parallel Strokes\0Focus Point Targeting Strokes\0";
ui_label = "The blur type";
ui_tooltip = "The blur type. Focus Point Targeting Strokes means the blur directions\nper pixel are towards the Focus Point.";
> = 0;
uniform float2 FocusPoint <
ui_category = "Blur tweaking";
ui_label = "Blur focus point";
ui_type = "slider";
ui_step = 0.001;
ui_min = 0.000; ui_max = 1.000;
ui_tooltip = "The X and Y coordinates of the blur focus point, which is used for\nthe Blur type 'Focus Point Targeting Strokes'. 0,0 is the\nupper left corner, and 0.5, 0.5 is at the center of the screen.";
> = float2(0.5, 0.5);
uniform float3 FocusPointBlendColor <
ui_category = "Blur tweaking";
ui_label = "Focus point color";
ui_type= "color";
ui_tooltip = "The color of the focus point in Point focused mode. The closer a\npixel is to the focus point, the more it will become this color.\nIn (red , green, blue)";
> = float3(0.0,0.0,0.0);
uniform float FocusPointBlendFactor <
ui_category = "Blur tweaking";
ui_label = "Focus point color blend factor";
ui_type = "slider";
ui_min = 0.000; ui_max = 1.000;
ui_step = 0.001;
ui_tooltip = "The factor with which the focus point color is blended with the final image";
> = 1.000;
uniform float HighlightGain <
ui_category = "Blur tweaking";
ui_label="Highlight gain";
ui_type = "slider";
ui_min = 0.00; ui_max = 5.00;
ui_tooltip = "The gain for highlights in the strokes plane. The higher the more a highlight gets\nbrighter.";
ui_step = 0.01;
> = 0.500;
#line 185
uniform float2 MouseCoords < source = "mousepoint"; >;
#line 187
texture texDownsampledBackBuffer { Width = 1920; Height = 1080; Format = RGBA16F; };
texture texBlurDestination { Width = 1920; Height = 1080; Format = RGBA16F; };
#line 190
sampler samplerDownsampledBackBuffer { Texture = texDownsampledBackBuffer; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler samplerBlurDestination { Texture = texBlurDestination; };
#line 193
struct VSPIXELINFO
{
float4 vpos : SV_Position;
float2 texCoords : TEXCOORD0;
float2 pixelDelta: TEXCOORD1;
float blurLengthInPixels: TEXCOORD2;
float focusPlane: TEXCOORD3;
float focusRange: TEXCOORD4;
float4 texCoordsScaled: TEXCOORD5;
};
#line 210
float2 CalculatePixelDeltas(float2 texCoords)
{
float2 mouseCoords = MouseCoords *  float2((1.0 / 1920), (1.0 / 1080));
#line 214
return (float2(FocusPoint.x - texCoords.x, FocusPoint.y - texCoords.y)) * length( float2((1.0 / 1920), (1.0 / 1080)));
}
#line 217
float3 AccentuateWhites(float3 fragment)
{
return fragment / (1.5 - clamp(fragment, 0, 1.49));	
}
#line 222
float3 CorrectForWhiteAccentuation(float3 fragment)
{
return (fragment.rgb * 1.5) / (1.0 + fragment.rgb);		
}
#line 227
float3 PostProcessBlurredFragment(float3 fragment, float maxLuma, float3 averageGained, float normalizationFactor)
{
const float3 lumaDotWeight = float3(0.3, 0.59, 0.11);
#line 231
averageGained.rgb = CorrectForWhiteAccentuation(averageGained.rgb);
#line 234
averageGained.rgb *= 1+saturate(maxLuma - dot(fragment, lumaDotWeight));
fragment = (1-normalizationFactor) * fragment + normalizationFactor * averageGained.rgb;
return fragment;
}
#line 245
VSPIXELINFO VS_PixelInfo(in uint id : SV_VertexID)
{
VSPIXELINFO pixelInfo;
#line 249
if (id == 2)
pixelInfo.texCoords.x = 2.0;
else
pixelInfo.texCoords.x = 0.0;
if (id == 1)
pixelInfo.texCoords.y = 2.0;
else
pixelInfo.texCoords.y = 0.0;
pixelInfo.vpos = float4(pixelInfo.texCoords * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
sincos(6.28318530717958 * BlurAngle, pixelInfo.pixelDelta.y, pixelInfo.pixelDelta.x);
pixelInfo.pixelDelta *= length( float2((1.0 / 1920), (1.0 / 1080)));
pixelInfo.blurLengthInPixels = length( float2(1920, 1080)) * BlurLength;
pixelInfo.focusPlane = (FocusPlane * FocusPlaneMaxRange) / 1000.0;
pixelInfo.focusRange = (FocusRange * FocusPlaneMaxRange) / 1000.0;
pixelInfo.texCoordsScaled = float4(pixelInfo.texCoords * ScaleFactor, pixelInfo.texCoords / ScaleFactor);
return pixelInfo;
}
#line 273
void PS_Blur(VSPIXELINFO pixelInfo, out float4 fragment : SV_Target0)
{
const float3 lumaDotWeight = float3(0.3, 0.59, 0.11);
#line 277
float4 average = float4(tex2Dlod(samplerDownsampledBackBuffer, float4(pixelInfo.texCoordsScaled.xy, 0, 0)).rgb, 1.0);
float3 averageGained = AccentuateWhites(average.rgb);
float2 pixelDelta;
if (BlurType == 0)
pixelDelta = pixelInfo.pixelDelta;
else
pixelDelta = CalculatePixelDeltas(pixelInfo.texCoords);
float maxLuma = dot(AccentuateWhites(float4(tex2Dlod(samplerDownsampledBackBuffer, float4(pixelInfo.texCoordsScaled.xy, 0, 0)).rgb, 1.0).rgb).rgb, lumaDotWeight);
for(float tapIndex=0.0;tapIndex<pixelInfo.blurLengthInPixels;tapIndex+=(1/BlurQuality))
{
float2 tapCoords = (pixelInfo.texCoords + (pixelDelta * tapIndex));
float3 tapColor = tex2Dlod(samplerDownsampledBackBuffer, float4(tapCoords * ScaleFactor, 0, 0)).rgb;
float weight;
if (ReShade::GetLinearizedDepth(tapCoords) <= pixelInfo.focusPlane)
weight = 0.0;
else
weight = 1-(tapIndex/ pixelInfo.blurLengthInPixels);
average.rgb+=(tapColor * weight);
average.a+=weight;
float3 gainedTap = AccentuateWhites(tapColor.rgb);
averageGained += gainedTap * weight;
if (weight > 0)
maxLuma = max(maxLuma, saturate(dot(gainedTap, lumaDotWeight)));
}
fragment.rgb = average.rgb / (average.a + (average.a==0));
if (BlurType != 0)
fragment.rgb = lerp(fragment.rgb, lerp(FocusPointBlendColor, fragment.rgb, smoothstep(0, 1, distance(pixelInfo.texCoords, FocusPoint))), FocusPointBlendFactor);
fragment.rgb = PostProcessBlurredFragment(fragment.rgb, saturate(maxLuma), (averageGained / (average.a + (average.a==0))), HighlightGain);
fragment.a = 1.0;
}
#line 309
void PS_Combiner(VSPIXELINFO pixelInfo, out float4 fragment : SV_Target0)
{
const float colorDepth = ReShade::GetLinearizedDepth(pixelInfo.texCoords);
const float4 realColor = tex2Dlod(ReShade::BackBuffer, float4(pixelInfo.texCoords, 0, 0));
if(colorDepth <= pixelInfo.focusPlane || (BlurLength <= 0.0))
{
fragment = realColor;
return;
}
const float rangeEnd = (pixelInfo.focusPlane+pixelInfo.focusRange);
float blendFactor;
if (rangeEnd < colorDepth)
blendFactor = 1.0;
else
blendFactor = smoothstep(0, 1, 1-((rangeEnd-colorDepth) / pixelInfo.focusRange));
fragment.rgb = lerp(realColor.rgb, tex2Dlod(samplerBlurDestination, float4(pixelInfo.texCoords, 0, 0)).rgb, blendFactor);
}
#line 327
void PS_DownSample(VSPIXELINFO pixelInfo, out float4 fragment : SV_Target0)
{
#line 330
const float2 sourceCoords = pixelInfo.texCoordsScaled.zw;
if(max(sourceCoords.x, sourceCoords.y) > 1.0001)
{
#line 334
discard;
}
fragment = tex2D(ReShade::BackBuffer, sourceCoords);
}
#line 345
technique DirectionalDepthBlur
< ui_tooltip = "Directional Depth Blur "
 "v1.0"
"\n===========================================\n\n"
"Directional Depth Blur is a shader for adding far plane directional blur\n"
"based on the depth of each pixel\n\n"
"Directional Depth Blur was written by Frans 'Otis_Inf' Bouma and is part of OtisFX\n"
"https://fransbouma.com | https://github.com/FransBouma/OtisFX"; >
{
pass Downsample { VertexShader = VS_PixelInfo ; PixelShader = PS_DownSample; RenderTarget = texDownsampledBackBuffer; }
pass BlurPass { VertexShader = VS_PixelInfo; PixelShader = PS_Blur; RenderTarget = texBlurDestination; }
pass Combiner { VertexShader = VS_PixelInfo; PixelShader = PS_Combiner; }
}
}
