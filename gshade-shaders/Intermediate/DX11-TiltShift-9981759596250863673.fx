#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\TiltShift.fx"
#line 18
uniform bool Line <
ui_label = "Show Center Line";
> = false;
#line 22
uniform int Axis <
ui_label = "Angle";
ui_type = "slider";
ui_step = 1;
ui_min = -89; ui_max = 90;
> = 0;
#line 29
uniform float Offset <
ui_type = "slider";
ui_min = -1.41; ui_max = 1.41; ui_step = 0.01;
> = 0.05;
#line 34
uniform float BlurCurve <
ui_label = "Blur Curve";
ui_type = "slider";
ui_min = 1.0; ui_max = 5.0; ui_step = 0.01;
ui_label = "Blur Curve";
> = 1.0;
uniform float BlurMultiplier <
ui_label = "Blur Multiplier";
ui_type = "slider";
ui_min = 0.0; ui_max = 100.0; ui_step = 0.2;
> = 6.0;
#line 46
uniform int BlurSamples <
ui_label = "Blur Samples";
ui_type = "slider";
ui_min = 2; ui_max = 32;
> = 11;
#line 53
texture TiltShiftTarget < pooled = true; > { Width = 1920; Height = 1080; Format = RGBA8; };
sampler TiltShiftSampler { Texture = TiltShiftTarget; };
#line 64
float get_weight(float t)
{
const float bottom = min(t, 0.5);
const float top = max(t, 0.5);
return 2.0 *(bottom*bottom +top +top -top*top) -1.5;
}
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ReShade.fxh"
#line 44
namespace ReShade
{
float GetAspectRatio() { return 1920 * (1.0 / 1080); }
float2 GetPixelSize() { return float2((1.0 / 1920), (1.0 / 1080)); }
float2 GetScreenSize() { return float2(1920, 1080); }
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
#line 75 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\TiltShift.fx"
#line 77
void TiltShiftPass1PS(float4 vpos : SV_Position, float2 UvCoord : TEXCOORD, out float4 Image : SV_Target)
{
#line 80
Image.rgb = tex2D(ReShade::BackBuffer, UvCoord).rgb;
#line 82
float2 UvCoordAspect = UvCoord;
UvCoordAspect.y += ReShade:: GetAspectRatio() * 0.5 - 0.5;
UvCoordAspect.y /= ReShade:: GetAspectRatio();
#line 86
UvCoordAspect = UvCoordAspect * 2.0 - 1.0;
#line 88
const float Angle = radians(-Axis);
const float2 TiltVector = float2(sin(Angle), cos(Angle));
#line 91
float BlurMask = abs(dot(TiltVector, UvCoordAspect) + Offset);
BlurMask = max(0.0, min(1.0, BlurMask));
#line 94
Image.a = BlurMask;
BlurMask = pow(Image.a, BlurCurve);
#line 98
if(BlurMask > 0)
{
#line 101
const float UvOffset = ReShade:: GetPixelSize().x *BlurMask *BlurMultiplier;
#line 103
float total_weight = 0.5;
#line 105
for (int i=1; i<BlurSamples; i++)
{
#line 108
const float current_sample = float(i)/float(BlurSamples);
#line 110
const float current_weight = get_weight(1.0-current_sample);
#line 112
total_weight += current_weight;
#line 114
const float SampleOffset = current_sample*11.0 * UvOffset; 
#line 116
Image.rgb += (
tex2Dlod( ReShade::BackBuffer, float4(float2(UvCoord.x+SampleOffset, UvCoord.y), 0.0, 0.0) ).rgb
+tex2Dlod( ReShade::BackBuffer, float4(float2(UvCoord.x-SampleOffset, UvCoord.y), 0.0, 0.0) ).rgb
) *current_weight;
}
#line 122
Image.rgb /= total_weight*2.0;
}
}
#line 126
void TiltShiftPass2PS(float4 vpos : SV_Position, float2 UvCoord : TEXCOORD, out float4 Image : SV_Target)
{
#line 129
Image = tex2D(TiltShiftSampler, UvCoord);
#line 131
float BlurMask = pow(abs(Image.a), BlurCurve);
#line 133
if(BlurMask > 0)
{
#line 136
const float UvOffset = ReShade:: GetPixelSize().y *BlurMask *BlurMultiplier;
#line 138
float total_weight = 0.5;
#line 140
for (int i=1; i<BlurSamples; i++)
{
#line 143
const float current_sample = float(i)/float(BlurSamples);
#line 145
const float current_weight = get_weight(1.0-current_sample);
#line 147
total_weight += current_weight;
#line 149
const float SampleOffset = current_sample*11.0 * UvOffset; 
#line 151
Image.rgb += (
tex2Dlod( TiltShiftSampler, float4(float2(UvCoord.x, UvCoord.y+SampleOffset), 0.0, 0.0) ).rgb
+tex2Dlod( TiltShiftSampler, float4(float2(UvCoord.x, UvCoord.y-SampleOffset), 0.0, 0.0) ).rgb
) *current_weight;
}
#line 157
Image.rgb /= total_weight*2.0;
}
#line 161
if (Line && Image.a < 0.01)
Image.rgb = float3(1.0, 0.0, 0.0);
}
#line 170
technique TiltShift < ui_label = "Tilt Shift"; >
{
pass AlphaAndHorizontalGaussianBlur
{
VertexShader = PostProcessVS;
PixelShader = TiltShiftPass1PS;
RenderTarget = TiltShiftTarget;
}
pass VerticalGaussianBlurAndRedLine
{
VertexShader = PostProcessVS;
PixelShader = TiltShiftPass2PS;
}
}

