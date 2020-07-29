#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\WinUaeMaskGlow.fx"
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
#line 21 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\WinUaeMaskGlow.fx"
#line 23
uniform int shadowMask <
ui_type = "slider";
ui_min = -1; ui_max = 10;
ui_label = "CRT Mask Type";
ui_tooltip = "CRT Mask Type";
> = 0;
#line 30
uniform float MaskGamma <
ui_type = "slider";
ui_min = 1.0; ui_max = 3.0;
ui_label = "Mask Gamma";
ui_tooltip = "Mask Gamma";
> = 2.2;
#line 37
uniform float CGWG <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Mask 0,1,2,3 Strength";
ui_tooltip = "Mask 0,1,2,3 Strength";
> = 0.33;
#line 44
uniform float maskDark <
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
ui_label = "Mask Dark";
ui_tooltip = "Mask Dark";
> = 0.50;
#line 51
uniform float maskLight <
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
ui_label = "Mask Light";
ui_tooltip = "Mask Light";
> = 1.40;
#line 58
uniform float slotmask <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Slotmask Strength";
ui_tooltip = "Slotmask Strength";
> = 0.0;
#line 65
uniform int slotwidth <
ui_type = "slider";
ui_min = 2; ui_max = 6;
ui_label = "Slot Mask Width";
ui_tooltip = "Slot Mask Width";
> = 2;
#line 72
uniform int masksize <
ui_type = "slider";
ui_min = 1; ui_max = 2;
ui_label = "CRT Mask Size";
ui_tooltip = "CRT Mask Size";
> = 1;
#line 79
uniform int smasksize <
ui_type = "slider";
ui_min = 1; ui_max = 2;
ui_label = "Slot Mask Size";
ui_tooltip = "Slot Mask Size";
> = 1;
#line 86
uniform float bloom <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Bloom Strength";
ui_tooltip = "Bloom Strength";
> = 0.0;
#line 93
uniform float glow <
ui_type = "slider";
ui_min = 0.0; ui_max = 0.25;
ui_label = "Glow Strength";
ui_tooltip = "Glow Strength";
> = 0.0;
#line 101
uniform float glow_size <
ui_type = "slider";
ui_min = 0.5; ui_max = 6.0;
ui_label = "Glow Size";
ui_tooltip = "Glow Size";
> = 1.0;
#line 110
texture Shinra01L  { Width = 2560; Height = 1377; Format = RGBA16F; };
sampler Shinra01SL { Texture = Shinra01L; MinFilter = Linear; MagFilter = Linear; };
#line 113
texture Shinra02L  { Width = 2560; Height = 1377; Format = RGBA8; };
sampler Shinra02SL { Texture = Shinra02L; MinFilter = Linear; MagFilter = Linear; };
#line 116
texture Shinra03L  { Width = 2560; Height = 1377; Format = RGBA8; };
sampler Shinra03SL { Texture = Shinra03L; MinFilter = Linear; MagFilter = Linear; };
#line 120
float4 PASS_SH0(float4 pos : SV_Position, float2 uv : TexCoord) : SV_Target
{
return float4 (pow(tex2D(ReShade::BackBuffer, uv).rgb, float3(1.0, 1.0, 1.0) * MaskGamma),1.0);
}
#line 126
float4 PASS_SH1(float4 pos : SV_Position, float2 uv : TexCoord) : SV_Target
{
float4 color = tex2D(Shinra01SL, uv) * 0.382925;
color += tex2D(Shinra01SL, uv + float2(1.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.241730;
color += tex2D(Shinra01SL, uv - float2(1.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.241730;
color += tex2D(Shinra01SL, uv + float2(2.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.060598;
color += tex2D(Shinra01SL, uv - float2(2.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.060598;
color += tex2D(Shinra01SL, uv + float2(3.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.005977;
color += tex2D(Shinra01SL, uv - float2(3.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.005977;
color += tex2D(Shinra01SL, uv + float2(4.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.000229;
color += tex2D(Shinra01SL, uv - float2(4.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.000229;
color += tex2D(Shinra01SL, uv + float2(5.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.000003;
color += tex2D(Shinra01SL, uv - float2(5.0*glow_size * ReShade:: GetPixelSize().x, 0.0)) * 0.000003;
#line 140
return color;
}
#line 143
float4 PASS_SH2(float4 pos : SV_Position, float2 uv : TexCoord) : SV_Target
{
float4 color = tex2D(Shinra02SL, uv) * 0.382925;
color += tex2D(Shinra02SL, uv + float2(0.0, 1.0*glow_size * ReShade:: GetPixelSize().y)) * 0.241730;
color += tex2D(Shinra02SL, uv - float2(0.0, 1.0*glow_size * ReShade:: GetPixelSize().y)) * 0.241730;
color += tex2D(Shinra02SL, uv + float2(0.0, 2.0*glow_size * ReShade:: GetPixelSize().y)) * 0.060598;
color += tex2D(Shinra02SL, uv - float2(0.0, 2.0*glow_size * ReShade:: GetPixelSize().y)) * 0.060598;
color += tex2D(Shinra02SL, uv + float2(0.0, 3.0*glow_size * ReShade:: GetPixelSize().y)) * 0.005977;
color += tex2D(Shinra02SL, uv - float2(0.0, 3.0*glow_size * ReShade:: GetPixelSize().y)) * 0.005977;
color += tex2D(Shinra02SL, uv + float2(0.0, 4.0*glow_size * ReShade:: GetPixelSize().y)) * 0.000229;
color += tex2D(Shinra02SL, uv - float2(0.0, 4.0*glow_size * ReShade:: GetPixelSize().y)) * 0.000229;
color += tex2D(Shinra02SL, uv + float2(0.0, 5.0*glow_size * ReShade:: GetPixelSize().y)) * 0.000003;
color += tex2D(Shinra02SL, uv - float2(0.0, 5.0*glow_size * ReShade:: GetPixelSize().y)) * 0.000003;
#line 157
return color;
}
#line 165
float3 Mask(float2 pos, float3 c)
{
pos = floor(pos/float(masksize));
float3 mask = float3(maskDark, maskDark, maskDark);
float mc;
float mx;
float fTemp;
float adj;
#line 175
switch (shadowMask)
{
case -1:
mask = float3(1.0,1.0,1.0);
break;
#line 181
case 0:
pos.x = frac(pos.x*0.5);
mc = 1.0 - CGWG;
if (pos.x < 0.5) { mask.r = 1.1; mask.g = mc; mask.b = 1.1; }
else { mask.r = mc; mask.g = 1.1; mask.b = mc; }
break;
#line 188
case 1:
pos.x = frac(pos.x/3.0);
mc = 1.1 - CGWG;
mask = float3(mc, mc, mc);
#line 193
if      (pos.x < 0.333) mask.r = 1.0;
else if (pos.x < 0.666) mask.g = 1.0;
else                    mask.b = 1.0;
break;
#line 198
case 2:
pos.x = frac(pos.x*0.5);
mc = 1.0 - CGWG;
if (pos.x < 0.5) { mask.r = 1.1; mask.g = mc; mask.b = 1.1; }
else { mask.r = mc; mask.g = 1.1; mask.b = mc; }
break;
#line 205
case 3:
pos.x = frac((pos.x + pos.y)*0.5);
mc = 1.0 - CGWG;
if (pos.x < 0.5) { mask.r = 1.1; mask.g = mc; mask.b = 1.1; }
else { mask.r = mc; mask.g = 1.1; mask.b = mc; }
break;
#line 212
case 4:
float line1 = maskLight;
float odd  = 0.0;
#line 216
if (frac(pos.x/6.0) < 0.5)
odd = 1.0;
if (frac((pos.y + odd)/2.0) < 0.5)
line1 = maskDark;
#line 221
pos.x = frac(pos.x/3.0);
#line 223
if      (pos.x < 0.333) mask.r = maskLight;
else if (pos.x < 0.666) mask.g = maskLight;
else                    mask.b = maskLight;
#line 227
mask*=line1;
break;
#line 230
case 5:
pos.x = frac(pos.x/3.0);
#line 233
if      (pos.x < 0.333) mask.r = maskLight;
else if (pos.x < 0.666) mask.g = maskLight;
else                    mask.b = maskLight;
break;
#line 238
case 6:
pos.x += pos.y*3.0;
pos.x  = frac(pos.x/6.0);
#line 242
if      (pos.x < 0.333) mask.r = maskLight;
else if (pos.x < 0.666) mask.g = maskLight;
else                    mask.b = maskLight;
break;
#line 247
case 7:
pos.xy = floor(pos.xy*float2(1.0, 0.5));
pos.x += pos.y*3.0;
pos.x  = frac(pos.x/6.0);
#line 252
if      (pos.x < 0.333) mask.r = maskLight;
else if (pos.x < 0.666) mask.g = maskLight;
else                    mask.b = maskLight;
break;
#line 257
case 8:
mx = max(max(c.r,c.g),c.b);
fTemp = min( 1.25*max(mx-0.25,0.0)/(1.0-0.25) ,maskDark + 0.2*(1.0-maskDark)*mx);
adj = 0.80*maskLight - 0.5*(0.80*maskLight - 1.0)*mx + 0.75*(1.0-mx);
mask = float3(fTemp,fTemp,fTemp);
pos.x = frac(pos.x/2.0);
if  (pos.x < 0.5)
{	mask.r  = adj;
mask.b  = adj;
}
else     mask.g = adj;
break;
#line 270
case 9:
mx = max(max(c.r,c.g),c.b);
fTemp = min( 1.33*max(mx-0.25,0.0)/(1.0-0.25) ,maskDark + 0.225*(1.0-maskDark)*mx);
adj = 0.80*maskLight - 0.5*(0.80*maskLight - 1.0)*mx + 0.75*(1.0-mx);
mask = float3(fTemp,fTemp,fTemp);
pos.x = frac(pos.x/3.0);
if      (pos.x < 0.333) mask.r = adj;
else if (pos.x < 0.666) mask.g = adj;
else                    mask.b = adj;
break;
#line 281
case 10:
mx = max(max(c.r,c.g),c.b);
const float maskTmp = min(1.6*max(mx-0.25,0.0)/(1.0-0.25) ,1.0 + 0.6*(1.0-mx));
mask = float3(maskTmp,maskTmp,maskTmp);
pos.x = frac(pos.x/2.0);
const float mTemp = 1.0 + 0.6*(1.0-mx);
if  (pos.x < 0.5) mask = float3(mTemp,mTemp,mTemp);
break;
}
#line 291
return mask;
}
#line 295
float SlotMask(float2 pos, float3 c)
{
if (slotmask == 0.0) return 1.0;
#line 299
pos = floor(pos/float(smasksize));
#line 301
const float mx = pow(max(max(c.r,c.g),c.b),1.33);
const float px = frac(pos.x/(float(slotwidth)*2.0));
const float py = floor(frac(pos.y/(2.0*  1.00     ))*2.0*  1.00     );
const float slot_dark = lerp(1.0-slotmask, 1.0-0.80*slotmask, mx);
float slot = 1.0 + 0.7*slotmask*(1.0-mx);
if (py == 0.0 && px <  0.5) slot = slot_dark; else
if (py ==   1.00      && px >= 0.5) slot = slot_dark;
#line 309
return slot;
}
#line 313
float3 WMASK(float4 pos : SV_Position, float2 uv : TexCoord) : SV_Target
{
float3 color = tex2D(Shinra01SL, uv).rgb;
const float3 b11 = tex2D(Shinra03SL, uv).rgb;
#line 318
const float2 pos1 = floor(uv/ReShade:: GetPixelSize());
#line 320
const float3 cmask = Mask(pos1, pow(color, float3(1.0,1.0,1.0)/MaskGamma));
#line 322
const float3 orig1 = color;
#line 324
if (shadowMask == 0 || shadowMask == 1 || shadowMask == 3) color = pow(color, float3(1.0,1.0,1.0)/MaskGamma);
#line 326
color*=cmask;
#line 328
if (shadowMask == 0 || shadowMask == 1 || shadowMask == 3) color = pow(color, float3(1.0,1.0,1.0)*MaskGamma);
#line 330
color = min(color, 1.0);
#line 332
color*=SlotMask(pos1, color);
#line 334
float3 Bloom1 = 2.0*b11*b11;
Bloom1 = min(Bloom1, 0.75);
Bloom1 = min(Bloom1, 0.85*max(max(Bloom1.r,Bloom1.g),Bloom1.b))/0.85;
#line 338
Bloom1 = lerp(min( Bloom1, color), Bloom1, 0.5*(orig1+color));
#line 340
Bloom1 = bloom*Bloom1;
#line 342
color = color + Bloom1;
color = color + glow*b11;
#line 345
color = min(color, 1.0);
#line 347
color = min(color, lerp(min(cmask,1.0),float3(1.0,1.0,1.0),0.6));
#line 349
color = pow(color, float3(1.0,1.0,1.0)/MaskGamma);
#line 351
return color;
}
#line 354
technique WinUaeMask
{
#line 357
pass bloom1
{
VertexShader = PostProcessVS;
PixelShader = PASS_SH0;
RenderTarget = Shinra01L;
}
#line 364
pass bloom2
{
VertexShader = PostProcessVS;
PixelShader = PASS_SH1;
RenderTarget = Shinra02L;
}
#line 371
pass bloom3
{
VertexShader = PostProcessVS;
PixelShader = PASS_SH2;
RenderTarget = Shinra03L;
}
#line 378
pass mask
{
VertexShader = PostProcessVS;
PixelShader = WMASK;
}
}

