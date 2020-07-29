#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\AspectRatio.fx"
#line 5
uniform float A <
ui_type = "slider";
ui_label = "Correct proportions";
ui_category = "Aspect ratio";
ui_min = -1.0; ui_max = 1.0;
> = 0.0;
#line 12
uniform float Zoom <
ui_type = "slider";
ui_label = "Scale image";
ui_category = "Aspect ratio";
ui_min = 1.0; ui_max = 1.5;
> = 1.0;
#line 19
uniform bool FitScreen <
ui_label = "Scale image to borders";
ui_category = "Borders";
> = true;
#line 24
uniform bool UseBackground <
ui_label = "Use background image";
ui_category = "Borders";
> = true;
#line 29
uniform float4 Color <
ui_type = "color";
ui_label = "Background color";
ui_category = "Borders";
> = float4(0.027, 0.027, 0.027, 0.17);
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
#line 35 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\AspectRatio.fx"
#line 41
texture AspectBgTex < source = "AspectRatio.jpg"; > { Width = 1351; Height = 1013; };
sampler AspectBgSampler { Texture = AspectBgTex; };
#line 44
float3 AspectRatioPS(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
bool Mask = false;
#line 49
float2 coord = texcoord-0.5;
#line 52
if (Zoom != 1.0) coord /= clamp(Zoom, 1.0, 1.5); 
#line 55
if (A<0)
{
coord.x *= abs(A)+1.0; 
#line 60
if (FitScreen) coord /= abs(A)+1.0;
else 
Mask = abs(coord.x)>0.5;
}
#line 65
else if (A>0)
{
coord.y *= A+1.0; 
#line 70
if (FitScreen) coord /= abs(A)+1.0;
else 
Mask = abs(coord.y)>0.5;
}
#line 76
coord += 0.5;
#line 79
if (UseBackground && !FitScreen) 
if (Mask)
return lerp( tex2D(AspectBgSampler, texcoord).rgb, Color.rgb, Color.a );
else
return tex2D(ReShade::BackBuffer, coord).rgb;
else
if (Mask)
return Color.rgb;
else
return tex2D(ReShade::BackBuffer, coord).rgb;
}
#line 96
technique AspectRatioPS
<
ui_label = "Aspect Ratio";
ui_tooltip = "Correct image aspect ratio";
>
{
pass
{
VertexShader = PostProcessVS;
PixelShader = AspectRatioPS;
}
}

