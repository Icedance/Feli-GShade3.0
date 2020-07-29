#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\SCurve.fx"
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
#line 2 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\SCurve.fx"
#line 4
uniform float fCurve <
ui_label = "Curve";
ui_type = "slider";
ui_min = 1.0;
ui_max = 3.0;
ui_step = 0.001;
> = 1.0;
#line 12
uniform float4 f4Offsets <
ui_label = "Offsets";
ui_tooltip = "{ Low Color, High Color, Both, Unused }";
ui_type = "slider";
ui_min = -1.0;
ui_max = 1.0;
ui_step = 0.001;
> = float4(0.0, 0.0, 0.0, 0.0);
#line 21
float4 PS_SCurve(
const float4 pos : SV_POSITION,
const float2 uv : TEXCOORD
) : SV_TARGET {
float3 col = tex2D(ReShade::BackBuffer, uv).rgb;
const float lum = max(col.r, max(col.g, col.b));
#line 30
const float3 low = pow(abs(col), fCurve) + f4Offsets.x;
const float3 high = pow(abs(col), 1.0 / fCurve) + f4Offsets.y;
#line 33
col.r = lerp(low.r, high.r, col.r + f4Offsets.z);
col.g = lerp(low.g, high.g, col.g + f4Offsets.z);
col.b = lerp(low.b, high.b, col.b + f4Offsets.z);
#line 37
return float4(col, 1.0);
}
#line 40
technique SCurve {
pass {
VertexShader = PostProcessVS;
PixelShader = PS_SCurve;
}
}

