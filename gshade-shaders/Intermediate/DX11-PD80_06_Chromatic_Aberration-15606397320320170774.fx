#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\PD80_06_Chromatic_Aberration.fx"
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
#line 29 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\PD80_06_Chromatic_Aberration.fx"
#line 31
namespace pd80_ca
{
#line 34
uniform int CA_type <
ui_label = "Chromatic Aberration Type";
ui_tooltip = "Chromatic Aberration Type";
ui_category = "Chromatic Aberration";
ui_type = "combo";
ui_items = "Center Weighted Radial\0Center Weighted Longitudinal\0Full screen Radial\0Full screen Longitudinal\0";
> = 0;
uniform int degrees <
ui_type = "slider";
ui_label = "CA Rotation Offset";
ui_tooltip = "CA Rotation Offset";
ui_category = "Chromatic Aberration";
ui_min = 0;
ui_max = 360;
ui_step = 1;
> = 135;
uniform float CA <
ui_type = "slider";
ui_label = "CA Global Width";
ui_tooltip = "CA Global Width";
ui_category = "Chromatic Aberration";
ui_min = -150.0f;
ui_max = 150.0f;
> = -12.0;
uniform int sampleSTEPS <
ui_type = "slider";
ui_label = "Number of Hues";
ui_tooltip = "Number of Hues";
ui_category = "Chromatic Aberration";
ui_min = 8;
ui_max = 96;
ui_step = 1;
> = 24;
uniform float CA_strength <
ui_type = "slider";
ui_label = "CA Effect Strength";
ui_tooltip = "CA Effect Strength";
ui_category = "Chromatic Aberration";
ui_min = 0.0f;
ui_max = 1.0f;
> = 1.0;
uniform bool show_CA <
ui_label = "CA Show Center / Vignette";
ui_tooltip = "CA Show Center / Vignette";
ui_category = "CA: Center Weighted";
> = false;
uniform float3 vignetteColor <
ui_type = "color";
ui_label = "Vignette Color";
ui_tooltip = "Vignette Color";
ui_category = "CA: Center Weighted";
> = float3(0.0, 0.0, 0.0);
uniform float CA_width <
ui_type = "slider";
ui_label = "CA Width";
ui_tooltip = "CA Width";
ui_category = "CA: Center Weighted";
ui_min = 0.0f;
ui_max = 5.0f;
> = 1.0;
uniform float CA_curve <
ui_type = "slider";
ui_label = "CA Curve";
ui_tooltip = "CA Curve";
ui_category = "CA: Center Weighted";
ui_min = 0.1f;
ui_max = 12.0f;
> = 1.0;
uniform float oX <
ui_type = "slider";
ui_label = "CA Center (X)";
ui_tooltip = "CA Center (X)";
ui_category = "CA: Center Weighted";
ui_min = -1.0f;
ui_max = 1.0f;
> = 0.0;
uniform float oY <
ui_type = "slider";
ui_label = "CA Center (Y)";
ui_tooltip = "CA Center (Y)";
ui_category = "CA: Center Weighted";
ui_min = -1.0f;
ui_max = 1.0f;
> = 0.0;
uniform float CA_shapeX <
ui_type = "slider";
ui_label = "CA Shape (X)";
ui_tooltip = "CA Shape (X)";
ui_category = "CA: Center Weighted";
ui_min = 0.2f;
ui_max = 6.0f;
> = 1.0;
uniform float CA_shapeY <
ui_type = "slider";
ui_label = "CA Shape (Y)";
ui_tooltip = "CA Shape (Y)";
ui_category = "CA: Center Weighted";
ui_min = 0.2f;
ui_max = 6.0f;
> = 1.0;
uniform bool enable_depth_int <
ui_label = "Intensity: Enable depth based adjustments.\nMake sure you have setup your depth buffer correctly.";
ui_tooltip = "Intensity: Enable depth based adjustments";
ui_category = "Final Adjustments: Depth";
> = false;
uniform bool enable_depth_width <
ui_label = "Width: Enable depth based adjustments.\nMake sure you have setup your depth buffer correctly.";
ui_tooltip = "Width: Enable depth based adjustments";
ui_category = "Final Adjustments: Depth";
> = false;
uniform bool display_depth <
ui_label = "Show depth texture";
ui_tooltip = "Show depth texture";
ui_category = "Final Adjustments: Depth";
> = false;
uniform float depthStart <
ui_type = "slider";
ui_label = "Change Depth Start Plane";
ui_tooltip = "Change Depth Start Plane";
ui_category = "Final Adjustments: Depth";
ui_min = 0.0f;
ui_max = 1.0f;
> = 0.0;
uniform float depthEnd <
ui_type = "slider";
ui_label = "Change Depth End Plane";
ui_tooltip = "Change Depth End Plane";
ui_category = "Final Adjustments: Depth";
ui_min = 0.0f;
ui_max = 1.0f;
> = 0.1;
uniform float depthCurve <
ui_label = "Depth Curve Adjustment";
ui_tooltip = "Depth Curve Adjustment";
ui_category = "Final Adjustments: Depth";
ui_type = "slider";
ui_min = 0.05;
ui_max = 8.0;
> = 1.0;
#line 180
float3 HUEToRGB( float H )
{
return saturate( float3( abs( H * 6.0f - 3.0f ) - 1.0f,
2.0f - abs( H * 6.0f - 2.0f ),
2.0f - abs( H * 6.0f - 4.0f )));
}
#line 188
float4 PS_CA(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
float4 color      = 0.0f;
float px          = (1.0 / 2560);
float py          = (1.0 / 1377);
float aspect      = float( 2560 * (1.0 / 1377) );
float3 orig       = tex2D( ReShade::BackBuffer, texcoord ).xyz;
float depth       = ReShade::GetLinearizedDepth( texcoord ).x;
depth             = smoothstep( depthStart, depthEnd, depth );
depth             = pow( depth, depthCurve );
float CA_width_n  = CA_width;
if( enable_depth_width )
CA_width_n    *= depth;
#line 203
float2 coords     = texcoord.xy * 2.0f - float2( oX + 1.0f, oY + 1.0f ); 
float2 uv         = coords.xy;
coords.xy         /= float2( CA_shapeX / aspect, CA_shapeY );
float2 caintensity= length( coords.xy ) * CA_width_n;
caintensity.y     = caintensity.x * caintensity.x + 1.0f;
caintensity.x     = 1.0f - ( 1.0f / ( caintensity.y * caintensity.y ));
caintensity.x     = pow( caintensity.x, CA_curve );
#line 211
int degreesY      = degrees;
float c           = 0.0f;
float s           = 0.0f;
switch( CA_type )
{
#line 217
case 0:
{
degreesY      = degrees + 90 > 360 ? degreesY = degrees + 90 - 360 : degrees + 90;
c             = cos( radians( degrees )) * uv.x;
s             = sin( radians( degreesY )) * uv.y;
}
break;
#line 225
case 1:
{
c             = cos( radians( degrees ));
s             = sin( radians( degreesY ));
}
break;
#line 232
case 2:
{
degreesY      = degrees + 90 > 360 ? degreesY = degrees + 90 - 360 : degrees + 90;
caintensity.x = 1.0f;
c             = cos( radians( degrees )) * uv.x;
s             = sin( radians( degreesY )) * uv.y;
}
break;
#line 241
case 3:
{
caintensity.x = 1.0f;
c             = cos( radians( degrees ));
s             = sin( radians( degreesY ));
}
break;
}
#line 251
if( enable_depth_int )
caintensity.x *= depth;
#line 254
float3 huecolor   = 0.0f;
float3 temp       = 0.0f;
float o1          = sampleSTEPS - 1.0f;
float o2          = 0.0f;
float3 d          = 0.0f;
#line 261
float caWidth     = CA * ( max( 2560, 1377 ) / 1920.0f ); 
#line 263
float offsetX     = px * c * caintensity.x;
float offsetY     = py * s * caintensity.x;
#line 266
for( float i = 0; i < sampleSTEPS; i++ )
{
huecolor.xyz  = HUEToRGB( i / sampleSTEPS );
o2            = lerp( -caWidth, caWidth, i / o1 );
temp.xyz      = tex2D( ReShade::BackBuffer, texcoord.xy + float2( o2 * offsetX, o2 * offsetY )).xyz;
color.xyz     += temp.xyz * huecolor.xyz;
d.xyz         += huecolor.xyz;
}
#line 275
color.xyz           /= dot( d.xyz, 0.333333f ); 
color.xyz           = lerp( orig.xyz, color.xyz, CA_strength );
color.xyz           = lerp( color.xyz, vignetteColor.xyz * caintensity.x + ( 1.0f - caintensity.x ) * color.xyz, show_CA );
color.xyz           = display_depth ? depth.xxx : color.xyz;
return float4( color.xyz, 1.0f );
}
#line 283
technique prod80_06_ChromaticAberration
{
pass prod80_CA
{
VertexShader  = PostProcessVS;
PixelShader   = PS_CA;
}
}
}
