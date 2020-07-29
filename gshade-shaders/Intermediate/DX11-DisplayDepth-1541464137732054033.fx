#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\DisplayDepth.fx"
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
#line 8 "C:\FFXIV\game\gshade-shaders\Shaders\DisplayDepth.fx"
#line 22
uniform bool bUIUsePreprocessorDefs <
ui_label = "Use global preprocessor definitions";
ui_tooltip = "Enable this to override the values from\n"
"'Depth Input Settings' with the\n"
"preprocessor definitions. If all is set\n"
"up correctly, no difference should be\n"
"noticed.";
> = false;
#line 31
uniform float fUIFarPlane <
ui_type = "slider";
ui_label = "Far Plane";
ui_tooltip = "RESHADE_DEPTH_LINEARIZATION_FAR_PLANE=<value>\n"
"Changing this value is not necessary in most cases.";
ui_min = 0.0; ui_max = 1000.0;
ui_step = 0.1;
> =  1000.0;
#line 40
uniform float fUIDepthMultiplier <
ui_type = "drag";
ui_label = "Depth Multiplier";
ui_tooltip = "RESHADE_DEPTH_MULTIPLIER=<value>";
ui_min = 0.0; ui_max = 1000.0;
ui_step = 0.001;
> = 1.0;
#line 48
uniform int iUIUpsideDown <
ui_type = "combo";
ui_label = "Upside Down";
ui_items = "RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN=0\0RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN=1\0";
> =  0;
#line 54
uniform int iUIReversed <
ui_type = "combo";
ui_label = "Reversed";
ui_items = "RESHADE_DEPTH_INPUT_IS_REVERSED=0\0RESHADE_DEPTH_INPUT_IS_REVERSED=1\0";
> =  0;
#line 60
uniform int iUILogarithmic <
ui_type = "combo";
ui_label = "Logarithmic";
ui_items = "RESHADE_DEPTH_INPUT_IS_LOGARITHMIC=0\0RESHADE_DEPTH_INPUT_IS_LOGARITHMIC=1\0";
ui_tooltip = "Change this setting if the displayed surface normals have stripes in them";
> =  0;
#line 67
uniform float2 fUIOffset <
ui_type = "drag";
ui_label = "Offset";
ui_tooltip = "Best use 'Present type'->'Depth map' and enable 'Offset' in the options below to set the offset.\nUse these values for:\nRESHADE_DEPTH_INPUT_X_OFFSET=<left value>\nRESHADE_DEPTH_INPUT_Y_OFFSET=<right value>";
ui_min = -1.0; ui_max = 1.0;
ui_step = 0.001;
> = float2(0.0, 0.0);
#line 75
uniform float2 fUIScale <
ui_type = "drag";
ui_label = "Scale";
ui_tooltip = "Best use 'Present type'->'Depth map' and enable 'Offset' in the options below to set the scale.\nUse these values for:\nRESHADE_DEPTH_INPUT_X_SCALE=<left value>\nRESHADE_DEPTH_INPUT_Y_SCALE=<right value>";
ui_min = 0.0; ui_max = 2.0;
ui_step = 0.001;
> = float2(1.0, 1.0);
#line 83
uniform int iUIPresentType <
ui_category = "Options";
ui_type = "combo";
ui_label = "Present type";
ui_items = "Depth map\0Normal map\0Show both (Vertical 50/50)\0";
> = 2;
#line 90
uniform bool bUIShowOffset <
ui_category = "Options";
ui_type = "radio";
ui_tooltip = "Blend depth output with backbuffer";
ui_label = "Show Offset";
> = false;
#line 97
float GetDepth(float2 texcoord)
{
#line 100
if(bUIUsePreprocessorDefs)
{
return ReShade::GetLinearizedDepth(texcoord);
}
#line 107
if(iUIUpsideDown)
{
texcoord.y = 1.0 - texcoord.y;
}
#line 112
texcoord.x /= fUIScale.x;
texcoord.y /= fUIScale.y;
texcoord.x -= fUIOffset.x / 2.000000001;
texcoord.y += fUIOffset.y / 2.000000001;
float depth = tex2Dlod(ReShade::DepthBuffer, float4(texcoord, 0, 0)).x * fUIDepthMultiplier;
#line 118
if(iUILogarithmic)
{
const float C = 0.01;
depth = (exp(depth * log(C + 1.0)) - 1.0) / C;
}
#line 124
if(iUIReversed)
{
depth = 1.0 - depth;
}
#line 129
const float N = 1.0;
return depth /= fUIFarPlane - depth * (fUIFarPlane - N);
}
#line 133
float3 NormalVector(float2 texcoord)
{
float3 offset = float3( float2((1.0 / 2560), (1.0 / 1440)), 0.0);
float2 posCenter = texcoord.xy;
float2 posNorth  = posCenter - offset.zy;
float2 posEast   = posCenter + offset.xz;
#line 140
float3 vertCenter = float3(posCenter - 0.5, 1) * GetDepth(posCenter);
float3 vertNorth  = float3(posNorth - 0.5,  1) * GetDepth(posNorth);
float3 vertEast   = float3(posEast - 0.5,   1) * GetDepth(posEast);
#line 144
return normalize(cross(vertCenter - vertNorth, vertCenter - vertEast)) * 0.5 + 0.5;
}
#line 147
void PS_DisplayDepth(in float4 position : SV_Position, in float2 texcoord : TEXCOORD, out float3 color : SV_Target)
{
float3 normal_vector = NormalVector(texcoord);
#line 151
const float dither_bit = 8.0; 
#line 157
float grid_position = frac(dot(texcoord, ( float2(2560, 1440) * float2(1.0 / 16.0, 10.0 / 36.0)) + 0.25));
#line 160
float dither_shift = 0.25 * (1.0 / (pow(2, dither_bit) - 1.0));
#line 163
float3 dither_shift_RGB = float3(dither_shift, -dither_shift, dither_shift); 
#line 166
dither_shift_RGB = lerp(2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position); 
#line 169
float3 depth_value = GetDepth(texcoord).rrr + dither_shift_RGB;
#line 171
float3 normal_and_depth = lerp(normal_vector, depth_value, step(2560 * 0.5, position.x));
#line 173
color = depth_value;
#line 175
if(iUIPresentType == 1)
{
color = normal_vector;
}
if(iUIPresentType == 2)
{
color = normal_and_depth;
}
#line 184
if(bUIShowOffset)
{
float3 backbuffer = tex2D(ReShade::BackBuffer, texcoord).rgb;
#line 189
color = lerp(2*color*backbuffer, 1.0 - 2.0 * (1.0 - color) * (1.0 - backbuffer), max(color.r, max(color.g, color.b)) < 0.5 ? 0.0 : 1.0 );
#line 191
return;
}
}
#line 195
technique DisplayDepth <
ui_tooltip = "This shader helps finding the right\n"
"preprocessor settings for the depth\n"
"input.\n"
"By default the calculated normals\n"
"are shown and the goal is to make the\n"
"displayed surface normals look smooth.\n"
"Change the options for *_IS_REVERSED\n"
"and *_IS_LOGARITHMIC in the variable editor\n"
"until this happens.\n"
"\n"
"Change the 'Present type' to 'Depth map'\n"
"and check whether close objects are dark\n"
"and far away objects are white.\n"
"\n"
"When the right settings are found click\n"
"'Edit global preprocessor definitions'\n"
"(Variable editor in the 'Home' tab)\n"
"and put them in there.\n"
"\n"
"Switching between normal map and\n"
"depth map is possible via 'Present type'\n"
"in the Options category.";
>
{
pass
{
VertexShader = PostProcessVS;
PixelShader = PS_DisplayDepth;
}
}

