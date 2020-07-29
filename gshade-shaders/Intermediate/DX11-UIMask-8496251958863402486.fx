#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\UIMask.fx"
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
#line 99 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\UIMask.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ReShadeUI.fxh"
#line 123 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\UIMask.fx"
#line 125
uniform float fMask_Intensity <      ui_type = "slider"; 
ui_label = "Mask Intensity";
ui_tooltip = "How much to mask effects to the original image.";
ui_min = 0.0;
ui_max = 1.0;
ui_step = 0.001;
> = 1.0;
#line 133
uniform bool bDisplayMask <
ui_label = "Display Mask";
ui_tooltip =
"Display the mask texture.\n"
"Useful for testing multiple channels or simply the mask itself.";
> = false;
#line 146
texture tUIMask_Backup { Width = 2560; Height = 1377; };
texture tUIMask_Mask <source="UIMask.png";> { Width = 2560; Height = 1377; Format= R8; };
#line 149
sampler sUIMask_Mask { Texture = tUIMask_Mask; };
sampler sUIMask_Backup { Texture = tUIMask_Backup; };
#line 152
float4 PS_Backup(float4 pos : SV_Position, float2 uv : TEXCOORD) : SV_Target {
return tex2D(ReShade::BackBuffer, uv);
}
#line 156
float4 PS_ApplyMask(float4 pos : SV_Position, float2 uv : TEXCOORD) : SV_Target {
float3 col = tex2D(ReShade::BackBuffer, uv).rgb;
float3 bak = tex2D(sUIMask_Backup, uv).rgb;
#line 161
float mask = tex2D(sUIMask_Mask, uv).r;
#line 169
mask = lerp(1.0, mask, fMask_Intensity);
col = lerp(bak, col, mask);
col = bDisplayMask ? mask : col;
#line 173
return float4(col, 1.0);
}
#line 176
technique UIMask_Top {
pass {
VertexShader = PostProcessVS;
PixelShader = PS_Backup;
RenderTarget = tUIMask_Backup;
}
}
#line 184
technique UIMask_Bottom {
pass {
VertexShader = PostProcessVS;
PixelShader = PS_ApplyMask;
}
}

