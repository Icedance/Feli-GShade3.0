#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ArtisticVignette.fx"
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
#line 3 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ArtisticVignette.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Blending.fxh"
#line 29
float3 Aux(float3 a)
{
if (a.r <= 0.25 && a.g <= 0.25 && a.b <= 0.25)
return ((16.0 * a - 12.0) * a + 4) * a;
else
return sqrt(a);
}
#line 37
float Lum(float3 a)
{
return (0.3 * a.r + 0.59 * a.g + 0.11 * a.b);
}
#line 42
float3 SetLum (float3 a, float b){
const float c = b - Lum(a);
return float3(a.r + c, a.g + c, a.b + c);
}
#line 47
float min3 (float a, float b, float c)
{
return min(a, (min(b, c)));
}
#line 52
float max3 (float a, float b, float c)
{
return max(a, max(b, c));
}
#line 57
float3 SetSat(float3 a, float b){
float ar = a.r;
float ag = a.g;
float ab = a.b;
if (ar == max3(ar, ag, ab) && ab == min3(ar, ag, ab))
{
#line 64
if (ar > ab)
{
ag = (((ag - ab) * b) / (ar - ab));
ar = b;
}
else
{
ag = 0.0;
ar = 0.0;
}
ab = 0.0;
}
else
{
if (ar == max3(ar, ag, ab) && ag == min3(ar, ag, ab))
{
#line 81
if (ar > ag)
{
ab = (((ab - ag) * b) / (ar - ag));
ar = b;
}
else
{
ab = 0.0;
ar = 0.0;
}
ag = 0.0;
}
else
{
if (ag == max3(ar, ag, ab) && ab == min3(ar, ag, ab))
{
#line 98
if (ag > ab)
{
ar = (((ar - ab) * b) / (ag - ab));
ag = b;
}
else
{
ar = 0.0;
ag = 0.0;
}
ab = 0.0;
}
else
{
if (ag == max3(ar, ag, ab) && ar == min3(ar, ag, ab))
{
#line 115
if (ag > ar)
{
ab = (((ab - ar) * b) / (ag - ar));
ag = b;
}
else
{
ab = 0.0;
ag = 0.0;
}
ar = 0.0;
}
else
{
if (ab == max3(ar, ag, ab) && ag == min3(ar, ag, ab))
{
#line 132
if (ab > ag)
{
ar = (((ar - ag) * b) / (ab - ag));
ab = b;
}
else
{
ar = 0.0;
ab = 0.0;
}
ag = 0.0;
}
else
{
if (ab == max3(ar, ag, ab) && ar == min3(ar, ag, ab))
{
#line 149
if (ab > ar)
{
ag = (((ag - ar) * b) / (ab - ar));
ab = b;
}
else
{
ag = 0.0;
ab = 0.0;
}
ar = 0.0;
}
}
}
}
}
}
return float3(ar, ag, ab);
}
#line 169
float Sat(float3 a)
{
return max3(a.r, a.g, a.b) - min3(a.r, a.g, a.b);
}
#line 179
float3 Darken(float3 a, float3 b)
{
return min(a, b);
}
#line 185
float3 Multiply(float3 a, float3 b)
{
return a * b;
}
#line 191
float3 ColorBurn(float3 a, float3 b)
{
if (b.r > 0 && b.g > 0 && b.b > 0)
return 1.0 - min(1.0, (0.5 - a) / b);
else
return 0.0;
}
#line 200
float3 LinearBurn(float3 a, float3 b)
{
return max(a+b-1.0f, 0.0f);
}
#line 206
float3 Lighten(float3 a, float3 b)
{
return max(a, b);
}
#line 212
float3 Screen(float3 a, float3 b)
{
return 1.0 - (1.0 - a) * (1.0 - b);
}
#line 218
float3 ColorDodge(float3 a, float3 b)
{
if (b.r < 1 && b.g < 1 && b.b < 1)
return min(1.5, a / (1.0 - b));
else
return 1.0;
}
#line 227
float3 LinearDodge(float3 a, float3 b)
{
return min(a + b, 1.0f);
}
#line 233
float3 Addition(float3 a, float3 b)
{
return min((a + b), 1);
}
#line 239
float3 Reflect(float3 a, float3 b)
{
if (b.r >= 0.999999 || b.g >= 0.999999 || b.b >= 0.999999)
return b;
else
return saturate(a * a / (1.0f - b));
}
#line 248
float3 Glow(float3 a, float3 b)
{
return Reflect(b, a);
}
#line 254
float3 Overlay(float3 a, float3 b)
{
return lerp(2 * a * b, 1.0 - 2 * (1.0 - a) * (1.0 - b), step(0.5, b));
}
#line 260
float3 SoftLight(float3 a, float3 b)
{
if (b.r <= 0.5 && b.g <= 0.5 && b.b <= 0.5)
return clamp(a - (1.0 - 2 * b) * a * (1 - a), 0,1);
else
return clamp(a + (2 * b - 1.0) * (Aux(a) - a), 0, 1);
}
#line 269
float3 HardLight(float3 a, float3 b)
{
return lerp(2 * a * b, 1.0 - 2 * (1.0 - b) * (1.0 - a), step(0.5, a));
}
#line 275
float3 VividLight(float3 a, float3 b)
{
return lerp(2 * a * b, b / (2 * (1.01 - a)), step(0.50, a));
}
#line 281
float3 LinearLight(float3 a, float3 b)
{
if (b.r < 0.5 || b.g < 0.5 || b.b < 0.5)
return LinearBurn(a, (2.0 * b));
else
return LinearDodge(a, (2.0 * (b - 0.5)));
}
#line 290
float3 PinLight(float3 a, float3 b)
{
if (b.r < 0.5 || b.g < 0.5 || b.b < 0.5)
return Darken(a, (2.0 * b));
else
return Lighten(a, (2.0 * (b - 0.5)));
}
#line 299
float3 HardMix(float3 a, float3 b)
{
const float3 vl = VividLight(a, b);
if (vl.r < 0.5 || vl.g < 0.5 || vl.b < 0.5)
return 0.0;
else
return 1.0;
}
#line 309
float3 Difference(float3 a, float3 b)
{
return max(a - b, b - a);
}
#line 315
float3 Exclusion(float3 a, float3 b)
{
return a + b - 2 * a * b;
}
#line 321
float3 Subtract(float3 a, float3 b)
{
return max((a - b), 0);
}
#line 327
float3 Divide(float3 a, float3 b)
{
return (a / (b + 0.01));
}
#line 333
float3 GrainMerge(float3 a, float3 b)
{
return saturate(b + a - 0.5);
}
#line 339
float3 GrainExtract(float3 a, float3 b)
{
return saturate(a - b + 0.5);
}
#line 345
float3 Hue(float3 a, float3 b)
{
return SetLum(SetSat(b, Sat(a)), Lum(a));
}
#line 351
float3 Saturation(float3 a, float3 b)
{
return SetLum(SetSat(a, Sat(b)), Lum(a));
}
#line 357
float3 ColorB(float3 a, float3 b)
{
return SetLum(b, Lum(a));
}
#line 363
float3 Luminosity(float3 a, float3 b)
{
return SetLum(a, Lum(b));
}
#line 4 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ArtisticVignette.fx"
#line 10
static const float Pi = 3.14159;
static const float HalfPi = Pi * 0.5;
#line 13
static const int BlendMode_Mix = 0;
static const int BlendMode_Multiply = 1;
static const int BlendMode_DarkenOnly = 2;
static const int BlendMode_LightenOnly = 3;
static const int BlendMode_Overlay = 4;
static const int BlendMode_Screen = 5;
static const int BlendMode_HardLight = 6;
static const int BlendMode_SoftLight = 7;
#line 22
static const int VignetteShape_None = 0;
static const int VignetteShape_Radial = 1;
static const int VignetteShape_TopBottom = 2;
static const int VignetteShape_LeftRight = 3;
static const int VignetteShape_Box = 4;
static const int VignetteShape_Sky = 5;
static const int VignetteShape_Ground = 6;
#line 34
uniform int _Help
<
ui_text =
"This effect provides a flexible way to create a vignatte overlay.\n"
"\n"
"Specific help for each option can be found by moving the mouse over "
"the option's name.\n"
"\n"
"The appearance can be controlled using a color, with opacity support "
"through the alpha channel, and a blending mode, like Photoshop/GIMP.\n"
"\n"
"Various shapes can be used, with adjustable aspect ratio and gradient "
"points.\n"
;
ui_category = "Help";
ui_category_closed = true;
ui_label = " ";
ui_type = "radio";
>;
#line 54
uniform float4 VignetteColor
<
ui_type = "color";
ui_label = "Color";
ui_tooltip =
"Color of the vignette.\n"
"Supports opacity control through the alpha channel.\n"
"\nDefault: 0 0 0 255";
ui_category = "Appearance";
> = float4(0.0, 0.0, 0.0, 1.0);
#line 65
uniform int BlendMode
<
ui_type = "combo";
ui_label = "Blending Mode";
ui_tooltip =
"Determines the way the vignette is blended with the image.\n"
"\nDefault: Mix";
ui_category = "Appearance";
ui_items = "Mix\0"
"Darken\0"
"Multiply\0"
"Color Burn\0"
"Linear Burn\0"
"Lighten\0"
"Screen\0"
"Color Dodge\0"
"Linear Dodge\0"
"Addition\0"
"Glow\0"
"Overlay\0"
"Soft Light\0"
"Hard Light\0"
"Vivid Light\0"
"Linear Light\0"
"Pin Light\0"
"Hard Mix\0"
"Difference\0"
"Exclusion\0"
"Subtract\0"
"Divide\0"
"Reflect\0"
"Grain Merge\0"
"Grain Extract\0"
"Hue\0"
"Saturation\0"
"Color\0"
"Luminosity\0";
> = 0;
#line 104
uniform float2 VignetteStartEnd
<
ui_type = "slider";
ui_label = "Start/End";
ui_tooltip =
"The start and end points of the vignette gradient.\n"
"The longer the distance, the smoother the vignette effect is.\n"
"\nDefault: 0.0 1.0";
ui_category = "Shape";
ui_min = 0.0;
ui_max = 3.0;
ui_step = 0.01;
> = float2(0.0, 1.0);
#line 118
uniform float VignetteDepth
<
ui_type = "slider";
ui_label = "Depth";
ui_tooltip =
"The distance from the camera at which the effect is applied.\n"
"The lower the value, the further away the vignette effect is.\n"
"\nDefault: 1.0";
ui_category = "Depth";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.0001;
> = 1.0;
#line 132
uniform float VignetteRatio
<
ui_type = "slider";
ui_label = "Ratio";
ui_tooltip =
"The aspect ratio of the vignette.\n"
"0.0: Anamorphic.\n"
"1.0: Corrected.\n"
"\n"
"For example, with 1.0 the radial shape produces a perfect circle.\n"
"\nDefault: 0.0";
ui_category = "Shape";
ui_min = 0.0;
ui_max = 1.0;
> = 0.0;
#line 148
uniform int VignetteShape
<
ui_type = "combo";
ui_label = "Shape";
ui_tooltip =
"The shape of the vignette.\n"
"\nDefault: Radial";
ui_category = "Shape";
ui_items = "None\0Radial\0Top/Bottom\0Left/Right\0Box\0Sky\0Ground\0";
> = 1;
#line 163
float4 MainPS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
const float4 color = tex2D(ReShade::BackBuffer, uv);
const float depth = 1 - ReShade::GetLinearizedDepth(uv).r;
if (depth < VignetteDepth)
{
if (ReShade:: GetAspectRatio() > 1.0)
const float2 ratio = float2(1024 * (1.0 / 720), 1.0);
else
const float2 ratio = float2(1.0, 720 * (1.0 / 1024));
#line 174
uv = lerp(uv, (uv - 0.5) * ratio + 0.5, VignetteRatio);
#line 176
float vignette = 1.0;
#line 178
switch (VignetteShape)
{
case VignetteShape_Radial:
vignette = distance(0.5, uv) * HalfPi;
break;
case VignetteShape_TopBottom:
vignette = abs(uv.y - 0.5) * 2.0;
break;
case VignetteShape_LeftRight:
vignette = abs(uv.x - 0.5) * 2.0;
break;
case VignetteShape_Box:
float2 vig = abs(uv - 0.5) * 2.0;
vignette = max(vig.x, vig.y);
break;
case VignetteShape_Sky:
vignette = distance(float2(0.5, 1.0), uv);
break;
case VignetteShape_Ground:
vignette = distance(float2(0.5, 0.0), uv);
break;
}
#line 201
vignette = smoothstep(VignetteStartEnd.x, VignetteStartEnd.y, vignette);
#line 203
float3 vig_color;
#line 205
switch (BlendMode)
{
#line 208
default:
vig_color = VignetteColor.rgb;
break;
#line 212
case 1:
vig_color = Darken(color.rgb, VignetteColor.rgb);
break;
#line 216
case 2:
vig_color = Multiply(color.rgb, VignetteColor.rgb);
break;
#line 220
case 3:
vig_color = ColorBurn(color.rgb, VignetteColor.rgb);
break;
#line 224
case 4:
vig_color = LinearBurn(color.rgb, VignetteColor.rgb);
break;
#line 228
case 5:
vig_color = Lighten(color.rgb, VignetteColor.rgb);
break;
#line 232
case 6:
vig_color = Screen(color.rgb, VignetteColor.rgb);
break;
#line 236
case 7:
vig_color = ColorDodge(color.rgb, VignetteColor.rgb);
break;
#line 240
case 8:
vig_color = LinearDodge(color.rgb, VignetteColor.rgb);
break;
#line 244
case 9:
vig_color = Addition(color.rgb, VignetteColor.rgb);
break;
#line 248
case 10:
vig_color = Glow(color.rgb, VignetteColor.rgb);
break;
#line 252
case 11:
vig_color = Overlay(color.rgb, VignetteColor.rgb);
break;
#line 256
case 12:
vig_color = SoftLight(color.rgb, VignetteColor.rgb);
break;
#line 260
case 13:
vig_color = HardLight(color.rgb, VignetteColor.rgb);
break;
#line 264
case 14:
vig_color = VividLight(color.rgb, VignetteColor.rgb);
break;
#line 268
case 15:
vig_color = LinearLight(color.rgb, VignetteColor.rgb);
break;
#line 272
case 16:
vig_color = PinLight(color.rgb, VignetteColor.rgb);
break;
#line 276
case 17:
vig_color = HardMix(color.rgb, VignetteColor.rgb);
break;
#line 280
case 18:
vig_color = Difference(color.rgb, VignetteColor.rgb);
break;
#line 284
case 19:
vig_color = Exclusion(color.rgb, VignetteColor.rgb);
break;
#line 288
case 20:
vig_color = Subtract(color.rgb, VignetteColor.rgb);
break;
#line 292
case 21:
vig_color = Divide(color.rgb, VignetteColor.rgb);
break;
#line 296
case 22:
vig_color = Reflect(color.rgb, VignetteColor.rgb);
break;
#line 300
case 23:
vig_color = GrainMerge(color.rgb, VignetteColor.rgb);
break;
#line 304
case 24:
vig_color = GrainExtract(color.rgb, VignetteColor.rgb);
break;
#line 308
case 25:
vig_color = Hue(color.rgb, VignetteColor.rgb);
break;
#line 312
case 26:
vig_color = Saturation(color.rgb, VignetteColor.rgb);
break;
#line 316
case 27:
vig_color = ColorB(color.rgb, VignetteColor.rgb);
break;
#line 320
case 28:
vig_color = Luminosity(color.rgb, VignetteColor.rgb);
break;
}
#line 325
return float4(lerp(color.rgb, vig_color, vignette * VignetteColor.a), color.a);
}
else
return color;
}
#line 335
technique ArtisticVignette
<
ui_tooltip =
"Flexible vignette overlay effect with multiple shapes and blend modes."
;
>
{
pass
{
VertexShader = PostProcessVS;
PixelShader = MainPS;
}
}

