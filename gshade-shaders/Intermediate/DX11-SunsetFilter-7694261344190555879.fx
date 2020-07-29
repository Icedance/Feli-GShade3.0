#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\SunsetFilter.fx"
#line 11
uniform float3 ColorA <
ui_label = "Colour (A)";
ui_type = "color";
ui_category = "Colors";
> = float3(1.0, 0.0, 0.0);
#line 17
uniform float3 ColorB <
ui_label = "Colour (B)";
ui_type = "color";
ui_category = "Colors";
> = float3(0.0, 0.0, 0.0);
#line 23
uniform bool Flip <
ui_label = "Color flip";
ui_category = "Colors";
> = false;
#line 28
uniform int Axis <
ui_label = "Angle";
ui_type = "slider";
ui_step = 1;
ui_min = -180; ui_max = 180;
ui_category = "Controls";
> = -7;
#line 36
uniform float Scale <
ui_label = "Gradient sharpness";
ui_type = "slider";
ui_min = 0.5; ui_max = 1.0; ui_step = 0.005;
ui_category = "Controls";
> = 1.0;
#line 43
uniform float Offset <
ui_label = "Position";
ui_type = "slider";
ui_step = 0.002;
ui_min = 0.0; ui_max = 0.5;
ui_category = "Controls";
> = 0.0;
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
#line 51 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\SunsetFilter.fx"
#line 54
float Overlay(float Layer)
{
const float Min = min(Layer, 0.5);
const float Max = max(Layer, 0.5);
return 2 * (Min * Min + 2 * Max - Max * Max) - 1.5;
}
#line 62
float3 Screen(float3 LayerA, float3 LayerB)
{ return 1.0 - (1.0 - LayerA) * (1.0 - LayerB); }
#line 65
void SunsetFilterPS(float4 vpos : SV_Position, float2 UvCoord : TEXCOORD, out float3 Image : SV_Target)
{
#line 68
Image.rgb = tex2D(ReShade::BackBuffer, UvCoord).rgb;
#line 70
float2 UvCoordAspect = UvCoord;
UvCoordAspect.y +=  (1024 * (1.0 / 720)) * 0.5 - 0.5;
UvCoordAspect.y /=  (1024 * (1.0 / 720));
#line 74
UvCoordAspect = UvCoordAspect * 2 - 1;
UvCoordAspect *= Scale;
#line 78
const float Angle = radians(-Axis);
const float2 TiltVector = float2(sin(Angle), cos(Angle));
#line 82
float BlendMask = dot(TiltVector, UvCoordAspect) + Offset;
BlendMask = Overlay(BlendMask * 0.5 + 0.5); 
#line 86
if (Flip)
Image = Screen(Image.rgb, lerp(ColorA.rgb, ColorB.rgb, 1 - BlendMask));
else
Image = Screen(Image.rgb, lerp(ColorA.rgb, ColorB.rgb, BlendMask));
}
#line 92
technique SunsetFilter
{
pass
{
VertexShader = PostProcessVS;
PixelShader = SunsetFilterPS;
}
}

