#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Technicolor.fx"
#line 8
uniform float Power <
ui_type = "slider";
ui_min = 0.0; ui_max = 8.0;
> = 4.0;
uniform float3 RGBNegativeAmount <
ui_type = "color";
> = float3(0.88, 0.88, 0.88);
#line 16
uniform float Strength <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_tooltip = "Adjust the strength of the effect.";
> = 0.4;
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
#line 22 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Technicolor.fx"
#line 24
float3 TechnicolorPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
const float3 cyanfilter = float3(0.0, 1.30, 1.0);
const float3 magentafilter = float3(1.0, 0.0, 1.05);
const float3 yellowfilter = float3(1.6, 1.6, 0.05);
const float2 redorangefilter = float2(1.05, 0.620); 
const float2 greenfilter = float2(0.30, 1.0);       
const float2 magentafilter2 = magentafilter.rb;     
#line 33
const float3 tcol = tex2D(ReShade::BackBuffer, texcoord).rgb;
#line 35
const float2 negative_mul_r = tcol.rg * (1.0 / (RGBNegativeAmount.r * Power));
const float2 negative_mul_g = tcol.rg * (1.0 / (RGBNegativeAmount.g * Power));
const float2 negative_mul_b = tcol.rb * (1.0 / (RGBNegativeAmount.b * Power));
const float3 output_r = dot(redorangefilter, negative_mul_r).xxx + cyanfilter;
const float3 output_g = dot(greenfilter, negative_mul_g).xxx + magentafilter;
const float3 output_b = dot(magentafilter2, negative_mul_b).xxx + yellowfilter;
#line 42
return lerp(tcol, output_r * output_g * output_b, Strength);
}
#line 45
technique Technicolor
{
pass
{
VertexShader = PostProcessVS;
PixelShader = TechnicolorPass;
}
}

