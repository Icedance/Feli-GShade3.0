#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\Bloom.fx"
#line 4
uniform int iBloomMixmode <
ui_type = "combo";
ui_items = "Linear add\0Screen add\0Screen/Lighten/Opacity\0Lighten\0";
> = 2;
uniform float fBloomThreshold <
ui_type = "slider";
ui_min = 0.1; ui_max = 1.0;
ui_tooltip = "Every pixel brighter than this value triggers bloom.";
> = 0.8;
uniform float fBloomAmount <
ui_type = "slider";
ui_min = 0.0; ui_max = 20.0;
ui_tooltip = "Intensity of bloom.";
> = 0.8;
uniform float fBloomSaturation <
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
ui_tooltip = "Bloom saturation. 0.0 means white bloom, 2.0 means very, very colorful bloom.";
> = 0.8;
uniform float3 fBloomTint <
ui_type = "color";
ui_tooltip = "R, G and B components of bloom tint the bloom color gets shifted to.";
> = float3(0.7, 0.8, 1.0);
#line 28
uniform bool bLensdirtEnable <
> = false;
uniform int iLensdirtMixmode <
ui_type = "combo";
ui_items = "Linear add\0Screen add\0Screen/Lighten/Opacity\0Lighten\0";
> = 1;
uniform float fLensdirtIntensity <
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
ui_tooltip = "Intensity of lensdirt.";
> = 0.4;
uniform float fLensdirtSaturation <
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
ui_tooltip = "Color saturation of lensdirt.";
> = 2.0;
uniform float3 fLensdirtTint <
ui_type = "color";
ui_tooltip = "R, G and B components of lensdirt tint the lensdirt color gets shifted to.";
> = float3(1.0, 1.0, 1.0);
#line 49
uniform bool bAnamFlareEnable <
> = false;
uniform float fAnamFlareThreshold <
ui_type = "slider";
ui_min = 0.1; ui_max = 1.0;
ui_tooltip = "Every pixel brighter than this value gets a flare.";
> = 0.9;
uniform float fAnamFlareWideness <
ui_type = "slider";
ui_min = 1.0; ui_max = 2.5;
ui_tooltip = "Horizontal wideness of flare. Don't set too high, otherwise the single samples are visible.";
> = 2.4;
uniform float fAnamFlareAmount <
ui_type = "slider";
ui_min = 1.0; ui_max = 20.0;
ui_tooltip = "Intensity of anamorphic flare.";
> = 14.5;
uniform float fAnamFlareCurve <
ui_type = "slider";
ui_min = 1.0; ui_max = 2.0;
ui_tooltip = "Intensity curve of flare with distance from source.";
> = 1.2;
uniform float3 fAnamFlareColor <
ui_type = "color";
ui_tooltip = "R, G and B components of anamorphic flare. Flare is always same color.";
> = float3(0.012, 0.313, 0.588);
#line 76
uniform bool bLenzEnable <
> = false;
uniform float fLenzIntensity <
ui_type = "slider";
ui_min = 0.2; ui_max = 3.0;
ui_tooltip = "Power of lens flare effect";
> = 1.0;
uniform float fLenzThreshold <
ui_type = "slider";
ui_min = 0.6; ui_max = 1.0;
ui_tooltip = "Minimum brightness an object must have to cast lensflare.";
> = 0.8;
#line 89
uniform bool bChapFlareEnable <
> = false;
uniform float fChapFlareTreshold <
ui_type = "slider";
ui_min = 0.70; ui_max = 0.99;
ui_tooltip = "Brightness threshold for lensflare generation. Everything brighter than this value gets a flare.";
> = 0.90;
uniform int iChapFlareCount <
ui_type = "slider";
ui_min = 1; ui_max = 20;
ui_tooltip = "Number of single halos to be generated. If set to 0, only the curved halo around is visible.";
> = 15;
uniform float fChapFlareDispersal <
ui_type = "slider";
ui_min = 0.25; ui_max = 1.00;
ui_tooltip = "Distance from screen center (and from themselves) the flares are generated. ";
> = 0.25;
uniform float fChapFlareSize <
ui_type = "slider";
ui_min = 0.20; ui_max = 0.80;
ui_tooltip = "Distance (from screen center) the halo and flares are generated.";
> = 0.45;
uniform float3 fChapFlareCA <
ui_type = "slider";
ui_min = -0.5; ui_max = 0.5;
ui_tooltip = "Offset of RGB components of flares as modifier for Chromatic abberation. Same 3 values means no CA.";
> = float3(0.00, 0.01, 0.02);
uniform float fChapFlareIntensity <
ui_type = "slider";
ui_min = 5.0; ui_max = 200.0;
ui_tooltip = "Intensity of flares and halo, remember that higher threshold lowers intensity, you might play with both values to get desired result.";
> = 100.0;
#line 122
uniform bool bGodrayEnable <
> = false;
uniform float fGodrayDecay <
ui_type = "slider";
ui_min = 0.5000; ui_max = 0.9999;
ui_tooltip = "How fast they decay. It's logarithmic, 1.0 means infinite long rays which will cover whole screen";
> = 0.9900;
uniform float fGodrayExposure <
ui_type = "slider";
ui_min = 0.7; ui_max = 1.5;
ui_tooltip = "Upscales the godray's brightness";
> = 1.0;
uniform float fGodrayWeight <
ui_type = "slider";
ui_min = 0.80; ui_max = 1.70;
ui_tooltip = "weighting";
> = 1.25;
uniform float fGodrayDensity <
ui_type = "slider";
ui_min = 0.2; ui_max = 2.0;
ui_tooltip = "Density of rays, higher means more and brighter rays";
> = 1.0;
uniform float fGodrayThreshold <
ui_type = "slider";
ui_min = 0.6; ui_max = 1.0;
ui_tooltip = "Minimum brightness an object must have to cast godrays";
> = 0.9;
uniform int iGodraySamples <
ui_tooltip = "2^x format values; How many samples the godrays get";
> = 128;
#line 153
uniform float fFlareLuminance <
ui_type = "slider";
ui_min = 0.000; ui_max = 1.000;
ui_tooltip = "bright pass luminance value ";
> = 0.095;
uniform float fFlareBlur <
ui_type = "slider";
ui_min = 1.0; ui_max = 10000.0;
ui_tooltip = "manages the size of the flare";
> = 200.0;
uniform float fFlareIntensity <
ui_type = "slider";
ui_min = 0.20; ui_max = 5.00;
ui_tooltip = "effect intensity";
> = 2.07;
uniform float3 fFlareTint <
ui_type = "color";
ui_tooltip = "effect tint RGB";
> = float3(0.137, 0.216, 1.0);
#line 188
texture texDirt < source = "LensDBA.png"; > { Width = 1920; Height = 1080; Format = RGBA8; };
texture texSprite < source = "LensSprite.png"; > { Width = 1920; Height = 1080; Format = RGBA8; };
#line 191
sampler SamplerDirt { Texture = texDirt; };
sampler SamplerSprite { Texture = texSprite; };
#line 194
texture texBloom1
{
Width = 2560;
Height = 1440;
Format = RGBA16F;
};
texture texBloom2
{
Width = 2560;
Height = 1440;
Format = RGBA16F;
};
texture texBloom3
{
Width = 2560 / 2;
Height = 1440 / 2;
Format = RGBA16F;
};
texture texBloom4
{
Width = 2560 / 4;
Height = 1440 / 4;
Format = RGBA16F;
};
texture texBloom5
{
Width = 2560 / 8;
Height = 1440 / 8;
Format = RGBA16F;
};
texture texLensFlare1
{
Width = 2560 / 2;
Height = 1440 / 2;
Format = RGBA16F;
};
texture texLensFlare2
{
Width = 2560 / 2;
Height = 1440 / 2;
Format = RGBA16F;
};
#line 237
sampler SamplerBloom1 { Texture = texBloom1; };
sampler SamplerBloom2 { Texture = texBloom2; };
sampler SamplerBloom3 { Texture = texBloom3; };
sampler SamplerBloom4 { Texture = texBloom4; };
sampler SamplerBloom5 { Texture = texBloom5; };
sampler SamplerLensFlare1 { Texture = texLensFlare1; };
sampler SamplerLensFlare2 { Texture = texLensFlare2; };
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
#line 245 "C:\FFXIV\game\gshade-shaders\Shaders\Bloom.fx"
#line 250
float4 GaussBlur22(float2 coord, sampler tex, float mult, float lodlevel, bool isBlurVert)
{
const float weight[11] = {
0.082607,
0.080977,
0.076276,
0.069041,
0.060049,
0.050187,
0.040306,
0.031105,
0.023066,
0.016436,
0.011254
};
#line 266
float4 sum = 0.0;
float4 texcoord = float4( coord.xy, 0, lodlevel );
#line 283
if (isBlurVert)
{
#line 286
float axis =  float2((1.0 / 2560), (1.0 / 1440)).y * mult;
#line 288
for (int i = -10; i < 11; i++)
{
texcoord.y = coord.y + axis * (float)i;
sum += tex2D(tex, texcoord.xy) * weight[abs(i)];
}
}
else
{
#line 297
float axis =  float2((1.0 / 2560), (1.0 / 1440)).x * mult;
#line 299
for (int i = -10; i < 11; i++)
{
texcoord.x = coord.x + axis * (float)i;
sum += tex2D(tex, texcoord.xy) * weight[abs(i)];
}
#line 305
}
#line 307
return sum;
}
#line 319
float GetDnB(sampler tex, float2 coords)
{
float color;
float4 texcoords = float4(coords.xy, 0, 0);
#line 331
{
texcoords.w = 4;	
color = (max(0, dot(tex2Dlod(tex, texcoords).rgb, 0.333)) - fChapFlareTreshold) * fChapFlareIntensity;
}
return color;
}
#line 339
float3 GetDistortedTex(sampler tex, float2 sample_center, float2 sample_vector, float3 distortion)
{
const float2 final_vector = sample_center + sample_vector * min(min(distortion.r, distortion.g), distortion.b);
#line 343
if (final_vector.x > 1.0 || final_vector.y > 1.0 || final_vector.x < -1.0 || final_vector.y < -1.0)
return float3(0, 0, 0);
else
return float3(
GetDnB(tex, sample_center + sample_vector * distortion.r),
GetDnB(tex, sample_center + sample_vector * distortion.g),
GetDnB(tex, sample_center + sample_vector * distortion.b));
}
#line 352
float3 GetBrightPass(float2 coords)
{
#line 359
const float3 c = tex2D(ReShade::BackBuffer, coords).rgb;
#line 361
return lerp(0.0, c, smoothstep(0.0f, 0.5, dot(max(c - fFlareLuminance.xxx, 0.0), 1.0)));
}
#line 364
float3 GetAnamorphicSample(int axis, float2 coords, float blur)
{
coords = 2.0 * coords - 1.0;
coords.x /= -blur;
return GetBrightPass(0.5 * coords + 0.5);
}
#line 374
void BloomPass0(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
#line 377
const float2 bps =  float2((1.0 / 2560), (1.0 / 1440)) * 2;
#line 380
const float2 tcP = texcoord + bps;
const float2 tcN = texcoord - bps;
#line 385
const float2 bloomuv[4] = {
float2( tcP.x, tcP.y),	
float2( tcP.x, tcP.y),	
float2( tcN.x, tcP.y),	
float2( tcN.x, tcN.y)	
};
#line 393
float4 tempbloom;
bloom = 0.0;
#line 396
for (int i = 0; i < 4; i++)
{
#line 400
tempbloom.rgb = tex2D(ReShade::BackBuffer, bloomuv[i]).rgb;
#line 403
tempbloom.w = dot(tempbloom.xyz, 0.333) - fAnamFlareThreshold;
tempbloom.xyz = tempbloom.xyz - fBloomThreshold;
bloom += max(0, tempbloom);
}
#line 408
bloom *= 0.25;
}
#line 414
void BloomPass1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
#line 417
const float2 bps =  float2((1.0 / 2560), (1.0 / 1440)) * 4;
#line 423
const float2 tcP = texcoord + bps;
const float2 tcN = texcoord - bps;
const float2 tc0 = texcoord;
#line 429
const float2 bloomuv[8] = {
float2(tcP.x, tcP.y),	
float2(tc0.x, tcN.y),	
float2(tcN.x, tcP.y),	
float2(tcN.x, tcN.y),	
float2(tc0.x, tcP.y),	
float2(tc0.x, tcN.y),	
float2(tcP.x, tc0.y),	
float2(tcN.x, tc0.y)	
};
#line 440
bloom = 0.0;
#line 442
for (int i = 0; i < 8; i++)
{
#line 445
bloom += tex2D(SamplerBloom1, bloomuv[i]);
}
#line 448
bloom *= 0.125;
}
#line 452
void BloomPass2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
#line 455
const float2 bps =  float2((1.0 / 2560), (1.0 / 1440)) * 8;
const float2 bps707 = bps * 0.707;
#line 460
const float2 tcP1 = texcoord + bps;
const float2 tcN1 = texcoord - bps;
const float2 tcP7 = texcoord + bps707;
const float2 tcN7 = texcoord - bps707;
const float2 tc00 = texcoord;
#line 468
const float2 bloomuv[8] = {
float2(tcP7.x, tcP7.y),	
float2(tcP7.x, tcN7.y),	
float2(tcN7.x, tcP7.y),	
float2(tcN7.x, tcN7.y),	
#line 474
float2(tc00.x, tcP1.y),	
float2(tc00.x, tcN1.y),	
float2(tcP1.x, tc00.y),	
float2(tcN1.x, tc00.y)	
};
#line 480
bloom = 0.0;
#line 482
for (int i = 0; i < 8; i++)
{
#line 485
bloom += tex2D(SamplerBloom2, bloomuv[i]);
}
#line 488
bloom *= 0.5; 
}
#line 491
void BloomPass3(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
bloom = GaussBlur22(texcoord.xy, SamplerBloom3, 16, 0, 0);
bloom.w *= fAnamFlareAmount;
bloom.xyz *= fBloomAmount;
}
void BloomPass4(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
bloom.xyz = GaussBlur22(texcoord, SamplerBloom4, 16, 0, 1).xyz * 2.5;
bloom.w = GaussBlur22(texcoord, SamplerBloom4, 32 * fAnamFlareWideness, 0, 0).w * 2.5; 
}
#line 504
void LensFlarePass0(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 lens : SV_Target)
{
lens = 0;
#line 509
if (bLenzEnable)
{
#line 515
const float3 lfoffset[19] = {
float3( 0.90000,  0.01,  4.00),
float3( 0.70000,  0.25,  25.0),
float3( 0.30000,  0.25,  15.0),
float3( 1.00000,  1.00,  5.00),
float3(-0.15000,  20.0,  1.00),
float3(-0.30000,  20.0,  1.00),
float3( 6.00000,  6.00,  6.00),
float3( 7.00000,  7.00,  7.00),
float3( 8.00000,  8.00,  8.00),
float3( 9.00000,  9.00,  9.00),
float3( 0.24000,  1.00,  10.0),
float3( 0.32000,  1.00,  10.0),
float3( 0.40000,  1.00,  10.0),
float3( 0.50000, -0.50,  2.00),
float3( 2.00000,  2.00, -5.00),
float3(-5.00000,  0.20,  0.20),
float3( 20.0000,  0.50,  0.00),
float3( 0.40000,  1.00,  10.0),
float3( 0.00001,  10.0,  20.0)
};
#line 538
const float3 lffactors[19] = {
float3(1.500, 1.500, 0.000),
float3(0.000, 1.500, 0.000),
float3(0.000, 0.000, 1.500),
float3(0.200, 0.250, 0.000),
float3(0.150, 0.000, 0.000),
float3(0.000, 0.000, 0.150),
float3(1.400, 0.000, 0.000),
float3(1.000, 1.000, 0.000),
float3(0.000, 1.000, 0.000),
float3(0.000, 0.000, 1.400),
float3(1.000, 0.300, 0.000),
float3(1.000, 1.000, 0.000),
float3(0.000, 2.000, 4.000),
float3(0.200, 0.100, 0.000),
float3(0.000, 0.000, 1.000),
float3(1.000, 1.000, 0.000),
float3(1.000, 1.000, 0.000),
float3(0.000, 0.000, 0.200),
float3(0.012, 0.313, 0.588)
};
#line 560
float2 lfcoord = 0;
float3 lenstemp = 0;
const float2 distfact = float2((texcoord.x - 0.5) *  (2560 * (1.0 / 1440)), texcoord.y - 0.5);
#line 565
const float distfactlen = 2.0 * length(distfact);
#line 567
for (int i = 0; i < 19; i++)
{
lfcoord.xy = lfoffset[i].x * distfact;
lfcoord.xy *= pow(distfactlen, lfoffset[i].y * 3.5);
lfcoord.xy *= lfoffset[i].z;
lfcoord.xy = 0.5 - lfcoord.xy;
float2 tempfact = (lfcoord.xy - 0.5) * 2;
#line 575
float lenstemp1;
#line 584
lenstemp1 = dot(tex2Dlod(ReShade::BackBuffer, float4(lfcoord.xy, 0, 1)).rgb, 0.333);
#line 589
lenstemp1 = max(0.0, lenstemp1 - fLenzThreshold) + lffactors[i].x * (lenstemp1 * saturate(1.0 - dot(tempfact, tempfact)));
}
#line 592
lens.rgb += lenstemp * fLenzIntensity;
}
#line 596
if (bChapFlareEnable)
{
const float2 sample_vector = (float2(0.5, 0.5) - texcoord.xy) * fChapFlareDispersal;
const float2 halo_vector = normalize(sample_vector) * fChapFlareSize;
#line 601
float3 chaplens = GetDistortedTex(ReShade::BackBuffer, texcoord.xy + halo_vector, halo_vector, fChapFlareCA * 2.5f).rgb;
#line 603
for (int j = 0; j < iChapFlareCount; ++j)
{
float2 foffset = sample_vector * float(j);
chaplens += GetDistortedTex(ReShade::BackBuffer, texcoord.xy + foffset, foffset, fChapFlareCA).rgb;
}
#line 610
chaplens /= iChapFlareCount;
lens.xyz += chaplens;
}
#line 615
if (bGodrayEnable)
{
const float2 ScreenLightPos = float2(0.5, 0.5);
#line 624
const float2 texcoord2 = texcoord - ((texcoord - ScreenLightPos) / ((float)iGodraySamples * fGodrayDensity));
#line 628
const float sampledepth = tex2D(ReShade::DepthBuffer, texcoord2).x;
float4 sample2;
sample2.rgb = tex2D(ReShade::BackBuffer, texcoord2).rgb;
sample2.w = saturate(dot(sample2.xyz, 0.3333) - fGodrayThreshold);
#line 634
sample2.g *= 0.95;
sample2.b *= 0.85;
#line 637
float illuminationDecay = 1.0;
#line 639
for (int g = 0; g < iGodraySamples; g++)
{
#line 643
float4 sample2copy = sample2 * (illuminationDecay * fGodrayWeight);
#line 648
lens.rgb += sample2copy.xyz * sample2copy.w;
#line 650
illuminationDecay *= fGodrayDecay;
}
}
#line 655
if (bAnamFlareEnable)
{
const float gaussweight[5] = { 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 };
#line 660
const float brh = (1.0 / 1440) * 2;
float2 anamCoord = texcoord.xy;
float3 anamSample;
float3 anamFlare = 0;
#line 665
for (int z = -4; z < 5; z++)
{
#line 670
anamCoord.y = texcoord.y + z * brh;
anamSample = GetAnamorphicSample(0, anamCoord, fFlareBlur);
anamFlare += anamSample * fFlareTint * gaussweight[abs(z)];
}
#line 675
lens.xyz += anamFlare * fFlareIntensity;
}
}
#line 679
void LensFlarePass1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 lens : SV_Target)
{
lens = GaussBlur22(texcoord, SamplerLensFlare1, 2, 0, 1);
}
void LensFlarePass2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 lens : SV_Target)
{
lens = GaussBlur22(texcoord, SamplerLensFlare2, 2, 0, 0);
}
#line 689
void LightingCombine(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
color = tex2D(ReShade::BackBuffer, texcoord);
#line 694
float3 colorbloom = saturate((tex2D(SamplerBloom3, texcoord).rgb + (tex2D(SamplerBloom5, texcoord).rgb * 9.0)) * 0.1);
colorbloom = lerp(dot(colorbloom, 0.333), colorbloom, fBloomSaturation) * fBloomTint;
#line 697
switch (iBloomMixmode)
{
case 0:
color.rgb += colorbloom;
break;
case 1:
color.rgb = 1 - (1 - color.rgb) * (1 - colorbloom);
break;
case 2:
#line 707
colorbloom = 1 - saturate(colorbloom);
colorbloom = 1 - ( colorbloom * colorbloom );
#line 710
color.rgb = max(0.0f, max(color.rgb, colorbloom.rgb));
break;
case 3:
color.rgb = max(color.rgb, colorbloom.rgb);
break;
}
#line 718
if (bAnamFlareEnable)
{
#line 721
color.rgb += pow(max((tex2D(SamplerBloom5, texcoord.xy).w * 2) * fAnamFlareColor, 0.0), 1.0 / fAnamFlareCurve);
}
#line 725
if (bLensdirtEnable)
{
#line 728
float3 lensdirt = tex2D(SamplerDirt, texcoord).rgb * (dot(tex2D(SamplerBloom5, texcoord).rgb, 0.333) * fLensdirtIntensity);
#line 730
lensdirt = lerp(dot(lensdirt.xyz, 0.333), lensdirt.xyz, fLensdirtSaturation);
#line 732
switch (iLensdirtMixmode)
{
case 0:
color.rgb += lensdirt;
break;
case 1:
color.rgb = 1 - (1 - color.rgb) * (1 - lensdirt);
break;
case 2:
#line 742
lensdirt = 1 - saturate(lensdirt);
lensdirt = 1 - ( lensdirt * lensdirt );
#line 745
color.rgb = max(0.0f, max(color.rgb, lensdirt));
break;
case 3:
color.rgb = max(color.rgb, lensdirt);
break;
}
}
#line 754
if (bAnamFlareEnable || bLenzEnable || bGodrayEnable || bChapFlareEnable)
{
float3 lensflareSample = tex2D(SamplerLensFlare1, texcoord.xy).rgb, lensflareMask;
#line 763
float2 bpsPP =  float2((1.0 / 2560), (1.0 / 1440)) * 0.5;
float2 bpsNN = -bpsPP + texcoord; 
#line 767
bpsPP += texcoord;
#line 771
lensflareMask  = tex2D(SamplerSprite, bpsPP).rgb;
lensflareMask += tex2D(SamplerSprite, float2(bpsNN.x, bpsPP.y)).rgb;
lensflareMask += tex2D(SamplerSprite, float2(bpsPP.x, bpsNN.y)).rgb;
lensflareMask += tex2D(SamplerSprite, bpsNN).rgb;
#line 776
color.rgb += lensflareMask * 0.25 * lensflareSample;
}
}
#line 780
technique BloomAndLensFlares
{
pass BloomPass0
{
VertexShader = PostProcessVS;
PixelShader = BloomPass0;
RenderTarget = texBloom1;
}
pass BloomPass1
{
VertexShader = PostProcessVS;
PixelShader = BloomPass1;
RenderTarget = texBloom2;
}
pass BloomPass2
{
VertexShader = PostProcessVS;
PixelShader = BloomPass2;
RenderTarget = texBloom3;
}
pass BloomPass3
{
VertexShader = PostProcessVS;
PixelShader = BloomPass3;
RenderTarget = texBloom4;
}
pass BloomPass4
{
VertexShader = PostProcessVS;
PixelShader = BloomPass4;
RenderTarget = texBloom5;
}
#line 813
pass LensFlarePass0
{
VertexShader = PostProcessVS;
PixelShader = LensFlarePass0;
RenderTarget = texLensFlare1;
}
pass LensFlarePass1
{
VertexShader = PostProcessVS;
PixelShader = LensFlarePass1;
RenderTarget = texLensFlare2;
}
pass LensFlarePass2
{
VertexShader = PostProcessVS;
PixelShader = LensFlarePass2;
RenderTarget = texLensFlare1;
}
#line 832
pass LightingCombine
{
VertexShader = PostProcessVS;
PixelShader = LightingCombine;
}
}

