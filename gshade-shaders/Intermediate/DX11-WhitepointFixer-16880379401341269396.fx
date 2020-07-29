#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\WhitepointFixer.fx"
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
#line 3 "C:\FFXIV\game\gshade-shaders\Shaders\WhitepointFixer.fx"
#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\FXShadersCommon.fxh"
#line 9
namespace FXShaders
{
#line 16
static const float FloatEpsilon = 0.001;
#line 86
float2 GetResolution()
{
return float2(2560, 1440);
}
#line 94
float2 GetPixelSize()
{
return float2((1.0 / 2560), (1.0 / 1440));
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
#line 4 "C:\FFXIV\game\gshade-shaders\Shaders\WhitepointFixer.fx"
#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\FXShadersMath.fxh"
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
#line 5 "C:\FFXIV\game\gshade-shaders\Shaders\WhitepointFixer.fx"
#line 25
namespace FXShaders
{
#line 30
static const float2 ShowWhitepointSize = 300.0;
#line 85
uniform int _Help < ui_text =
"The different modes can be used by setting WHITEPOINT_FIXER_MODE to:\n"
"  0: Manual color selection, using a parameter.\n"
"  1: Use a color picker on the image to select the whitepoint color.\n"
"  2: Automatically try to guess the whitepoint by finding the brightest "
"color in the image.\n"
#line 67
; ui_category = "Help"; ui_category_closed = true; ui_label = " "; ui_type = "radio"; >;
#line 69
uniform int WhitepointFixerMode
<
ui_type = "combo";
ui_label = "Whitepoint Fixer Mode";
ui_items = 	"Manual\0Color Select\0Automatic\0";
ui_bind = "WHITEPOINT_FIXER_MODE";
> = 0;
#line 79
uniform float Whitepoint
<
ui_type = "slider";
ui_tooltip =
"Manual whitepoint value.\n"
"\nDefault: 1.0";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 1.0 / 255.0;
> = 1.0;
#line 250
float GetWhitepoint()
{
#line 253
return Whitepoint;
#line 259
}
#line 264
float Contains(float size, float a, float b)
{
return step(a - size, b) * step(b, a + size);
}
#line 345
float4 MainPS(
float4 pos : SV_POSITION,
float2 uv : TEXCOORD) : SV_TARGET
{
#line 350
const float2 res = GetResolution();
const float2 coord = uv * res;
#line 353
float4 color = tex2D(ReShade::BackBuffer, uv);
const float whitepoint = GetWhitepoint();
color.rgb /= max(whitepoint, 1e-6);
#line 398
return color;
}
#line 405
technique WhitepointerFixer
{
#line 440
pass Main
{
VertexShader = PostProcessVS;
PixelShader = MainPS;
}
}
#line 449
}

