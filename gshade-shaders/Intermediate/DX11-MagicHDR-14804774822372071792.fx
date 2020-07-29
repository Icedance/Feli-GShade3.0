#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\MagicHDR.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FXShadersCommon.fxh"
#line 9
namespace FXShaders
{
#line 16
static const float FloatEpsilon = 0.001;
#line 86
float2 GetResolution()
{
return float2(1024, 720);
}
#line 94
float2 GetPixelSize()
{
return float2((1.0 / 1024), (1.0 / 720));
}
#line 102
float4 GetScreenParams()
{
return float4(GetResolution(), GetPixelSize());
}
#line 118
float2 scale_uv(float2 uv, float2 scale, float2 pivot)
{
return (uv - pivot) * scale + pivot;
}
#line 131
float2 scale_uv(float2 uv, float2 scale)
{
return scale_uv(uv, scale, 0.5);
}
#line 141
float GetLumaGamma(float3 color)
{
return dot(color, float3(0.299, 0.587, 0.114));
}
#line 152
float GetLumaLinear(float3 color)
{
return dot(color, float3(0.2126, 0.7152, 0.0722));
}
#line 165
float3 checkered_pattern(float2 uv, float size, float color_a, float color_b)
{
static const float cSize = 32.0;
static const float3 cColorA = pow(0.15, 2.2);
static const float3 cColorB = pow(0.5, 2.2);
#line 171
uv *= GetResolution();
uv %= cSize;
#line 174
const float half_size = cSize * 0.5;
const float checkered = step(uv.x, half_size) == step(uv.y, half_size);
return (cColorA * checkered) + (cColorB * (1.0 - checkered));
}
#line 185
float3 checkered_pattern(float2 uv)
{
static const float Size = 32.0;
static const float ColorA = pow(0.15, 2.2);
static const float ColorB = pow(0.5, 2.2);
#line 191
return checkered_pattern(uv, Size, ColorA, ColorB);
}
#line 204
float3 ApplySaturation(float3 color, float amount)
{
const float gray = GetLumaLinear(color);
return gray + (color - gray) * amount;
}
#line 215
float GetRandom(float2 uv)
{
#line 220
static const float A = 23.2345;
static const float B = 84.1234;
static const float C = 56758.9482;
#line 224
return frac(sin(dot(uv, float2(A, B))) * C);
}
#line 234
void ScreenVS(
uint id : SV_VERTEXID,
out float4 pos : SV_POSITION,
out float2 uv : TEXCOORD)
{
if (id == 2)
uv.x = 2.0;
else
uv.x = 0.0;
#line 244
if (id == 1)
uv.y = 2.0;
else
uv.y = 0.0;
#line 249
pos = float4(uv * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}
#line 252
} 
#line 3 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\MagicHDR.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FXShadersConvolution.fxh"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FXShadersMath.fxh"
#line 3
namespace FXShaders
{
#line 70
static const float Pi = 3.14159;
#line 75
static const float DegreesToRadians = Pi / 180.0;
#line 80
static const float RadiansToDegrees = 180.0 / Pi;
#line 89
float2 GetOffsetByAngleDistance(float2 pos, float angle, float distance)
{
float2 cosSin;
sincos(angle, cosSin.y, cosSin.x);
#line 94
return mad(distance, cosSin, pos);
}
#line 104
float2 GetDirectionFromAngleMagnitude(float angle, float magnitude)
{
return GetOffsetByAngleDistance(0.0, angle, magnitude);
}
#line 116
float2 ClampMagnitude(float2 v, float2 minMax) {
if (v.x == 0.0 && v.y == 0.0)
{
return 0.0;
}
else
{
const float mag = length(v);
if (mag < minMax.x)
return 0.0;
else
return (v / mag) * min(mag, minMax.y);
}
}
#line 131
}
#line 3 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FXShadersConvolution.fxh"
#line 5
namespace FXShaders
{
#line 18
float NormalDistribution(float x, float u, float o)
{
o *= o;
#line 22
const float b = ((x - u) * (x - u)) / 2.0 * o;
#line 24
return (1.0 / sqrt(2.0 * Pi * o)) * exp(-(b));
}
#line 35
float Gaussian1D(float x, float o)
{
o *= o;
const float b = (x * x) / (2.0 * o);
return  (1.0 / sqrt(2.0 * Pi * o)) * exp(-b);
}
#line 50
float Gaussian2D(float2 i, float o)
{
o *= o;
const float b = (i.x * i.x + i.y * i.y) / (2.0 * o);
return (1.0 / (2.0 * Pi * o)) * exp(-b);
}
#line 70
float4 GaussianBlur1D(
sampler sp,
float2 uv,
float2 dir,
float sigma,
int samples)
{
static const float half_samples = samples * 0.5;
#line 79
float4 color = 0.0;
float accum = 0.0;
#line 82
uv -= half_samples * dir;
#line 84
[unroll]
for (int i = 0; i < samples; ++i)
{
float weight = Gaussian1D(i - half_samples, sigma);
#line 89
color += tex2D(sp, uv) * weight;
accum += weight;
#line 92
uv += dir;
}
#line 95
return color / accum;
}
#line 111
float4 GaussianBlur2D(
sampler sp,
float2 uv,
float2 scale,
float sigma,
int2 samples)
{
static const float2 half_samples = samples * 0.5;
#line 120
float4 color = 0.0;
float accum = 0.0;
#line 123
uv -= half_samples * scale;
#line 125
[unroll]
for (int x = 0; x < samples.x; ++x)
{
float init_x = uv.x;
#line 130
[unroll]
for (int y = 0; y < samples.y; ++y)
{
float2 pos = float2(x, y);
float weight = Gaussian2D(abs(pos - half_samples), sigma);
#line 136
color += tex2D(sp, uv) * weight;
accum += weight;
#line 139
uv.x += scale.x;
}
#line 142
uv.x = init_x;
uv.y += scale.y;
}
#line 146
return color / accum;
}
#line 149
}
#line 4 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\MagicHDR.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FXShadersMath.fxh"
#line 5 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\MagicHDR.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FXShadersTonemap.fxh"
#line 3
namespace FXShaders
{
#line 11
float3 Reinhard(float3 color)
{
return color / (1.0 + color);
}
#line 24
float3 ReinhardInv(float3 color, float inv_max)
{
return (color / max(1.0 - color, inv_max));
}
#line 38
float3 ReinhardInvLum(float3 color, float inv_max)
{
float lum = max(color.r, max(color.g, color.b));
return color * (lum / max(1.0 - lum, inv_max));
}
#line 51
float3 Uncharted2Tonemap(float3 color) {
#line 53
static const float A = 0.15;
#line 56
static const float B = 0.50;
#line 59
static const float C = 0.10;
#line 62
static const float D = 0.20;
#line 65
static const float E = 0.02;
#line 68
static const float F = 0.30;
#line 71
static const float W = 11.2;
#line 73
static const float White =
1.0 / ((
(W * (A * W + C * B) + D * E) /
(W * (A * W + B) + D * F)
) - E / F);
#line 79
color = (
(color * (A * color + C * B) + D * E) /
(color * (A * color + B) + D * F)
) - E / F;
#line 84
return color * White;
}
#line 87
namespace BakingLabACES
{
#line 90
static const float3x3 ACESInputMat = float3x3
(
0.59719, 0.35458, 0.04823,
0.07600, 0.90834, 0.01566,
0.02840, 0.13383, 0.83777
);
#line 98
static const float3x3 ACESOutputMat = float3x3
(
1.60475, -0.53108, -0.07367,
-0.10208,  1.10813, -0.00605,
-0.00327, -0.07276,  1.07602
);
#line 105
float3 RRTAndODTFit(float3 v)
{
return (v * (v + 0.0245786f) - 0.000090537f) / (v * (0.983729f * v + 0.4329510f) + 0.238081f);
}
#line 110
float3 ACESFitted(float3 color)
{
color = mul(ACESInputMat, color);
#line 115
color = RRTAndODTFit(color);
#line 117
color = mul(ACESOutputMat, color);
#line 120
color = saturate(color);
#line 122
return color;
}
}
#line 126
float3 BakingLabACESTonemap(float3 color)
{
return BakingLabACES::ACESFitted(color);
}
#line 131
} 
#line 6 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\MagicHDR.fx"
#line 30
namespace FXShaders
{
#line 35
static const int2 DownsampleAmount =  1;
#line 37
static const int BlurSamples =  21;
#line 39
static const int InvTonemap_Reinhard = 0;
#line 41
static const int Tonemap_Reinhard = 0;
static const int Tonemap_BakingLabACES = 1;
static const int Tonemap_Uncharted2Filmic = 2;
#line 49
  uniform int _WipWarn < ui_text = "This effect is currently a work in progress and as such some ""aspects may change in the future and some features may still be ""missing or incomplete.\n"; ui_label = " "; ui_type = "radio"; >;
#line 51
  uniform int _Credits < ui_text = "This effect was made by Lucas Melo (luluco250).\n""Updates may be available at https://github.com/luluco250/FXShaders\n""Any issues, suggestions or requests can also be filed there."; ui_category = "Credits"; ui_category_closed = true; ui_label = " "; ui_type = "radio"; >;
#line 157
uniform int _Help < ui_text =
"This effect allows you to add both bloom and tonemapping, drastically "
"changing the mood of the image.\n"
"\n"
"Care should be taken to select an appropriate inverse tonemapper that can "
"accurately extract HDR information from the original image.\n"
"HDR10 users should also take care to select a tonemapper that's "
"compatible with what the HDR monitor is expecting from the LDR output of "
"the game, which *is* tonemapped too.\n"
"\n"
"Available preprocessor directives:\n"
"\n"
"MAGIC_HDR_BLUR_SAMPLES:\n"
"  Determines how many pixels are sampled during each blur pass for the "
"bloom effect.\n"
"  This value directly influences the Blur Size, so the more samples the "
"bigger the blur size can be.\n"
"  Setting MAGIC_HDR_DOWNSAMPLE above 1x will also increase the blur size "
"to compensate for the lower resolution. This effect may be desirable, "
"however.\n"
"\n"
"MAGIC_HDR_DOWNSAMPLE:\n"
"  Serves to divide the resolution of the textures used for processing the "
"bloom effect.\n"
"  Leave at 1x for maximum detail, 2x or 4x should still be fine.\n"
"  Values too high may introduce flickering.\n"
#line 79
; ui_category = "Help"; ui_category_closed = true; ui_label = " "; ui_type = "radio"; >;
#line 81
uniform float BloomAmount
<
ui_category = "Bloom Appearance";
ui_label = "Bloom Amount";
ui_tooltip =
"Amount of bloom to apply to the image.\n"
"\nDefault: 0.2";
ui_type = "slider";
ui_min = 0.0;
ui_max = 1.0;
> = 0.2;
#line 93
uniform float BlurSize
<
ui_category = "Blur Appearance";
ui_label = "Blur Size";
ui_tooltip =
"The size of the gaussian blur applied to create the bloom effect.\n"
"This value is directly influenced by the values of "
"MAGIC_HDR_BLUR_SAMPLES and MAGIC_HDR_DOWNSAMPLE.\n"
"\nDefault: 1.0";
ui_type = "slider";
ui_min = 0.01;
ui_max = 1.0;
> = 1.0;
#line 107
uniform float Whitepoint
<
ui_category = "Tonemapping";
ui_label = "Whitepoint";
ui_tooltip =
"The whitepoint of the HDR image.\n"
"Anything with this brightness is pure white.\n"
"It controls how bright objects are perceived after inverse "
"tonemapping, with higher values leading to a brighter bloom effect.\n"
"\nDefault: 2";
ui_type = "slider";
ui_min = 1;
ui_max = 10;
ui_step = 1;
> = 2;
#line 123
uniform float Exposure
<
ui_category = "Tonemapping";
ui_label = "Exposure";
ui_tooltip =
"Exposure applied at the end of the effect.\n"
"This value is measured in f-stops.\n"
"\nDefault: 1.0";
ui_type = "slider";
ui_min = -3.0;
ui_max = 3.0;
> = 1.0;
#line 136
uniform int InvTonemap
<
ui_category = "Tonemapping";
ui_label = "Inverse Tonemapper";
ui_tooltip =
"The inverse tonemapping operator used at the beginning of the "
"effect.\n"
"\nDefault: Reinhard";
ui_type = "combo";
ui_items = "Reinhard\0";
> = 0;
#line 148
uniform int Tonemap
<
ui_category = "Tonemapping";
ui_label = "Tonemapper";
ui_tooltip =
"The tonemapping operator used at the end of the effect.\n"
"\nDefault: Baking Lab ACES";
ui_type = "combo";
ui_items = "Reinhard\0Baking Lab ACES\0Uncharted 2 Filmic\0";
> = 1;
#line 163
texture ColorTex : COLOR;
#line 165
sampler Color
{
Texture = ColorTex;
SRGBTexture = true;
};
#line 172
texture DownsampledTex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x;
Height = 720 / DownsampleAmount.y;
Format = RGBA16F;
};
#line 179
sampler Downsampled
{
Texture = DownsampledTex;
};
#line 184
texture TempTex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x;
Height = 720 / DownsampleAmount.y;
Format = RGBA16F;
};
#line 191
sampler Temp
{
Texture = TempTex;
};
#line 196
texture Bloom0Tex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x;
Height = 720 / DownsampleAmount.y;
Format = RGBA16F;
};
#line 203
sampler Bloom0
{
Texture = Bloom0Tex;
};
#line 208
texture Bloom1Tex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x / 2;
Height = 720 / DownsampleAmount.y / 2;
Format = RGBA16F;
};
#line 215
sampler Bloom1
{
Texture = Bloom1Tex;
};
#line 220
texture Bloom2Tex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x / 4;
Height = 720 / DownsampleAmount.y / 4;
Format = RGBA16F;
};
#line 227
sampler Bloom2
{
Texture = Bloom2Tex;
};
#line 232
texture Bloom3Tex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x / 8;
Height = 720 / DownsampleAmount.y / 8;
Format = RGBA16F;
};
#line 239
sampler Bloom3
{
Texture = Bloom3Tex;
};
#line 244
texture Bloom4Tex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x / 16;
Height = 720 / DownsampleAmount.y / 16;
Format = RGBA16F;
};
#line 251
sampler Bloom4
{
Texture = Bloom4Tex;
};
#line 256
texture Bloom5Tex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x / 32;
Height = 720 / DownsampleAmount.y / 32;
Format = RGBA16F;
};
#line 263
sampler Bloom5
{
Texture = Bloom5Tex;
};
#line 268
texture Bloom6Tex <pooled = true;>
{
Width = 1024 / DownsampleAmount.x / 64;
Height = 720 / DownsampleAmount.y / 64;
Format = RGBA16F;
};
#line 275
sampler Bloom6
{
Texture = Bloom6Tex;
};
#line 284
float3 ApplyInverseTonemap(float3 color)
{
float w = max(Whitepoint, FloatEpsilon);
w = exp2(w);
#line 290
switch (InvTonemap)
{
case InvTonemap_Reinhard:
color = ReinhardInv(color, rcp(w));
break;
}
#line 297
return color;
}
#line 300
float4 Blur(sampler sp, float2 uv, float2 dir)
{
float4 color = GaussianBlur1D(
sp,
uv,
dir * GetPixelSize() * DownsampleAmount,
sqrt(BlurSamples) * BlurSize,
BlurSamples);
#line 309
return color;
}
#line 316
float4 InverseTonemapPS(
float4 p : SV_POSITION,
float2 uv : TEXCOORD) : SV_TARGET
{
const float4 color = tex2D(Color, uv);
#line 324
return float4(ApplyInverseTonemap(color.rgb), color.a);
}
#line 328
float4 Blur0PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Downsampled, uv, float2(1.0, 0.0));
}
#line 333
float4 Blur1PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Temp, uv, float2(0.0, 1.0));
}
#line 338
float4 Blur2PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Bloom0, uv, float2(2.0, 0.0));
}
#line 343
float4 Blur3PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Temp, uv, float2(0.0, 2.0));
}
#line 348
float4 Blur4PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Bloom1, uv, float2(4.0, 0.0));
}
#line 353
float4 Blur5PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Temp, uv, float2(0.0, 4.0));
}
#line 358
float4 Blur6PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Bloom2, uv, float2(8.0, 0.0));
}
#line 363
float4 Blur7PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Temp, uv, float2(0.0, 8.0));
}
#line 368
float4 Blur8PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Bloom3, uv, float2(16.0, 0.0));
}
#line 373
float4 Blur9PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Temp, uv, float2(0.0, 16.0));
}
#line 378
float4 Blur10PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Bloom4, uv, float2(32.0, 0.0));
}
#line 383
float4 Blur11PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Temp, uv, float2(0.0, 32.0));
}
#line 388
float4 Blur12PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Bloom5, uv, float2(64.0, 0.0));
}
#line 393
float4 Blur13PS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return Blur(Temp, uv, float2(0.0, 64.0));
}
#line 398
float4 TonemapPS(
float4 p : SV_POSITION,
float2 uv : TEXCOORD) : SV_TARGET
{
float4 color = tex2D(Color, uv);
color.rgb = ApplyInverseTonemap(color.rgb);
#line 407
float4 bloom =
tex2D(Bloom0, uv) +
tex2D(Bloom1, uv) +
tex2D(Bloom2, uv) +
tex2D(Bloom3, uv) +
tex2D(Bloom4, uv) +
tex2D(Bloom5, uv) +
tex2D(Bloom6, uv);
#line 416
bloom /= 7;
#line 418
color.rgb = lerp(color.rgb, bloom.rgb, log10(BloomAmount + 1.0));
#line 421
float exposure = exp(Exposure);
#line 424
switch (Tonemap)
{
case Tonemap_Reinhard:
color.rgb = Reinhard(color.rgb * exposure);
break;
case Tonemap_BakingLabACES:
color.rgb = BakingLabACESTonemap(color.rgb * exposure);
break;
case Tonemap_Uncharted2Filmic:
color.rgb = Uncharted2Tonemap(color.rgb * exposure);
break;
}
#line 437
return color;
}
#line 444
technique MagicHDR <ui_tooltip = "FXShaders - Bloom and tonemapping effect.";>
{
pass InverseTonemap
{
VertexShader = ScreenVS;
PixelShader = InverseTonemapPS;
RenderTarget = DownsampledTex;
}
#line 453
pass Blur0
{
VertexShader = ScreenVS;
PixelShader = Blur0PS;
RenderTarget = TempTex;
}
pass Blur1
{
VertexShader = ScreenVS;
PixelShader = Blur1PS;
RenderTarget = Bloom0Tex;
}
pass Blur2
{
VertexShader = ScreenVS;
PixelShader = Blur2PS;
RenderTarget = TempTex;
}
pass Blur3
{
VertexShader = ScreenVS;
PixelShader = Blur3PS;
RenderTarget = Bloom1Tex;
}
pass Blur4
{
VertexShader = ScreenVS;
PixelShader = Blur4PS;
RenderTarget = TempTex;
}
pass Blur5
{
VertexShader = ScreenVS;
PixelShader = Blur5PS;
RenderTarget = Bloom2Tex;
}
pass Blur6
{
VertexShader = ScreenVS;
PixelShader = Blur6PS;
RenderTarget = TempTex;
}
pass Blur7
{
VertexShader = ScreenVS;
PixelShader = Blur7PS;
RenderTarget = Bloom3Tex;
}
pass Blur8
{
VertexShader = ScreenVS;
PixelShader = Blur8PS;
RenderTarget = TempTex;
}
pass Blur9
{
VertexShader = ScreenVS;
PixelShader = Blur9PS;
RenderTarget = Bloom4Tex;
}
pass Blur10
{
VertexShader = ScreenVS;
PixelShader = Blur10PS;
RenderTarget = TempTex;
}
pass Blur11
{
VertexShader = ScreenVS;
PixelShader = Blur11PS;
RenderTarget = Bloom5Tex;
}
pass Blur12
{
VertexShader = ScreenVS;
PixelShader = Blur12PS;
RenderTarget = TempTex;
}
pass Blur13
{
VertexShader = ScreenVS;
PixelShader = Blur13PS;
RenderTarget = Bloom6Tex;
}
pass Tonemap
{
VertexShader = ScreenVS;
PixelShader = TonemapPS;
SRGBWriteEnable = true;
}
}
#line 547
} 

