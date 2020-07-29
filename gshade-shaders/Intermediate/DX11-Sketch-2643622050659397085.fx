#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Sketch.fx"
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
#line 14 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Sketch.fx"
#line 44
static const int SmoothingSamples =  5;
static const float SmoothingSamplesInv = 1.0 / SmoothingSamples;
static const float SmoothingSamplesHalf = SmoothingSamples / 2;
#line 48
static const float2 ZeroOne = float2(0.0, 1.0);
#line 69
sampler SRGBBackBuffer
{
Texture = ReShade::BackBufferTex;
SRGBTexture = true;
};
#line 96
uniform float4 PatternColor
<
ui_type = "color";
ui_label = "Pattern Color";
ui_tooltip = "Default: 255 255 255 16";
> = float4(255, 255, 255, 16) / 255;
#line 103
uniform float2 PatternRange
<
ui_type = "slider";
ui_label = "Pattern Range";
ui_tooltip = "Default: 0.0 0.5";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.01;
> = float2(0.0, 0.5);
#line 113
uniform float OutlineThreshold
<
ui_type = "slider";
ui_label = "Outline Threshold";
ui_tooltip = "Default: 0.01";
ui_min = 0.001;
ui_max = 0.1;
ui_step = 0.001;
> = 0.01;
#line 123
uniform float Posterization
<
ui_type = "slider";
ui_tooltip = "Default: 5";
ui_min = 1;
ui_max = 255;
ui_step = 1;
> = 5;
#line 134
uniform float SmoothingScale
<
ui_type = "slider";
ui_label = "Smoothing Scale";
ui_tooltip = "Default: 1.0";
ui_min = 1.0;
ui_max = 10.0;
ui_step = 0.01;
> = 1.0;
#line 162
float get_depth(float2 uv)
{
return ReShade::GetLinearizedDepth(uv);
}
#line 167
float3 get_normals(float2 uv)
{
const float3 ps = float3(ReShade:: GetPixelSize(), 0.0);
#line 171
float3 normals;
normals.x = get_depth(uv - ps.xz) - get_depth(uv + ps.xz);
normals.y = get_depth(uv + ps.zy) - get_depth(uv - ps.zy);
normals.z = get_depth(uv);
#line 176
normals.xy = abs(normals.xy) * 0.5 * ReShade:: GetScreenSize();
normals = normalize(normals);
#line 179
return normals;
}
#line 182
float get_outline(float2 uv)
{
return step(OutlineThreshold, dot(get_normals(uv), float3(0.0, 0.0, 1.0)));
}
#line 187
float get_pattern(float2 uv)
{
#line 197
float x = uv.x + uv.y;
x = abs(x);
x %= 0.0125;
x /= 0.0125;
x = abs((x - 0.5) * 2.0);
x = step(0.5, x);
#line 204
return x;
#line 206
}
#line 208
float3 test_palette(float3 color, float2 uv)
{
const float2 bw = float2(1.0, 0.0);
uv.y = 1.0 - uv.y;
uv.y *= 20.0;
#line 214
return (uv.y < 0.333)
? uv.x * bw.xyy
: (uv.y < 0.666)
? uv.x * bw.yxy
: (uv.y < 1.0)
? uv.x * bw.yyx
: color;
}
#line 223
float3 cel_shade(float3 color, out float gray)
{
gray = dot(color, 0.333);
color -= gray;
#line 228
gray *= Posterization;
gray = round(gray);
gray /= Posterization;
#line 232
color += gray;
return color;
}
#line 238
float3 blur_old(sampler s, float2 uv, float2 dir)
{
dir *= SmoothingScale;
#line 242
uv -= SmoothingSamplesHalf * dir;
float3 color = tex2D(s, uv).rgb;
#line 245
[unroll]
for (int i = 1; i < SmoothingSamples; ++i)
{
uv += dir;
color += tex2D(s, uv).rgb;
}
#line 252
color *= SmoothingSamplesInv;
return color;
}
#line 256
float3 blur_depth_threshold(sampler s, float2 uv, float2 dir)
{
dir *= SmoothingScale;
#line 260
float depth = get_depth(uv);
#line 262
uv -= SmoothingSamplesHalf * dir;
float4 color = 0.0;
#line 265
[unroll]
for (int i = 0; i < SmoothingSamples; ++i)
{
float z = get_depth(uv);
if (abs(z - depth) < 0.001)
color += float4(tex2D(s, uv).rgb, 1.0);
#line 272
uv += dir;
}
#line 275
color.rgb /= color.a;
return color.rgb;
}
#line 279
float3 blur(sampler s, float2 uv, float2 dir)
{
dir *= SmoothingScale;
#line 283
const float3 center = tex2D(s, uv).rgb;
#line 285
uv -= SmoothingSamplesHalf * dir;
float4 color = 0.0;
#line 288
[unroll]
for (int i = 0; i < SmoothingSamples; ++i)
{
float3 pixel = tex2D(s, uv).rgb;
float delta = dot(1.0 - abs(pixel - center), 0.333);
#line 294
if (delta > 0.9		)
color += float4(pixel, 1.0);
}
#line 298
color.rgb /= color.a;
return color.rgb;
}
#line 310
float4 BlurXPS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return float4(blur(SRGBBackBuffer, uv, float2((1.0 / 2560), 0.0)), 1.0);
}
#line 315
float4 BlurYPS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
return float4(blur(ReShade::BackBuffer, uv, float2(0.0, (1.0 / 1440))), 1.0);
}
#line 322
void MainVS(
uint id : SV_VERTEXID,
out float4 p : SV_POSITION,
out float2 uv : TEXCOORD0,
out float2 pattern_uv : TEXCOORD1)
{
PostProcessVS(id, p, uv);
#line 330
pattern_uv = uv;
pattern_uv.x *= ReShade:: GetAspectRatio();
}
#line 334
float4 MainPS(
float4 p : SV_POSITION,
float2 uv : TEXCOORD0,
float2 pattern_uv : TEXCOORD1) : SV_TARGET
{
float4 color = tex2D(ReShade::BackBuffer, uv);
#line 352
float gray;
color.rgb = cel_shade(color.rgb, gray);
#line 355
float pattern = get_pattern(pattern_uv);
pattern *= 1.0 - smoothstep(PatternRange.x, PatternRange.y, gray);
pattern *= (1.0 - gray) * PatternColor.a;
color.rgb = lerp(color.rgb, PatternColor.rgb, pattern);
#line 360
float outline = get_outline(uv);
color.rgb *= outline;
#line 363
return color;
}
#line 370
technique Sketch
{
#line 373
pass BlurX
{
VertexShader = PostProcessVS;
PixelShader = BlurXPS;
}
pass BlurY
{
VertexShader = PostProcessVS;
PixelShader = BlurYPS;
SRGBWriteEnable = true;
}
#line 385
pass Main
{
VertexShader = MainVS;
PixelShader = MainPS;
}
}

