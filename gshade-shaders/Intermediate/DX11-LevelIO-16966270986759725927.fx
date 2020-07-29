#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\LevelIO.fx"
#line 6
uniform float lin_bp <
ui_type = "slider";
ui_min = 0.0; ui_max = 255.0;
ui_step = 1.0;
ui_label = "input black point";
ui_tooltip = "black point for input";
> = 0.0;
uniform float lin_wp <
ui_type = "slider";
ui_min = 0.0; ui_max = 255.0;
ui_step = 1.0;
ui_label = "input white point";
ui_tooltip = "white point for input";
> = 255.0;
uniform float lin_g <
ui_type = "slider";
ui_min = 0.1; ui_max = 10.0;
ui_step = 0.10;
ui_label = "gamma";
> = 1.00;
uniform float lio_s <
ui_type = "slider";
ui_min = 0.0; ui_max = 2.0;
ui_step = 1.0;
ui_label = "saturation";
ui_tooltip = "0 - zero sat / 1 - real / 2 - x2 sat";
> = 1.00;
uniform float lout_bp <
ui_type = "slider";
ui_min = 0.0; ui_max = 255.0;
ui_step = 1.0;
ui_label = "output black point";
ui_tooltip = "black point for output";
> = 0.0;
uniform float lout_wp <
ui_type = "slider";
ui_min = 0.0; ui_max = 255.0;
ui_step = 1.0;
ui_label = "output white point";
ui_tooltip = "white point for output";
> = 255.0;
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
#line 48 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\LevelIO.fx"
#line 50
float3 LIOPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
#line 54
const float ib = lin_bp/255.0;
const float iw = lin_wp/255.0;
const float ob = lout_bp/255.0;
const float ow = lout_wp/255.0;
#line 59
color.rgb=min(max(color.rgb-ib, 0)/(iw-ib), 1);
#line 61
if(lin_g != 1) color.rgb=pow(abs(color.rgb), 1/lin_g);
color.rgb=min( max(color.rgb*(ow-ob)+ob, ob), ow);	
if (lio_s != 1)
{
const float cm=(color.r+color.g+color.b)/3;
color.rgb=cm-(cm-color.rgb)*lio_s;
}
#line 69
return color;
}
#line 73
technique LevelIO
{
pass
{
VertexShader = PostProcessVS;
PixelShader = LIOPass;
}
}
