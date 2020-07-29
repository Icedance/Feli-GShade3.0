#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Unsharp.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FXShadersBlending.fxh"
#line 3
namespace FXShaders
{
#line 14
float3 BlendScreen(float3 a, float3 b, float w)
{
return 1.0 - (1.0 - a) * (1.0 - b * w);
}
#line 27
float3 BlendOverlay(float3 a, float3 b, float w)
{
float3 color;
if (a.x < 0.5 || a.y < 0.5 || a.z < 0.5)
color = 2.0 * a * b;
else
color = 1.0 - 2.0 * (1.0 - a) * (1.0 - b);
#line 35
return lerp(a, color, w);
}
#line 46
float3 BlendSoftLight(float3 a, float3 b, float w)
{
return lerp(a, (1.0 - 2.0 * b) * (a * a) + 2.0 * b * a, w);
}
#line 59
float3 BlendHardLight(float3 a, float3 b, float w)
{
float3 color;
if (a.x > 0.5 || a.y > 0.5 || a.z > 0.5)
color = 2.0 * a * b;
else
color = 1.0 - 2.0 * (1.0 - a) * (1.0 - b);
#line 67
return lerp(a, color, w);
}
#line 70
}
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Unsharp.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\FXShadersCommon.fxh"
#line 9
namespace FXShaders
{
#line 16
static const float FloatEpsilon = 0.001;
#line 86
float2 GetResolution()
{
return float2(2560, 1377);
}
#line 94
float2 GetPixelSize()
{
return float2((1.0 / 2560), (1.0 / 1377));
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
#line 2 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Unsharp.fx"
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
#line 3 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Unsharp.fx"
#line 9
namespace FXShaders
{
#line 12
static const int BlurSamples =  21;
#line 14
uniform float Amount
<
ui_category = "Appearance";
ui_label = "Amount";
ui_type = "slider";
ui_min = 0.0;
ui_max = 1.0;
> = 1.0;
#line 23
uniform float BlurScale
<
ui_category = "Appearance";
ui_label = "Blur Scale";
ui_type = "slider";
ui_min = 0.01;
ui_max = 1.0;
> = 1.0;
#line 32
texture ColorTex : COLOR;
#line 34
sampler ColorSRGB
{
Texture = ColorTex;
#line 38
};
#line 40
sampler ColorLinear
{
Texture = ColorTex;
};
#line 45
texture OriginalTex
{
Width = 2560;
Height = 1377;
#line 53
};
#line 55
sampler Original
{
Texture = OriginalTex;
MinFilter = POINT;
MagFilter = POINT;
MipFilter = POINT;
};
#line 63
float4 Blur(sampler tex, float2 uv, float2 dir)
{
float4 color = GaussianBlur1D(
tex,
uv,
dir * GetPixelSize() * 3.0,
sqrt(BlurSamples) * BlurScale,
BlurSamples
);
#line 74
return color + abs(GetRandom(uv) - 0.5) * FloatEpsilon * 25.0;
}
#line 77
float4 CopyOriginalPS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return tex2D(ColorSRGB, uv);
}
#line 90
 float4 Blur0PS( float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET { return Blur(ColorSRGB, uv, float2(1.0,0.0)); };
#line 92
 float4 Blur1PS( float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET { return Blur(ColorLinear, uv, float2(0.0,4.0)); };
#line 94
 float4 Blur2PS( float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET { return Blur(ColorLinear, uv, float2(4.0,0.0)); };
#line 96
 float4 Blur3PS( float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET { return Blur(ColorLinear, uv, float2(0.0,1.0)); };
#line 98
float4 BlendPS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
const float4 color = tex2D(Original, uv);
#line 102
return float4(BlendOverlay(color.rgb, GetLumaGamma(1.0 - tex2D(ColorLinear, uv).rgb) * 0.75, Amount), color.a);
}
#line 105
technique Unsharp
{
pass CopyOriginal
{
VertexShader = ScreenVS;
PixelShader = CopyOriginalPS;
RenderTarget = OriginalTex;
}
pass Blur0
{
VertexShader = ScreenVS;
PixelShader = Blur0PS;
}
pass Blur1
{
VertexShader = ScreenVS;
PixelShader = Blur1PS;
}
pass Blur2
{
VertexShader = ScreenVS;
PixelShader = Blur2PS;
}
pass Blur3
{
VertexShader = ScreenVS;
PixelShader = Blur3PS;
}
pass Blend
{
VertexShader = ScreenVS;
PixelShader = BlendPS;
#line 138
}
}
#line 141
}

