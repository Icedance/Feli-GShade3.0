#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ColorIsolation2.fx"
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
#line 40 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ColorIsolation2.fx"
#line 45
uniform float fUITargetHueTwo <
ui_type = "slider";
ui_category =  "Setup";
ui_label = "Target Hue";
ui_tooltip = "Set the desired hue.\nEnable \"Show Debug Overlay\" for visualization.";
ui_min = 0.0; ui_max = 360.0; ui_step = 0.5;
> = 0.0;
#line 53
uniform int cUIWindowFunctionTwo <
ui_type = "combo";
ui_category =  "Setup";
ui_label = "Window Function";
ui_items = "Gauss\0Triangle\0";
> = 0;
#line 60
uniform float fUIOverlapTwo <
ui_type = "slider";
ui_category =  "Setup";
ui_label = "Hue Overlap";
ui_tooltip = "Changes the width of the curve\nto include less or more colors in relation\nto the target hue.\n";
ui_min = 0.001; ui_max = 2.0;
ui_step = 0.001;
> = 0.3;
#line 69
uniform float fUIWindowHeightTwo <
ui_type = "slider";
ui_category =  "Setup";
ui_label = "Curve Steepness";
ui_min = 0.0; ui_max = 10.0;
ui_step = 0.01;
> = 1.0;
#line 77
uniform int iUITypeTwo <
ui_type = "combo";
ui_category =  "Setup";
ui_label = "Isolate / Reject Hue";
ui_items = "Isolate\0Reject\0";
> = 0;
#line 84
uniform bool bUIShowDiffTwo <
ui_category =  "Debug";
ui_label = "Show Hue Difference";
> = false;
#line 89
uniform bool bUIShowDebugOverlayTwo <
ui_label = "Show Debug Overlay";
ui_category =  "Debug";
> = false;
#line 94
uniform float2 fUIOverlayPosTwo <
ui_type = "slider";
ui_category =  "Debug";
ui_label = "Overlay: Position";
ui_min = 0.0; ui_max = 1.0;
ui_step = 0.01;
> = float2(0.0, 0.0);
#line 102
uniform int2 iUIOverlaySizeTwo <
ui_type = "slider";
ui_category =  "Debug";
ui_label = "Overlay: Size";
ui_tooltip = "x: width\nz: height";
ui_min = 50; ui_max = 2560;
ui_step = 1;
> = int2(600, 100);
#line 111
uniform float fUIOverlayOpacityTwo <
ui_type = "slider";
ui_category =  "Debug";
ui_label = "Overlay Opacity";
ui_min = 0.0; ui_max = 1.0;
ui_step = 0.01;
> = 1.0;
#line 121
float3 RGBtoHSVTwo(float3 c) {
const float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
#line 124
float4 p;
if (c.g < c.b)
p = float4(c.bg, K.wz);
else
p = float4(c.gb, K.xy);
#line 130
float4 q;
if (c.r < p.x)
q = float4(p.xyw, c.r);
else
q = float4(c.r, p.yzx);
#line 136
const float d = q.x - min(q.w, q.y);
const float e = 1.0e-10;
return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
#line 141
float3 HSVtoRGBTwo(float3 c) {
const float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
const float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
}
#line 147
float MapTwo(float value, float2 span_old, float2 span_new) {
float span_old_diff;
if (abs(span_old.y - span_old.x) < 1e-6)
span_old_diff = 1e-6;
else
span_old_diff = span_old.y - span_old.x;
return lerp(span_new.x, span_new.y, (clamp(value, span_old.x, span_old.y)-span_old.x)/(span_old_diff));
}
#line 159
float CalculateValueTwo(float x, float height, float offset, float overlap) {
float retVal;
#line 163
if(cUIWindowFunctionTwo == 0) {
#line 165
overlap /= 5.0;
retVal = saturate( (height * exp(-((x-1.0 - offset) * (x-1.0 - offset)) / (2 * overlap * overlap))) +  (height * exp(-((x - offset) * (x - offset)) / (2 * overlap * overlap))) +  (height * exp(-((x+1.0 - offset) * (x+1.0 - offset)) / (2 * overlap * overlap))));
}
else {
retVal = saturate( saturate(height * ((2 / overlap) * ((overlap / 2) - abs(x-1.0 - offset)))) +  saturate(height * ((2 / overlap) * ((overlap / 2) - abs(x - offset)))) +  saturate(height * ((2 / overlap) * ((overlap / 2) - abs(x+1.0 - offset)))));
}
#line 172
if(iUITypeTwo == 1)
return 1.0 - retVal;
#line 175
return retVal;
}
#line 178
float3 DrawDebugOverlayTwo(float3 background, float3 param, float2 pos, int2 size, float opacity, int2 vpos, float2 texcoord) {
float x, y, value, luma;
float3 overlay, hsvStrip;
#line 182
const float2 overlayPos = pos * ( float2(2560, 1377) - size);
#line 184
if(all(vpos.xy >= overlayPos) && all(vpos.xy < overlayPos + size))
{
x = MapTwo(texcoord.x, float2(overlayPos.x, overlayPos.x + size.x) / 2560, float2(0.0, 1.0));
y = MapTwo(texcoord.y, float2(overlayPos.y, overlayPos.y + size.y) / 1377, float2(0.0, 1.0));
hsvStrip = HSVtoRGBTwo(float3(x, 1.0, 1.0));
luma = dot(hsvStrip, float3(0.2126, 0.7151, 0.0721));
value = CalculateValueTwo(x, param.z, param.x, 1.0 - param.y);
overlay = lerp(luma.rrr, hsvStrip, value);
overlay = lerp(overlay, 0.0.rrr, exp(-size.y * length(float2(x, 1.0 - y) - float2(x, value))));
background = lerp(background, overlay, opacity);
}
#line 196
return background;
}
#line 199
float3 ColorIsolationTwoPS(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target {
const float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
const float3 luma = dot(color, float3(0.2126, 0.7151, 0.0721)).rrr;
const float3 param = float3(fUITargetHueTwo / 360.0, fUIOverlapTwo, fUIWindowHeightTwo);
const float value = CalculateValueTwo(RGBtoHSVTwo(color).x, param.z, param.x, 1.0 - param.y);
float3 retVal = lerp(luma, color, value);
#line 206
if(bUIShowDiffTwo)
retVal = value.rrr;
#line 209
if(bUIShowDebugOverlayTwo)
{
retVal = DrawDebugOverlayTwo(retVal, param, fUIOverlayPosTwo, iUIOverlaySizeTwo, fUIOverlayOpacityTwo, vpos.xy, texcoord);
}
#line 214
return retVal;
}
#line 217
technique ColorIsolation2 {
pass {
VertexShader = PostProcessVS;
PixelShader = ColorIsolationTwoPS;
#line 222
}
}
