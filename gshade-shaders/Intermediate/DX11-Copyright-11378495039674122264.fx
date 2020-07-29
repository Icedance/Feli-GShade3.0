#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\Copyright.fx"
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
#line 40 "C:\FFXIV\game\gshade-shaders\Shaders\Copyright.fx"
#line 58
uniform int cLayer_Select <
ui_label = "Copyright Selection";
ui_tooltip = "The image/texture you'd like to use.";
ui_type = "combo";
ui_items= "FFXIV\0"
"FFXIV Nalukai\0"
"FFXIV Yomi Black\0"
"FFXIV Yomi White\0"
"FFXIV With GShade Dark\0"
"FFXIV With GShade White\0"
"PSO2\0"
"PSO2 Century\0"
"PSO2 Schoolbell\0"
"PSO2 Helvetica Condensed\0"
"PSO2 with GShade Dark\0"
"PSO2 with GShade White\0"
"PSO2 Montserrat\0"
"PSO2 Montserrat Simple\0"
"PSO2 With Flat Logo\0"
"PSO2 Eurostile\0"
"PSO2 Metro No. 2 Cutout\0"
"PSO2 Kranky\0"
"PSO2 GN Fuyu-iro Script\0"
"PSO2 Sacramento\0"
"PSO2 Century Rectangle\0"
"PSO2 Eurostile Left\0"
"PSO2 Eurostile Right\0"
"PSO2 Eurostile Center\0"
"PSO2 Futura Center\0"
"PSO2 Neuzeit Grotesk\0"
"PSO2 Krona One\0"
"PSO2 Mouse Memories\0"
"PSO2 Swanky And Moo Moo\0"
"PSO2 Staccato555 A\0"
"PSO2 Staccato555 B\0"
"PSO2 PSO2 Lato Cutout\0"
"PSO2 Rockwell Nova\0"
"PSO2 Kabel Heavy\0"
"PSO2 Poiret One Small\0"
"PSO2 Poiret One Large\0"
"PSO2 Kranky Large\0"
"PSO2 Futura Triangle\0"
"PSO2 Helvetica Square\0"
"PSO2 Righteous\0"
"PSO2 Poppins\0"
"PSO2 Flat Logo\0"
"PSO2 Yanone Kaffeesatz A\0"
"PSO2 Yanone Kaffeesatz B\0";
ui_bind = "CopyrightTexture_Source";
> = 0;
#line 114
uniform int cLayer_BlendMode <
ui_type = "combo";
ui_label = "Blending Mode";
ui_tooltip = "Select the blending mode applied to the layer.";
ui_items = "Normal\0"
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
#line 149
uniform float cLayer_Blend <
ui_label = "Blending Amount";
ui_tooltip = "The amount of blending applied to the copyright layer.";
ui_type = "slider";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.001;
> = 1.0;
#line 158
uniform float cLayer_Scale <
ui_type = "slider";
ui_label = "Scale X & Y";
ui_min = 0.001; ui_max = 5.0;
ui_step = 0.001;
> = 1.001;
#line 165
uniform float cLayer_ScaleX <
ui_type = "slider";
ui_label = "Scale X";
ui_min = 0.001; ui_max = 5.0;
ui_step = 0.001;
> = 1.0;
#line 172
uniform float cLayer_ScaleY <
ui_type = "slider";
ui_label = "Scale Y";
ui_min = 0.001; ui_max = 5.0;
ui_step = 0.001;
> = 1.0;
#line 179
uniform float cLayer_PosX <
ui_type = "slider";
ui_label = "Position X";
ui_min = -2.0; ui_max = 2.0;
ui_step = 0.001;
> = 0.5;
#line 186
uniform float cLayer_PosY <
ui_type = "slider";
ui_label = "Position Y";
ui_min = -2.0; ui_max = 2.0;
ui_step = 0.001;
> = 0.5;
#line 193
uniform int cLayer_SnapRotate <
ui_type = "combo";
ui_label = "Snap Rotation";
ui_items = "None\0"
"90 Degrees\0"
"-90 Degrees\0"
"180 Degrees\0"
"-180 Degrees\0";
ui_tooltip = "Snap rotation to a specific angle.";
> = false;
#line 204
uniform float cLayer_Rotate <
ui_label = "Rotate";
ui_type = "slider";
ui_min = -180.0;
ui_max = 180.0;
ui_step = 0.01;
> = 0;
#line 351
texture Copyright_Texture <
source =  "CopyrightYWhH.png";
> {
Width = 2560;
Height = 1440;
Format = RGBA8;
};
sampler Copyright_Sampler {
Texture = Copyright_Texture;
AddressU = CLAMP;
AddressV = CLAMP;
};
#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\ReShade.fxh"
#line 368 "C:\FFXIV\game\gshade-shaders\Shaders\Copyright.fx"
#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\Blending.fxh"
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
#line 369 "C:\FFXIV\game\gshade-shaders\Shaders\Copyright.fx"
#line 371
void PS_cLayer(in float4 pos : SV_Position, float2 texCoord : TEXCOORD, out float4 passColor : SV_Target) {
const float3 pivot = float3(0.5, 0.5, 0.0);
const float AspectX = (1.0 - 2560 * (1.0 / 1440));
const float AspectY = (1.0 - 1440 * (1.0 / 2560));
const float3 mulUV = float3(texCoord.x, texCoord.y, 1);
const float2 ScaleSize = (float2( 1162.0, 135.0) * cLayer_Scale /  float2(2560, 1440));
const float ScaleX =  ScaleSize.x * AspectX * cLayer_ScaleX;
const float ScaleY =  ScaleSize.y * AspectY * cLayer_ScaleY;
float Rotate = cLayer_Rotate * (3.1415926 / 180.0);
#line 381
switch(cLayer_SnapRotate)
{
default:
break;
case 1:
Rotate = -90.0 * (3.1415926 / 180.0);
break;
case 2:
Rotate = 90.0 * (3.1415926 / 180.0);
break;
case 3:
Rotate = 0.0;
break;
case 4:
Rotate = 180.0 * (3.1415926 / 180.0);
break;
}
#line 399
const float3x3 positionMatrix = float3x3 (
1, 0, 0,
0, 1, 0,
-cLayer_PosX, -cLayer_PosY, 1
);
const float3x3 scaleMatrix = float3x3 (
1/ScaleX, 0, 0,
0,  1/ScaleY, 0,
0, 0, 1
);
const float3x3 rotateMatrix = float3x3 (
(cos (Rotate) * AspectX), (sin(Rotate) * AspectX), 0,
(-sin(Rotate) * AspectY), (cos(Rotate) * AspectY), 0,
0, 0, 1
);
#line 415
const float3 SumUV = mul (mul (mul (mulUV, positionMatrix), rotateMatrix), scaleMatrix);
const float4 backColor = tex2D(ReShade::BackBuffer, texCoord);
passColor = tex2D(Copyright_Sampler, SumUV.rg + pivot.rg) * all(SumUV + pivot == saturate(SumUV + pivot));
#line 419
switch (cLayer_BlendMode)
{
#line 422
default:
passColor = lerp(backColor.rgb, passColor.rgb, passColor.a * cLayer_Blend);
break;
#line 426
case 1:
passColor = lerp(backColor.rgb, Darken(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 430
case 2:
passColor = lerp(backColor.rgb, Multiply(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 434
case 3:
passColor = lerp(backColor.rgb, ColorBurn(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 438
case 4:
passColor = lerp(backColor.rgb, LinearBurn(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 442
case 5:
passColor = lerp(backColor.rgb, Lighten(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 446
case 6:
passColor = lerp(backColor.rgb, Screen(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 450
case 7:
passColor = lerp(backColor.rgb, ColorDodge(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 454
case 8:
passColor = lerp(backColor.rgb, LinearDodge(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 458
case 9:
passColor = lerp(backColor.rgb, Addition(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 462
case 10:
passColor = lerp(backColor.rgb, Glow(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 466
case 11:
passColor = lerp(backColor.rgb, Overlay(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 470
case 12:
passColor = lerp(backColor.rgb, SoftLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 474
case 13:
passColor = lerp(backColor.rgb, HardLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 478
case 14:
passColor = lerp(backColor.rgb, VividLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 482
case 15:
passColor = lerp(backColor.rgb, LinearLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 486
case 16:
passColor = lerp(backColor.rgb, PinLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 490
case 17:
passColor = lerp(backColor.rgb, HardMix(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 494
case 18:
passColor = lerp(backColor.rgb, Difference(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 498
case 19:
passColor = lerp(backColor.rgb, Exclusion(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 502
case 20:
passColor = lerp(backColor.rgb, Subtract(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 506
case 21:
passColor = lerp(backColor.rgb, Divide(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 510
case 22:
passColor = lerp(backColor.rgb, Reflect(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 514
case 23:
passColor = lerp(backColor.rgb, GrainMerge(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 518
case 24:
passColor = lerp(backColor.rgb, GrainExtract(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 522
case 25:
passColor = lerp(backColor.rgb, Hue(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 526
case 26:
passColor = lerp(backColor.rgb, Saturation(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 530
case 27:
passColor = lerp(backColor.rgb, ColorB(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
#line 534
case 28:
passColor = lerp(backColor.rgb, Luminosity(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
break;
}
#line 539
passColor.a = backColor.a;
}
#line 546
technique Copyright {
pass
{
VertexShader = PostProcessVS;
PixelShader  = PS_cLayer;
}
}

