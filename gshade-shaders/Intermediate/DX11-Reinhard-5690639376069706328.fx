#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Reinhard.fx"
#line 6
uniform float ReinhardWhitepoint <
ui_type = "slider";
ui_min = 0.0; ui_max = 10.0;
ui_tooltip = "how steep the color curve is at linear point";
> = 1.250;
uniform float ReinhardScale <
ui_type = "slider";
ui_min = 0.0; ui_max = 3.0;
ui_tooltip = "how steep the color curve is at linear point";
> = 0.50;
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
#line 17 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Reinhard.fx"
#line 19
float3 ReinhardPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
#line 22
const float3 x = tex2D(ReShade::BackBuffer, texcoord).rgb;
const float W =  ReinhardWhitepoint;	
const float K =  ReinhardScale;        
#line 27
return (1 + K * x / (W * W)) * x / (x + K);
}
#line 30
technique Reinhard
{
pass
{
VertexShader = PostProcessVS;
PixelShader = ReinhardPass;
}
}

