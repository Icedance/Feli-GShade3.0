#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\CuttingTool_Depth.fx"
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
#line 9 "C:\FFXIV\game\gshade-shaders\Shaders\CuttingTool_Depth.fx"
#line 15
uniform float3 Point1 <
ui_label = "Point 1 (near)";
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_step = 0.00001;
> = 0.0;
#line 22
uniform float3 Point2 <
ui_label = "Point 2 (far)";
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_step = 0.00001;
> = 1.0;
#line 33
void PS_Main(float4 pos : SV_Position, float2 texCoord : TEXCOORD, out float4 frontColor : SV_Target)
{
const float3 gameCoord = float3(texCoord, ReShade::GetLinearizedDepth(texCoord));
frontColor = tex2D(ReShade::BackBuffer, texCoord);
frontColor.a = 1.0 - gameCoord.z;
frontColor *= step(1.0, 1.0 - (gameCoord - clamp(gameCoord, Point1, Point2)));
}
#line 45
technique CuttingTool_Depth <
ui_label = "Cutting Tool (Depth-based)";
> {
pass
{
VertexShader = PostProcessVS;
PixelShader = PS_Main;
}
}

