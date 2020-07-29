#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\CinematicDOF.fx"
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
#line 88 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\CinematicDOF.fx"
#line 90
namespace CinematicDOF
{
#line 104
uniform bool UseAutoFocus <
ui_category = "Focusing";
ui_label = "Use auto-focus";
ui_tooltip = "If enabled it will make the shader focus on the point specified as 'Auto-focus point',\notherwise it will put the focus plane at the depth specified in 'Manual-focus plane'.";
> = true;
uniform bool UseMouseDrivenAutoFocus <
ui_category = "Focusing";
ui_label = "Use mouse-driven auto-focus";
ui_tooltip = "Enables mouse driven auto-focus. If enabled, and 'Use auto-focus' is enabled, the\nauto-focus point is read from the mouse coordinates, otherwise the 'Auto-focus point' is used.";
> = true;
uniform float2 AutoFocusPoint <
ui_category = "Focusing";
ui_label = "Auto-focus point";
ui_type = "slider";
ui_step = 0.001;
ui_min = 0.000; ui_max = 1.000;
ui_tooltip = "The X and Y coordinates of the auto-focus point. 0,0 is the upper left corner,\nand 0.5, 0.5 is at the center of the screen. Only used if 'Use auto focus' is enabled.";
> = float2(0.5, 0.5);
uniform float AutoFocusTransitionSpeed <
ui_category = "Focusing";
ui_label= "Auto-focus transition speed";
ui_type = "slider";
ui_min = 0.001; ui_max = 1.0;
ui_step = 0.01;
ui_tooltip = "The speed the shader will transition between different focus points when using auto-focus.\n0.001 means very slow, 1.0 means instantly. Only used if 'Use auto-focus' is enabled.";
> = 0.2;
uniform float ManualFocusPlane <
ui_category = "Focusing";
ui_label= "Manual-focus plane";
ui_type = "slider";
ui_min = 0.100; ui_max = 150.00;
ui_step = 0.01;
ui_tooltip = "The depth of focal plane related to the camera when 'Use auto-focus' is off.\nOnly used if 'Use auto-focus' is disabled.";
> = 10.00;
uniform float FocalLength <
ui_category = "Focusing";
ui_label = "Focal length (mm)";
ui_type = "slider";
ui_min = 10; ui_max = 300.0;
ui_step = 1.0;
ui_tooltip = "Focal length of the used lens. The longer the focal length, the narrower the\ndepth of field and thus the more is out of focus. For portraits, start with 120 or 150.";
> = 100.00;
uniform float FNumber <
ui_category = "Focusing";
ui_label = "Aperture (f-number)";
ui_type = "slider";
ui_min = 1; ui_max = 22.0;
ui_step = 0.1;
ui_tooltip = "The f-number (also known as f-stop) to use. The higher the number, the wider\nthe depth of field, meaning the more is in-focus and thus the less is out of focus.\nFor portraits, start with 2.8.";
> = 2.8;
#line 155
uniform bool ShowOutOfFocusPlaneOnMouseDown <
ui_category = "Focusing, overlay";
ui_label = "Show out-of-focus plane overlay on mouse down";
ui_tooltip = "Enables the out-of-focus plane overlay when the left mouse button is pressed down,\nwhich helps with fine-tuning the focusing.";
> = true;
uniform float3 OutOfFocusPlaneColor <
ui_category = "Focusing, overlay";
ui_label = "Out-of-focus plane overlay color";
ui_type= "color";
ui_tooltip = "Specifies the color of the out-of-focus planes rendered when the left-mouse button\nis pressed and 'Show out-of-focus plane on mouse down' is enabled. In (red , green, blue)";
> = float3(0.8,0.8,0.8);
uniform float OutOfFocusPlaneColorTransparency <
ui_category = "Focusing, overlay";
ui_label = "Out-of-focus plane transparency";
ui_type = "slider";
ui_min = 0.01; ui_max = 1.0;
ui_tooltip = "Amount of transparency of the out-of-focus planes. 0.0 is transparent, 1.0 is opaque.";
> = 0.7;
uniform float3 FocusPlaneColor <
ui_category = "Focusing, overlay";
ui_label = "Focus plane overlay color";
ui_type= "color";
ui_tooltip = "Specifies the color of the focus plane rendered when the left-mouse button\nis pressed and 'Show out-of-focus plane on mouse down' is enabled. In (red , green, blue)";
> = float3(0.0, 0.0, 1.0);
uniform float4 FocusCrosshairColor<
ui_category = "Focusing, overlay";
ui_label = "Focus crosshair color";
ui_type = "color";
ui_tooltip = "Specifies the color of the crosshair for the auto-focus.\nAuto-focus must be enabled";
> = float4(1.0, 0.0, 1.0, 1.0);
#line 187
uniform float FarPlaneMaxBlur <
ui_category = "Blur tweaking";
ui_label = "Far plane max blur";
ui_type = "slider";
ui_min = 0.000; ui_max = 4.0;
ui_step = 0.01;
ui_tooltip = "The maximum blur a pixel can have when it has its maximum CoC in the far plane. Use this as a tweak\nto adjust the max far plane blur defined by the lens parameters. Don't use this as your primarily\nblur factor, use the lens parameters Focal Length and Aperture for that instead.";
> = 1.0;
uniform float NearPlaneMaxBlur <
ui_category = "Blur tweaking";
ui_label = "Near plane max blur";
ui_type = "slider";
ui_min = 0.000; ui_max = 4.0;
ui_step = 0.01;
ui_tooltip = "The maximum blur a pixel can have when it has its maximum CoC in the near Plane. Use this as a tweak to\nadjust the max near plane blur defined by the lens parameters.  Don't use this as your primarily blur factor,\nuse the lens parameters Focal Length and Aperture for that instead.";
> = 1.0;
uniform float BlurQuality <
ui_category = "Blur tweaking";
ui_label = "Overall blur quality";
ui_type = "slider";
ui_min = 2.0; ui_max = 12.0;
ui_tooltip = "The number of rings to use in the disc-blur algorithm. The more rings the better\nthe blur results, but also the slower it will get.";
ui_step = 1;
> = 5.0;
uniform float BokehBusyFactor <
ui_category = "Blur tweaking";
ui_label="Bokeh busy factor";
ui_type = "slider";
ui_min = 0.00; ui_max = 1.00;
ui_tooltip = "The 'bokeh busy factor' for the blur: 0 means no busyness boost, 1.0 means extra busyness boost.";
ui_step = 0.01;
> = 0.500;
uniform float PostBlurSmoothing <
ui_category = "Blur tweaking";
ui_label = "Post-blur smoothing factor";
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
ui_tooltip = "The amount of post-blur smoothing blur to apply. 0.0 means no smoothing blur is applied.";
ui_step = 0.01;
> = 0.0;
#line 228
uniform float HighlightAnamorphicFactor <
ui_category = "Highlight tweaking, anamorphism";
ui_label="Anamorphic factor";
ui_type = "slider";
ui_min = 0.01; ui_max = 1.00;
ui_tooltip = "The anamorphic factor of the bokeh highlights. A value of 1.0 (default) gives perfect\ncircles, a factor of e.g. 0.1 gives thin ellipses";
ui_step = 0.01;
> = 1.0;
uniform float HighlightAnamorphicSpreadFactor <
ui_category = "Highlight tweaking, anamorphism";
ui_label="Anamorphic spread factor";
ui_type = "slider";
ui_min = 0.00; ui_max = 1.00;
ui_tooltip = "The spread factor for the anamorphic factor. 0.0 means it's relative to the distance\nto the center of the screen, 1.0 means the factor is applied everywhere evenly,\nno matter how far the pixel is to the center of the screen.";
ui_step = 0.01;
> = 0.0;
uniform float HighlightAnamorphicAlignmentFactor <
ui_category = "Highlight tweaking, anamorphism";
ui_label="Anamorphic alignment factor";
ui_type = "slider";
ui_min = 0.00; ui_max = 1.00;
ui_tooltip = "The alignment factor for the anamorphic deformation. 0.0 means you get evenly rotated\nellipses around the center of the screen, 1.0 means all bokeh highlights are\naligned vertically.";
ui_step = 0.01;
> = 0.0;
uniform float HighlightGainFarPlane <
ui_category = "Highlight tweaking, far plane";
ui_label="Highlight gain";
ui_type = "slider";
ui_min = 0.00; ui_max = 20.00;
ui_tooltip = "The gain for highlights in the far plane. The higher the more a highlight gets\nbrighter. Tweak this in tandem with the Highlight threshold. Best results are\nachieved with bright spots in dark(er) backgrounds.";
ui_step = 0.01;
> = 0.500;
uniform float HighlightThresholdFarPlane <
ui_category = "Highlight tweaking, far plane";
ui_label="Highlight threshold";
ui_type = "slider";
ui_min = 0.00; ui_max = 1.00;
ui_tooltip = "The threshold for the source pixels. Pixels with a luminosity above this threshold\nwill be highlighted. Raise this value to only keep the highlights you want.\nWhen highlight type is Twinkle circlets, set the threshold at 0.5 or higher\nfor blur without highlights.";
ui_step = 0.01;
> = 0.0;
uniform float HighlightGainNearPlane <
ui_category = "Highlight tweaking, near plane";
ui_label="Highlight gain";
ui_type = "slider";
ui_min = 0.00; ui_max = 20.00;
ui_tooltip = "The gain for highlights in the near plane. The higher the more a highlight gets\nbrighter. Tweak this in tandem with the Highlight threshold. Best results are\nachieved with bright spots in dark(er) foregrounds.";
ui_step = 0.001;
> = 0.200;
uniform float HighlightThresholdNearPlane <
ui_category = "Highlight tweaking, near plane";
ui_label="Highlight threshold";
ui_type = "slider";
ui_min = 0.00; ui_max = 1.00;
ui_tooltip = "The threshold for the source pixels. Pixels with a luminosity above this threshold\nwill be highlighted. Raise this value to only keep the highlights you want.\nWhen highlight type is Twinkle circlets, set the threshold at 0.5 or higher\nfor blur without highlights.";
ui_step = 0.01;
> = 0.0;
#line 286
uniform bool ShowCoCValues <
ui_category = "Advanced";
ui_label = "Show CoC values and focus plane";
ui_tooltip = "Shows blur disc size (CoC) as grey (far plane) and red (near plane) and focus plane as blue";
> = false;
#line 351
texture texCDCurrentFocus		{ Width = 1; Height = 1; Format = R16F; };		
texture texCDPreviousFocus		{ Width = 1; Height = 1; Format = R16F; };		
texture texCDCoC				{ Width = 2560; Height = 1377; Format = R16F; };
texture texCDCoCTileTmp			{ Width = 2560/(			1			*		1); Height = 1377/(			1			*		1); Format = R16F; };	
texture texCDCoCTile			{ Width = 2560/(			1			*		1); Height = 1377/(			1			*		1); Format = R16F; };	
texture texCDCoCTileNeighbor	{ Width = 2560/(			1			*		1); Height = 1377/(			1			*		1); Format = R16F; };	
texture texCDCoCTmp1			{ Width = 2560/2; Height = 1377/2; Format = R16F; };	
texture texCDCoCBlurred			{ Width = 2560/2; Height = 1377/2; Format = RG16F; };	
texture texCDBuffer1 			{ Width = 2560/2; Height = 1377/2; Format = RGBA8; };
texture texCDBuffer2 			{ Width = 2560/2; Height = 1377/2; Format = RGBA8; };
texture texCDBuffer3 			{ Width = 2560/2; Height = 1377/2; Format = RGBA8; }; 
texture texCDBuffer4 			{ Width = 2560; Height = 1377; Format = RGBA8; }; 	
texture texCDBuffer5 			{ Width = 2560; Height = 1377; Format = RGBA8; }; 	
#line 365
sampler	SamplerCDCurrentFocus		{ Texture = texCDCurrentFocus; };
sampler SamplerCDPreviousFocus		{ Texture = texCDPreviousFocus; };
sampler SamplerCDBuffer1 			{ Texture = texCDBuffer1; };
sampler SamplerCDBuffer2 			{ Texture = texCDBuffer2; };
sampler SamplerCDBuffer3 			{ Texture = texCDBuffer3; };
sampler SamplerCDBuffer4 			{ Texture = texCDBuffer4; };
sampler SamplerCDBuffer5 			{ Texture = texCDBuffer5; };
sampler SamplerCDCoC				{ Texture = texCDCoC; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT;};
sampler SamplerCDCoCTmp1			{ Texture = texCDCoCTmp1; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT;};
sampler SamplerCDCoCBlurred			{ Texture = texCDCoCBlurred; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT;};
sampler SamplerCDCoCTileTmp			{ Texture = texCDCoCTileTmp; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT;};
sampler SamplerCDCoCTile			{ Texture = texCDCoCTile; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT;};
sampler SamplerCDCoCTileNeighbor	{ Texture = texCDCoCTileNeighbor; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT;};
#line 379
uniform float2 MouseCoords < source = "mousepoint"; >;
uniform bool LeftMouseDown < source = "mousebutton"; keycode = 0; toggle = false; >;
#line 383
struct VSFOCUSINFO
{
float4 vpos : SV_Position;
float2 texcoord : TEXCOORD0;
float focusDepth : TEXCOORD1;
float focusDepthInM : TEXCOORD2;
float focusDepthInMM : TEXCOORD3;
float pixelSizeLength : TEXCOORD4;
float nearPlaneInMM : TEXCOORD5;
float farPlaneInMM : TEXCOORD6;
};
#line 395
struct VSDISCBLURINFO
{
float4 vpos : SV_Position;
float2 texcoord : TEXCOORD0;
float numberOfRings : TEXCOORD1;
float farPlaneMaxBlurInPixels : TEXCOORD2;
float nearPlaneMaxBlurInPixels : TEXCOORD3;
float cocFactorPerPixel : TEXCOORD4;
};
#line 411
float3 AccentuateWhites(float3 fragment)
{
return fragment / (1.5 - clamp(fragment, 0, 1.49));	
}
#line 416
float3 CorrectForWhiteAccentuation(float3 fragment)
{
return (fragment.rgb * 1.5) / (1.0 + fragment.rgb);		
}
#line 423
float4 CalculateAnamorphicFactor(float2 pixelVector)
{
const float normalizedFactor = lerp(1, HighlightAnamorphicFactor, lerp(length(pixelVector * 2), 1, HighlightAnamorphicSpreadFactor));
return float4(0, 1 + (1-normalizedFactor), normalizedFactor, 0);
}
#line 432
float2x2 CalculateAnamorphicRotationMatrix(float2 texcoord)
{
float2 pixelVector = normalize(texcoord - 0.5);
const float limiter = (1-HighlightAnamorphicAlignmentFactor)/2;
pixelVector.y = clamp(pixelVector.y, -limiter, limiter);
const float2 refVector = normalize(float2(-0.5, 0));
float2 sincosFactor = float2(0,0);
#line 440
sincos(atan2(pixelVector.y, pixelVector.x) - atan2(refVector.y, refVector.x), sincosFactor.x, sincosFactor.y);
return float2x2(sincosFactor.y, sincosFactor.x, -sincosFactor.x, sincosFactor.y);
}
#line 444
float2 MorphPointOffsetWithAnamorphicDeltas(float2 pointOffset, float4 anamorphicFactors, float2x2 anamorphicRotationMatrix)
{
pointOffset.x = pointOffset.x * anamorphicFactors.x + pointOffset.x*anamorphicFactors.z;
pointOffset.y = pointOffset.y * anamorphicFactors.y + pointOffset.y*anamorphicFactors.w;
return mul(pointOffset, anamorphicRotationMatrix);
}
#line 453
float PerformTileGatherHorizontal(sampler source, float2 texcoord)
{
const float tileSize = 			1			 * (float(2560) / float(	1920.0f));
float minCoC = 10;
float coc;
float2 coordOffset = float2( float2((1.0 / 2560), (1.0 / 1377)).x, 0);
for(float i = 0; i <= tileSize; ++i)
{
coc = tex2Dlod(source, float4(texcoord + coordOffset, 0, 0)).r;
minCoC = min(minCoC, coc);
coc = tex2Dlod(source, float4(texcoord - coordOffset, 0, 0)).r;
minCoC = min(minCoC, coc);
coordOffset.x+= float2((1.0 / 2560), (1.0 / 1377)).x;
}
return minCoC;
}
#line 472
float PerformTileGatherVertical(sampler source, float2 texcoord)
{
float tileSize = 			1			 * (float( float2(2560, 1377).y) / float(	1200.0f));
float minCoC = 10;
float coc;
float2 coordOffset = float2(0,  float2((1.0 / 2560), (1.0 / 1377)).y);
for(float i = 0; i <= tileSize; ++i)
{
coc = tex2Dlod(source, float4(texcoord + coordOffset, 0, 0)).r;
minCoC = min(minCoC, coc);
coc = tex2Dlod(source, float4(texcoord - coordOffset, 0, 0)).r;
minCoC = min(minCoC, coc);
coordOffset.y+= float2((1.0 / 2560), (1.0 / 1377)).y;
}
return minCoC;
}
#line 490
float PerformNeighborTileGather(sampler source, float2 texcoord)
{
float minCoC = 10;
const float tileSizeX = 			1			 * (float( float2(2560, 1377).x) / float(	1920.0f));
const float tileSizeY = 			1			 * (float( float2(2560, 1377).y) / float(	1200.0f));
#line 497
const float2 baseCoordOffset = float2( float2((1.0 / 2560), (1.0 / 1377)).x * (tileSizeX*2+1),  float2((1.0 / 2560), (1.0 / 1377)).x * (tileSizeY*2+1));
for(float i=-1;i<2;i++)
{
for(float j=-1;j<2;j++)
{
const float2 coordOffset = float2(baseCoordOffset.x * i, baseCoordOffset.y * j);
const float coc = tex2Dlod(source, float4(texcoord + coordOffset, 0, 0)).r;
minCoC = min(minCoC, coc);
}
}
return minCoC;
}
#line 514
float4 GetDebugFragment(float radius, bool showInFocus)
{
float4 toReturn = (radius/2 <= length( float2((1.0 / 2560), (1.0 / 1377)))) && showInFocus ? float4(0.0, 0.0, 1.0, 1.0) : float4(radius, radius, radius, 1.0);
if(radius < 0)
{
toReturn = float4(-radius, 0, 0, 1);
}
return toReturn;
}
#line 527
float CalculateBlurDiscSize(VSFOCUSINFO focusInfo)
{
const float pixelDepth = ReShade::GetLinearizedDepth(focusInfo.texcoord);
const float pixelDepthInM = pixelDepth * 1000.0;			
#line 541
const float cocInMM = (((FocalLength*FocalLength) / FNumber) / ((focusInfo.focusDepthInM/1000.0) -FocalLength)) *
(abs(pixelDepthInM - focusInfo.focusDepthInM) / (pixelDepthInM + (pixelDepthInM==0)));
const float toReturn = clamp(saturate(abs(cocInMM) * 			0.024		), 0, 1); 
return (pixelDepth < focusInfo.focusDepth) ? -toReturn : toReturn;
}
#line 548
float CalculateSampleWeight(float sampleRadiusInCoC, float ringDistanceInCoC)
{
return  saturate(sampleRadiusInCoC - ringDistanceInCoC + 0.5);
}
#line 554
float3 PostProcessBlurredFragment(float3 fragment, float maxLuma, float3 averageGained, float normalizationFactor)
{
const float3 lumaDotWeight = float3(0.3, 0.59, 0.11);
#line 558
float newFragmentLuma = dot(fragment, lumaDotWeight);
averageGained.rgb = CorrectForWhiteAccentuation(averageGained.rgb);
#line 562
averageGained.rgb *= 1+saturate(maxLuma-newFragmentLuma);
fragment = (1-normalizationFactor) * fragment + normalizationFactor * averageGained.rgb;
return fragment;
}
#line 575
float4 PerformNearPlaneDiscBlur(VSDISCBLURINFO blurInfo, sampler2D source)
{
const float3 lumaDotWeight = float3(0.3, 0.59, 0.11);
float4 fragment = tex2Dlod(source, float4(blurInfo.texcoord, 0, 0));
#line 580
const float2 fragmentRadii = tex2Dlod(SamplerCDCoCBlurred, float4(blurInfo.texcoord, 0, 0)).rg;
const float fragmentRadiusToUse = fragmentRadii.r;
#line 583
if(fragmentRadii.r <=0)
{
#line 587
fragment.a = 0;
return fragment;
}
#line 592
const float numberOfRings = max(blurInfo.numberOfRings, 1) + 1;
const float pointsFirstRing = 7;
#line 595
const float bokehBusyFactorToUse = saturate(1.0-BokehBusyFactor);		
float4 average = float4(fragment.rgb * fragmentRadiusToUse * bokehBusyFactorToUse, bokehBusyFactorToUse);
float3 averageGained = AccentuateWhites(average.rgb);
float2 pointOffset = float2(0,0);
const float nearPlaneBlurInPixels = blurInfo.nearPlaneMaxBlurInPixels * fragmentRadiusToUse;
const float2 ringRadiusDeltaCoords =  float2((1.0 / 2560), (1.0 / 1377)) * (nearPlaneBlurInPixels / (numberOfRings-1));
float pointsOnRing = pointsFirstRing;
float2 currentRingRadiusCoords = ringRadiusDeltaCoords;
float maxLuma = dot(averageGained, lumaDotWeight) * fragmentRadii.g * (1-HighlightThresholdNearPlane);
const float4 anamorphicFactors = CalculateAnamorphicFactor(blurInfo.texcoord - 0.5); 
const float2x2 anamorphicRotationMatrix = CalculateAnamorphicRotationMatrix(blurInfo.texcoord);
for(float ringIndex = 0; ringIndex < numberOfRings; ringIndex++)
{
const float anglePerPoint = 6.28318530717958 / pointsOnRing;
float angle = anglePerPoint;
#line 611
const float weight = lerp(ringIndex/numberOfRings, 1, smoothstep(0, 1, bokehBusyFactorToUse));
for(float pointNumber = 0; pointNumber < pointsOnRing; pointNumber++)
{
sincos(angle, pointOffset.y, pointOffset.x);
#line 617
pointOffset = MorphPointOffsetWithAnamorphicDeltas(pointOffset, anamorphicFactors, anamorphicRotationMatrix);
const float4 tapCoords = float4(blurInfo.texcoord + (pointOffset * currentRingRadiusCoords), 0, 0);
const float4 tap = tex2Dlod(source, tapCoords);
#line 621
const float blurredSampleRadius = tex2Dlod(SamplerCDCoCBlurred, tapCoords).r;
average.rgb += tap.rgb * weight;
average.w += weight;
const float3 gainedTap = AccentuateWhites(tap.rgb);
averageGained += gainedTap * weight;
const float lumaSample = dot(gainedTap, lumaDotWeight) * saturate(blurredSampleRadius) * (1-HighlightThresholdNearPlane);
maxLuma = max(maxLuma, lumaSample);
angle+=anglePerPoint;
}
pointsOnRing+=pointsFirstRing;
currentRingRadiusCoords += ringRadiusDeltaCoords;
}
#line 634
average.rgb/=(average.w + (average.w ==0));
const float alpha = saturate((min(2.5, NearPlaneMaxBlur) + 0.4) * (fragmentRadiusToUse > 0.1 ? (fragmentRadii.g <=0 ? 2 : 1) * fragmentRadiusToUse : max(fragmentRadiusToUse, -fragmentRadii.g)));
fragment.rgb = average.rgb;
fragment.a = alpha;
#line 644
fragment.rgb = PostProcessBlurredFragment(fragment.rgb, maxLuma, (averageGained / (average.w + (average.w==0))), HighlightGainNearPlane);
#line 651
return fragment;
}
#line 660
float4 PerformDiscBlur(VSDISCBLURINFO blurInfo, sampler2D source)
{
const float3 lumaDotWeight = float3(0.3, 0.59, 0.11);
const float pointsFirstRing = 7; 	
float4 fragment = tex2Dlod(source, float4(blurInfo.texcoord, 0, 0));
const float fragmentRadius = tex2Dlod(SamplerCDCoC, float4(blurInfo.texcoord, 0, 0)).r;
#line 667
if(fragmentRadius < 0)
{
#line 670
return fragment;
}
#line 673
const float bokehBusyFactorToUse = saturate(1.0-BokehBusyFactor)-0.2;		
float4 average = float4(fragment.rgb * fragmentRadius * bokehBusyFactorToUse, bokehBusyFactorToUse);
float3 averageGained = AccentuateWhites(average.rgb);
float2 pointOffset = float2(0,0);
const float2 ringRadiusDeltaCoords =  ( float2((1.0 / 2560), (1.0 / 1377)) * blurInfo.farPlaneMaxBlurInPixels * fragmentRadius) / blurInfo.numberOfRings;
float2 currentRingRadiusCoords = ringRadiusDeltaCoords;
const float cocPerRing = (fragmentRadius * FarPlaneMaxBlur) / blurInfo.numberOfRings;
float pointsOnRing = pointsFirstRing;
float maxLuma = dot(averageGained.rgb, lumaDotWeight) * fragmentRadius * (1-HighlightThresholdFarPlane);
const float4 anamorphicFactors = CalculateAnamorphicFactor(blurInfo.texcoord - 0.5); 
const float2x2 anamorphicRotationMatrix = CalculateAnamorphicRotationMatrix(blurInfo.texcoord);
for(float ringIndex = 0; ringIndex < blurInfo.numberOfRings; ringIndex++)
{
const float anglePerPoint = 6.28318530717958 / pointsOnRing;
float angle = anglePerPoint;
const float ringWeight = lerp(ringIndex/blurInfo.numberOfRings, 1, bokehBusyFactorToUse);
const float ringDistance = cocPerRing * ringIndex;
for(float pointNumber = 0; pointNumber < pointsOnRing; pointNumber++)
{
sincos(angle, pointOffset.y, pointOffset.x);
#line 695
pointOffset = MorphPointOffsetWithAnamorphicDeltas(pointOffset, anamorphicFactors, anamorphicRotationMatrix);
const float4 tapCoords = float4(blurInfo.texcoord + (pointOffset * currentRingRadiusCoords), 0, 0);
const float sampleRadius = tex2Dlod(SamplerCDCoC, tapCoords).r;
const float4 tap = tex2Dlod(source, tapCoords);
const float weight = (sampleRadius >=0) * ringWeight * CalculateSampleWeight(sampleRadius * FarPlaneMaxBlur, ringDistance);
average.rgb += tap.rgb * weight;
average.w += weight;
const float3 gainedTap = AccentuateWhites(tap.rgb);
averageGained += gainedTap * weight;
const float lumaSample = dot(gainedTap, lumaDotWeight) * sampleRadius * (1-HighlightThresholdFarPlane);
maxLuma = max(maxLuma, lumaSample);
angle+=anglePerPoint;
}
pointsOnRing+=pointsFirstRing;
currentRingRadiusCoords += ringRadiusDeltaCoords;
}
fragment.rgb = average.rgb / (average.w + (average.w==0));
fragment.rgb = PostProcessBlurredFragment(fragment.rgb, maxLuma, (averageGained / (average.w + (average.w==0))), HighlightGainFarPlane);
return fragment;
}
#line 722
float4 PerformPreDiscBlur(VSDISCBLURINFO blurInfo, sampler2D source)
{
const float radiusFactor = 1.0/max(blurInfo.numberOfRings, 1);
const float pointsFirstRing = max(blurInfo.numberOfRings-3, 2); 	
float4 fragment = tex2Dlod(source, float4(blurInfo.texcoord, 0, 0));
const float signedFragmentRadius = tex2Dlod(SamplerCDCoC, float4(blurInfo.texcoord, 0, 0)).x * radiusFactor;
const float absoluteFragmentRadius = abs(signedFragmentRadius);
bool isNearPlaneFragment = signedFragmentRadius < 0;
const float blurFactorToUse = isNearPlaneFragment ? NearPlaneMaxBlur : FarPlaneMaxBlur;
#line 732
const float numberOfRings = max(blurInfo.numberOfRings-2, 1);
float4 average = absoluteFragmentRadius == 0 ? fragment : float4(fragment.rgb * absoluteFragmentRadius, absoluteFragmentRadius);
float2 pointOffset = float2(0,0);
#line 736
const float2 ringRadiusDeltaCoords =  float2((1.0 / 2560), (1.0 / 1377))
* ((isNearPlaneFragment ? blurInfo.nearPlaneMaxBlurInPixels : blurInfo.farPlaneMaxBlurInPixels) *  absoluteFragmentRadius)
* rcp((numberOfRings-1) + (numberOfRings==1));
float pointsOnRing = pointsFirstRing;
float2 currentRingRadiusCoords = ringRadiusDeltaCoords;
const float cocPerRing = (signedFragmentRadius * blurFactorToUse) / numberOfRings;
for(float ringIndex = 0; ringIndex < numberOfRings; ringIndex++)
{
const float anglePerPoint = 6.28318530717958 / pointsOnRing;
float angle = anglePerPoint;
const float ringDistance = cocPerRing * ringIndex;
for(float pointNumber = 0; pointNumber < pointsOnRing; pointNumber++)
{
sincos(angle, pointOffset.y, pointOffset.x);
const float4 tapCoords = float4(blurInfo.texcoord + (pointOffset * currentRingRadiusCoords), 0, 0);
const float signedSampleRadius = tex2Dlod(SamplerCDCoC, tapCoords).x * radiusFactor;
const float absoluteSampleRadius = abs(signedSampleRadius);
const float isSamePlaneAsFragment = ((signedSampleRadius > 0 && !isNearPlaneFragment) || (signedSampleRadius <= 0 && isNearPlaneFragment));
const float weight = CalculateSampleWeight(absoluteSampleRadius * blurFactorToUse, ringDistance) * isSamePlaneAsFragment *
(absoluteFragmentRadius - absoluteSampleRadius < 0.001);
average.rgb += (tex2Dlod(source, tapCoords).rgb) * weight;
average.w += weight;
angle+=anglePerPoint;
}
pointsOnRing+=pointsFirstRing;
currentRingRadiusCoords += ringRadiusDeltaCoords;
}
fragment.rgb = average.rgb/(average.w + (average.w==0));
#line 765
fragment.a = dot(fragment.rgb, float3(0.3, 0.59, 0.11));
return fragment;
}
#line 777
float GetBlurDiscRadiusFromSource(sampler2D source, float2 texcoord, bool flattenToZero)
{
const float coc = tex2Dlod(source, float4(texcoord, 0, 0)).r;
#line 782
return (flattenToZero && coc >= 0) ? 0 : abs(coc);
}
#line 794
float PerformSingleValueGaussianBlur(sampler2D source, float2 texcoord, float2 offsetWeight, bool flattenToZero)
{
const float offset[18] = { 0.0, 1.4953705027, 3.4891992113, 5.4830312105, 7.4768683759, 9.4707125766, 11.4645656736, 13.4584295168, 15.4523059431, 17.4461967743, 19.4661974725, 21.4627427973, 23.4592916956, 25.455844494, 27.4524015179, 29.4489630909, 31.445529535, 33.4421011704 };
float weight[18] = { 0.033245, 0.0659162217, 0.0636705814, 0.0598194658, 0.0546642566, 0.0485871646, 0.0420045997, 0.0353207015, 0.0288880982, 0.0229808311, 0.0177815511, 0.013382297, 0.0097960001, 0.0069746748, 0.0048301008, 0.0032534598, 0.0021315311, 0.0013582974 };
#line 799
float coc = GetBlurDiscRadiusFromSource(source, texcoord, flattenToZero);
coc *= weight[0];
#line 802
const float2 factorToUse = offsetWeight * NearPlaneMaxBlur * 0.8;
for(int i = 1; i < 18; ++i)
{
const float2 coordOffset = factorToUse * offset[i];
const float weightSample = weight[i];
coc += GetBlurDiscRadiusFromSource(source, texcoord + coordOffset, flattenToZero) * weightSample;
coc += GetBlurDiscRadiusFromSource(source, texcoord - coordOffset, flattenToZero) * weightSample;
}
#line 811
return saturate(coc);
}
#line 820
float4 PerformFullFragmentGaussianBlur(sampler2D source, float2 texcoord, float2 offsetWeight)
{
const float offset[6] = { 0.0, 1.4584295168, 3.40398480678, 5.3518057801, 7.302940716, 9.2581597095 };
const float weight[6] = { 0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922, 0.0019913644 };
const float3 lumaDotWeight = float3(0.3, 0.59, 0.11);
#line 826
const float coc = tex2Dlod(SamplerCDCoC, float4(texcoord, 0, 0)).r;
float4 fragment = tex2Dlod(source, float4(texcoord, 0, 0));
const float fragmentLuma = dot(fragment.rgb, lumaDotWeight);
const float4 originalFragment = fragment;
const float absoluteCoC = abs(coc);
const float lengthPixelSize = length( float2((1.0 / 2560), (1.0 / 1377)));
if(absoluteCoC < 0.2 || PostBlurSmoothing < 0.01 || fragmentLuma < 0.3)
{
#line 835
return fragment;
}
fragment.rgb *= weight[0];
const float2 factorToUse = offsetWeight * PostBlurSmoothing;
for(int i = 1; i < 6; ++i)
{
const float2 coordOffset = factorToUse * offset[i];
const float weightSample = weight[i];
float sampleCoC = tex2Dlod(SamplerCDCoC, float4(texcoord + coordOffset, 0, 0)).r;
float maskFactor = abs(sampleCoC) < 0.2;		
fragment.rgb += (originalFragment.rgb * maskFactor * weightSample) +
(tex2Dlod(source, float4(texcoord + coordOffset, 0, 0)).rgb * (1-maskFactor) * weightSample);
sampleCoC = tex2Dlod(SamplerCDCoC, float4(texcoord - coordOffset, 0, 0)).r;
maskFactor = abs(sampleCoC) < 0.2;
fragment.rgb += (originalFragment.rgb * maskFactor * weightSample) +
(tex2Dlod(source, float4(texcoord - coordOffset, 0, 0)).rgb * (1-maskFactor) * weightSample);
}
return saturate(fragment);
}
#line 857
void FillFocusInfoData(inout VSFOCUSINFO toFill)
{
#line 864
toFill.focusDepth = tex2Dlod(SamplerCDCurrentFocus, float4(0, 0, 0, 0)).r;
toFill.focusDepthInM = toFill.focusDepth * 1000.0; 		
toFill.focusDepthInMM = toFill.focusDepthInM * 1000.0; 	
toFill.pixelSizeLength = length( float2((1.0 / 2560), (1.0 / 1377)));
#line 870
const float hyperFocal = (FocalLength * FocalLength) / (FNumber * 			0.024		);
const float hyperFocalFocusDepthFocus = (hyperFocal * toFill.focusDepthInMM);
toFill.nearPlaneInMM = hyperFocalFocusDepthFocus / (hyperFocal + (toFill.focusDepthInMM - FocalLength));	
toFill.farPlaneInMM = hyperFocalFocusDepthFocus / (hyperFocal - (toFill.focusDepthInMM - FocalLength));		
}
#line 884
VSFOCUSINFO VS_Focus(in uint id : SV_VertexID)
{
VSFOCUSINFO focusInfo;
#line 888
focusInfo.texcoord.x = (id == 2) ? 2.0 : 0.0;
focusInfo.texcoord.y = (id == 1) ? 2.0 : 0.0;
focusInfo.vpos = float4(focusInfo.texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
#line 901
FillFocusInfoData(focusInfo);
#line 903
return focusInfo;
}
#line 907
VSDISCBLURINFO VS_DiscBlur(in uint id : SV_VertexID)
{
VSDISCBLURINFO blurInfo;
#line 911
blurInfo.texcoord.x = (id == 2) ? 2.0 : 0.0;
blurInfo.texcoord.y = (id == 1) ? 2.0 : 0.0;
blurInfo.vpos = float4(blurInfo.texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
#line 915
blurInfo.numberOfRings = round(BlurQuality);
float pixelSizeLength = length( float2((1.0 / 2560), (1.0 / 1377)));
blurInfo.farPlaneMaxBlurInPixels = (FarPlaneMaxBlur / 100.0) / pixelSizeLength;
blurInfo.nearPlaneMaxBlurInPixels = (NearPlaneMaxBlur / 100.0) / pixelSizeLength;
blurInfo.cocFactorPerPixel = length( float2((1.0 / 2560), (1.0 / 1377))) * blurInfo.farPlaneMaxBlurInPixels;	
return blurInfo;
}
#line 930
void PS_DetermineCurrentFocus(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
{
const float2 autoFocusPointToUse = UseMouseDrivenAutoFocus ? MouseCoords *  float2((1.0 / 2560), (1.0 / 1377)) : AutoFocusPoint;
fragment = UseAutoFocus ? lerp(tex2D(SamplerCDPreviousFocus, float2(0, 0)).r, ReShade::GetLinearizedDepth(autoFocusPointToUse), AutoFocusTransitionSpeed)
: (ManualFocusPlane / 1000);
}
#line 938
void PS_CopyCurrentFocus(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
{
fragment = tex2D(SamplerCDCurrentFocus, float2(0, 0)).r;
}
#line 944
void PS_CalculateCoCValues(VSFOCUSINFO focusInfo, out float fragment : SV_Target0)
{
#line 949
fragment = CalculateBlurDiscSize(focusInfo);
}
#line 954
void PS_PreBlur(VSDISCBLURINFO blurInfo, out float4 fragment : SV_Target0)
{
fragment = PerformPreDiscBlur(blurInfo, ReShade::BackBuffer);
}
#line 960
void PS_BokehBlur(VSDISCBLURINFO blurInfo, out float4 fragment : SV_Target0)
{
fragment = PerformDiscBlur(blurInfo, SamplerCDBuffer1);
}
#line 967
void PS_NearBokehBlur(VSDISCBLURINFO blurInfo, out float4 fragment : SV_Target0)
{
fragment = PerformNearPlaneDiscBlur(blurInfo, SamplerCDBuffer2);
}
#line 973
void PS_CoCTile1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
{
fragment = PerformTileGatherHorizontal(SamplerCDCoC, texcoord);
}
#line 979
void PS_CoCTile2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
{
fragment = PerformTileGatherVertical(SamplerCDCoCTileTmp, texcoord);
}
#line 985
void PS_CoCTileNeighbor(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
{
fragment = PerformNeighborTileGather(SamplerCDCoCTile, texcoord);
}
#line 991
void PS_CoCGaussian1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
{
#line 994
fragment = PerformSingleValueGaussianBlur(SamplerCDCoCTileNeighbor, texcoord,
float2( float2((1.0 / 2560), (1.0 / 1377)).x * ( float2(2560, 1377).x/	1920.0f), 0.0), true);
}
#line 999
void PS_CoCGaussian2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float2 fragment : SV_Target0)
{
#line 1002
fragment = float2(PerformSingleValueGaussianBlur(SamplerCDCoCTmp1, texcoord,
float2(0.0,  float2((1.0 / 2560), (1.0 / 1377)).y * ( float2(2560, 1377).y/	1200.0f)), false),
tex2D(SamplerCDCoCTileNeighbor, texcoord).x);
}
#line 1008
void PS_Combiner(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 fragment : SV_Target0)
{
#line 1011
const float4 originalFragment = tex2D(ReShade::BackBuffer, texcoord);
const float4 farFragment = tex2D(SamplerCDBuffer3, texcoord);
const float4 nearFragment = tex2D(SamplerCDBuffer1, texcoord);
#line 1015
const float realCoC = tex2D(SamplerCDCoC, texcoord).r * clamp(0, 1, FarPlaneMaxBlur);
#line 1018
const float blendFactor = (realCoC > 0.1) ? 1 : smoothstep(0, 1, (realCoC / 0.1));
fragment = lerp(originalFragment, farFragment, blendFactor);
fragment.rgb = lerp(fragment.rgb, nearFragment.rgb, nearFragment.a * (NearPlaneMaxBlur != 0));
fragment.a = 1.0;
}
#line 1027
void PS_TentFilter(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 fragment : SV_Target0)
{
const float4 coord =  float2((1.0 / 2560), (1.0 / 1377)).xyxy * float4(1, 1, -1, 0);
float4 average;
average = tex2D(SamplerCDBuffer2, texcoord - coord.xy);
average += tex2D(SamplerCDBuffer2, texcoord - coord.wy) * 2;
average += tex2D(SamplerCDBuffer2, texcoord - coord.zy);
average += tex2D(SamplerCDBuffer2, texcoord + coord.zw) * 2;
average += tex2D(SamplerCDBuffer2, texcoord) * 4;
average += tex2D(SamplerCDBuffer2, texcoord + coord.xw) * 2;
average += tex2D(SamplerCDBuffer2, texcoord + coord.zy);
average += tex2D(SamplerCDBuffer2, texcoord + coord.wy) * 2;
average += tex2D(SamplerCDBuffer2, texcoord + coord.xy);
fragment = average / 16;
}
#line 1044
void PS_PostSmoothing1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 fragment : SV_Target0)
{
fragment = PerformFullFragmentGaussianBlur(SamplerCDBuffer4, texcoord, float2( float2((1.0 / 2560), (1.0 / 1377)).x, 0.0));
}
#line 1053
void PS_PostSmoothing2AndFocusing(in VSFOCUSINFO focusInfo, out float4 fragment : SV_Target0)
{
if(ShowCoCValues)
{
fragment = GetDebugFragment(tex2D(SamplerCDCoC, focusInfo.texcoord).r, true);
return;
}
#line 1082
fragment = PerformFullFragmentGaussianBlur(SamplerCDBuffer5, focusInfo.texcoord, float2(0.0,  float2((1.0 / 2560), (1.0 / 1377)).y));
const float4 originalFragment = tex2D(SamplerCDBuffer4, focusInfo.texcoord);
const float coc = abs(tex2Dlod(SamplerCDCoC, float4(focusInfo.texcoord, 0, 0)).r);
fragment.rgb = lerp(originalFragment.rgb, fragment.rgb, saturate(coc < length( float2((1.0 / 2560), (1.0 / 1377))) ? 0 : 4 * coc));
fragment.w = 1.0;
#line 1091
if(ShowOutOfFocusPlaneOnMouseDown && LeftMouseDown)
{
const float depthPixelInMM = ReShade::GetLinearizedDepth(focusInfo.texcoord) * 1000.0 * 1000.0;
float4 colorToBlend = fragment;
if(depthPixelInMM < focusInfo.nearPlaneInMM || (focusInfo.farPlaneInMM > 0 && depthPixelInMM > focusInfo.farPlaneInMM))
{
colorToBlend = float4(OutOfFocusPlaneColor, 1.0);
}
else
{
if(abs(coc) < focusInfo.pixelSizeLength)
{
colorToBlend = float4(FocusPlaneColor, 1.0);
}
}
fragment = lerp(fragment, colorToBlend, OutOfFocusPlaneColorTransparency);
if(UseAutoFocus)
{
const float2 focusPointCoords = UseMouseDrivenAutoFocus ? MouseCoords *  float2((1.0 / 2560), (1.0 / 1377)) : AutoFocusPoint;
fragment = lerp(fragment, FocusCrosshairColor, FocusCrosshairColor.w * saturate(exp(-2560 * length(focusInfo.texcoord - float2(focusPointCoords.x, focusInfo.texcoord.y)))));
fragment = lerp(fragment, FocusCrosshairColor, FocusCrosshairColor.w * saturate(exp(-1377 * length(focusInfo.texcoord - float2(focusInfo.texcoord.x, focusPointCoords.y)))));
}
}
}
#line 1122
technique CinematicDOF
< ui_tooltip = "Cinematic Depth of Field "
 "v1.1.15"
"\n===========================================\n\n"
"Cinematic Depth of Field is a state of the art depth of field shader,\n"
"offering fine-grained control over focusing, blur aspects and highlights,\n"
"using real-life lens aspects. Cinematic Depth of Field is based on\n"
"various papers, of which the references are included in the source code.\n\n"
"Cinematic Depth of Field was written by Frans 'Otis_Inf' Bouma and is part of OtisFX\n"
"https://fransbouma.com | https://github.com/FransBouma/OtisFX"; >
{
pass DetermineCurrentFocus { VertexShader = PostProcessVS; PixelShader = PS_DetermineCurrentFocus; RenderTarget = texCDCurrentFocus; }
pass CopyCurrentFocus { VertexShader = PostProcessVS; PixelShader = PS_CopyCurrentFocus; RenderTarget = texCDPreviousFocus; }
pass CalculateCoC { VertexShader = VS_Focus; PixelShader = PS_CalculateCoCValues; RenderTarget = texCDCoC; }
pass CoCTile1 { VertexShader = PostProcessVS; PixelShader = PS_CoCTile1; RenderTarget = texCDCoCTileTmp; }
pass CoCTile2 { VertexShader = PostProcessVS; PixelShader = PS_CoCTile2; RenderTarget = texCDCoCTile; }
pass CoCTileNeighbor { VertexShader = PostProcessVS; PixelShader = PS_CoCTileNeighbor; RenderTarget = texCDCoCTileNeighbor; }
pass CoCBlur1 { VertexShader = PostProcessVS; PixelShader = PS_CoCGaussian1; RenderTarget = texCDCoCTmp1; }
pass CoCBlur2 { VertexShader = PostProcessVS; PixelShader = PS_CoCGaussian2; RenderTarget = texCDCoCBlurred; }
pass PreBlur { VertexShader = VS_DiscBlur; PixelShader = PS_PreBlur; RenderTarget = texCDBuffer1; }
pass BokehBlur { VertexShader = VS_DiscBlur; PixelShader = PS_BokehBlur; RenderTarget = texCDBuffer2; }
pass NearBokehBlur { VertexShader = VS_DiscBlur; PixelShader = PS_NearBokehBlur; RenderTarget = texCDBuffer1; }
pass TentFilter { VertexShader = PostProcessVS; PixelShader = PS_TentFilter; RenderTarget = texCDBuffer3; }
pass Combiner { VertexShader = PostProcessVS; PixelShader = PS_Combiner; RenderTarget = texCDBuffer4; }
pass PostSmoothing1 { VertexShader = PostProcessVS; PixelShader = PS_PostSmoothing1; RenderTarget = texCDBuffer5; }
pass PostSmoothing2AndFocusing { VertexShader = VS_Focus; PixelShader = PS_PostSmoothing2AndFocusing;}
}
}

