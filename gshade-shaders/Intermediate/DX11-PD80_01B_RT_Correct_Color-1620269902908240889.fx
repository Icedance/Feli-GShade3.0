#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\PD80_01B_RT_Correct_Color.fx"
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
#line 29 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\PD80_01B_RT_Correct_Color.fx"
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\PD80_00_Noise_Samplers.fxh"
#line 29
texture texNoise        < source = "pd80_bluenoise.png"; >       { Width = 512; Height = 512; Format = RGBA8; };
texture texNoiseRGB     < source = "pd80_bluenoise_rgba.png"; >  { Width = 512; Height = 512; Format = RGBA8; };
texture texGaussNoise   < source = "pd80_gaussnoise.png"; >      { Width = 512; Height = 512; Format = RGBA8; };
#line 34
sampler samplerNoise
{
Texture = texNoise;
MipFilter = POINT;
MinFilter = POINT;
MagFilter = POINT;
AddressU = WRAP;
AddressV = WRAP;
AddressW = WRAP;
};
sampler samplerRGBNoise
{
Texture = texNoiseRGB;
MipFilter = POINT;
MinFilter = POINT;
MagFilter = POINT;
AddressU = WRAP;
AddressV = WRAP;
AddressW = WRAP;
};
sampler samplerGaussNoise
{
Texture = texGaussNoise;
MipFilter = POINT;
MinFilter = POINT;
MagFilter = POINT;
AddressU = WRAP;
AddressV = WRAP;
AddressW = WRAP;
};
#line 66
uniform float2 pp < source = "pingpong"; min = 0; max = 128; step = 1; >;
static const float2 dither_uv = float2( 2560, 1377 ) / 512.0f;
#line 69
float4 dither( sampler2D tex, float2 coords, int var, bool enabler, float str, bool motion, float swing )
{
coords.xy    *= dither_uv.xy;
float4 noise  = tex2D( tex, coords.xy );
float mot     = motion ? pp.x + var : 0.0f;
noise         = frac( noise + 0.61803398875f * mot );
noise         = ( noise * 2.0f - 1.0f ) * swing;
return ( enabler ) ? noise * ( str / 255.0f ) : float4( 0.0f, 0.0f, 0.0f, 0.0f );
}
#line 30 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\PD80_01B_RT_Correct_Color.fx"
#line 32
namespace pd80_correctcolor
{
#line 78
uniform bool enable_fade <
ui_text = "----------------------------------------------";
ui_label = "Enable Time Based Fade";
ui_tooltip = "Enable Time Based Fade";
ui_category = "Global: Remove Tint";
> = true;
uniform bool freeze <
ui_label = "Freeze Correction";
ui_tooltip = "Freeze Correction";
ui_category = "Global: Remove Tint";
> = false;
uniform float transition_speed <
ui_type = "slider";
ui_label = "Time Based Fade Speed";
ui_tooltip = "Time Based Fade Speed";
ui_category = "Global: Remove Tint";
ui_min = 0.0f;
ui_max = 1.0f;
> = 0.5;
uniform bool enable_dither <
ui_label = "Enable Dithering";
ui_tooltip = "Enable Dithering";
ui_category = "Global: Remove Tint";
> = true;
uniform float dither_strength <
ui_type = "slider";
ui_label = "Dither Strength";
ui_tooltip = "Dither Strength";
ui_category = "Global: Remove Tint";
ui_min = 0.0f;
ui_max = 10.0f;
> = 1.0;
uniform bool rt_enable_whitepoint_correction <
ui_text = "----------------------------------------------";
ui_label = "Enable Whitepoint Correction";
ui_tooltip = "Enable Whitepoint Correction";
ui_category = "Whitepoint: Remove Tint";
> = true;
uniform bool rt_whitepoint_respect_luma <
ui_label = "Respect Luma";
ui_tooltip = "Whitepoint: Respect Luma";
ui_category = "Whitepoint: Remove Tint";
> = true;
uniform int rt_whitepoint_method <
ui_label = "Color Detection Method";
ui_category = "Whitepoint: Remove Tint";
ui_type = "combo";
ui_items = "By Color Channel (auto-color)\0Find Light Color (auto-tone)\0";
> = 0;
uniform float rt_wp_str <
ui_type = "slider";
ui_label = "White Point Correction Strength";
ui_tooltip = "Whitepoint: White Point Correction Strength";
ui_category = "Whitepoint: Remove Tint";
ui_min = 0.0f;
ui_max = 1.0f;
> = 1.0;
uniform float rt_wp_rl_str <
ui_type = "slider";
ui_label = "White Point Respect Luma Strength";
ui_tooltip = "Whitepoint: White Point Respect Luma Strength";
ui_category = "Whitepoint: Remove Tint";
ui_min = 0.0f;
ui_max = 1.0f;
> = 1.0;
uniform bool rt_enable_blackpoint_correction <
ui_text = "----------------------------------------------";
ui_label = "Enable Blackpoint Correction";
ui_tooltip = "Enable Blackpoint Correction";
ui_category = "Blackpoint: Remove Tint";
> = true;
uniform bool rt_blackpoint_respect_luma <
ui_label = "Respect Luma";
ui_tooltip = "Blackpoint: Respect Luma";
ui_category = "Blackpoint: Remove Tint";
> = false;
uniform int rt_blackpoint_method <
ui_label = "Color Detection Method";
ui_category = "Blackpoint: Remove Tint";
ui_type = "combo";
ui_items = "By Color Channel (auto-color)\0Find Dark Color  (auto-tone)\0";
> = 1;
uniform float rt_bp_str <
ui_type = "slider";
ui_label = "Black Point Correction Strength";
ui_tooltip = "Blackpoint: Black Point Correction Strength";
ui_category = "Blackpoint: Remove Tint";
ui_min = 0.0f;
ui_max = 1.0f;
> = 1.0;
uniform float rt_bp_rl_str <
ui_type = "slider";
ui_label = "Black Point Respect Luma Strength";
ui_tooltip = "Blackpoint: Black Point Respect Luma Strength";
ui_category = "Blackpoint: Remove Tint";
ui_min = 0.0f;
ui_max = 1.0f;
> = 1.0;
uniform bool rt_enable_midpoint_correction <
ui_text = "----------------------------------------------";
ui_label = "Enable Midtone Correction";
ui_tooltip = "Enable Midtone Correction";
ui_category = "Midtone: Remove Tint";
> = true;
uniform bool rt_midpoint_respect_luma <
ui_label = "Respect Luma";
ui_tooltip = "Midtone: Respect Luma";
ui_category = "Midtone: Remove Tint";
> = true;
uniform bool mid_use_alt_method <
ui_label = "Use average Dark-Light as Mid";
ui_tooltip = "Midtone: Use average Dark-Light as Mid";
ui_category = "Midtone: Remove Tint";
> = true;
uniform float midCC_scale <
ui_type = "slider";
ui_label = "Midtone Correction Scale";
ui_tooltip = "Midtone: Midtone Correction Scale";
ui_category = "Midtone: Remove Tint";
ui_min = 0.0f;
ui_max = 5.0f;
> = 0.5;
#line 202
texture texColor { Width = 2560; Height = 1377; MipLevels = 5; };
texture texDS_1_Max { Width = 32; Height = 32; Format = RGBA16F; };
texture texDS_1_Min { Width = 32; Height = 32; Format = RGBA16F; };
texture texDS_1_Mid { Width = 32; Height = 32; Format = RGBA16F; };
texture texDS_1x1 { Width = 6; Height = 2; Format = RGBA16F; };
texture texPrevious { Width = 6; Height = 2; Format = RGBA16F; };
#line 210
sampler samplerColor { Texture = texColor; };
sampler samplerDS_1_Max
{
Texture = texDS_1_Max;
MipFilter = POINT;
MinFilter = POINT;
MagFilter = POINT;
};
sampler samplerDS_1_Min
{
Texture = texDS_1_Min;
MipFilter = POINT;
MinFilter = POINT;
MagFilter = POINT;
};
sampler samplerDS_1_Mid
{
Texture = texDS_1_Mid;
MipFilter = POINT;
MinFilter = POINT;
MagFilter = POINT;
};
sampler samplerDS_1x1
{
Texture   = texDS_1x1;
MipFilter = POINT;
MinFilter = POINT;
MagFilter = POINT;
};
sampler samplerPrevious
{
Texture   = texPrevious;
MipFilter = POINT;
MinFilter = POINT;
MagFilter = POINT;
};
#line 248
uniform float frametime < source = "frametime"; >;
#line 250
float3 interpolate( float3 o, float3 n, float factor, float ft )
{
return lerp( o.xyz, n.xyz, 1.0f - exp( -factor * ft ));
}
#line 256
float4 PS_WriteColor(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
return tex2D( ReShade::BackBuffer, texcoord );
}
#line 261
void PS_MinMax_1( float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 minValue : SV_Target0, out float4 maxValue : SV_Target1, out float4 midValue : SV_Target2 )
{
float3 currColor;
float3 minMethod0  = 1.0f;
float3 minMethod1  = 1.0f;
float3 maxMethod0  = 0.0f;
float3 maxMethod1  = 0.0f;
midValue           = 0.0f;
#line 270
float getMid;   float getMid2;
float getMin;   float getMin2;
float getMax;   float getMax2;
#line 274
float3 prevMin     = tex2D( samplerPrevious, float2( texcoord.x / 6.0f, texcoord.y )).xyz;
float3 prevMax     = tex2D( samplerPrevious, float2(( texcoord.x + 4.0f ) / 6.0f, texcoord.y )).xyz;
float middle       = dot( float2( dot( prevMin.xyz, 0.333333f ), dot( prevMax.xyz, 0.333333f )), 0.5f );
middle             = ( mid_use_alt_method ) ? middle : 0.5f;
#line 280
float pst          = 0.03125f;    
float hst          = 0.5f * pst;  
#line 284
float2 stexSize    = float2( 2560/      1, 1377/      1 );
uint OFFSET        = 1 +         0 * 3;
float2 start       = floor(( texcoord.xy - hst ) * stexSize.xy );    
float2 stop        = floor(( texcoord.xy + hst ) * stexSize.xy );    
#line 289
[loop]
for( int y = start.y; y < stop.y && y < stexSize.y; y += OFFSET )
{
for( int x = start.x; x < stop.x && x < stexSize.x; x += OFFSET )
{
currColor      = tex2Dfetch( samplerColor, int4( x, y, 0,    0 )).xyz;
#line 297
minMethod0.xyz = min( minMethod0.xyz, currColor.xyz );
#line 299
getMin         = max( max( currColor.x, currColor.y ), currColor.z ) + dot( currColor.xyz, 1.0f );
getMin2        = max( max( minMethod1.x, minMethod1.y ), minMethod1.z ) + dot( minMethod1.xyz, 1.0f );
minMethod1.xyz = ( getMin2 >= getMin ) ? currColor.xyz : minMethod1.xyz;
#line 303
getMid         = dot( abs( currColor.xyz - middle ), 1.0f );
getMid2        = dot( abs( midValue.xyz - middle ), 1.0f );
midValue.xyz   = ( getMid2 >= getMid ) ? currColor.xyz : midValue.xyz;
#line 308
maxMethod0.xyz = max( currColor.xyz, maxMethod0.xyz );
#line 310
getMax         = dot( currColor.xyz, 1.0f );
getMax2        = dot( maxMethod1.xyz, 1.0f );
maxMethod1.xyz = ( getMax >= getMax2 ) ? currColor.xyz : maxMethod1.xyz;
}
}
#line 316
minValue.xyz       = rt_blackpoint_method ? minMethod1.xyz : minMethod0.xyz;
maxValue.xyz       = rt_whitepoint_method ? maxMethod1.xyz : maxMethod0.xyz;
#line 319
minValue           = float4( minValue.xyz, 1.0f );
maxValue           = float4( maxValue.xyz, 1.0f );
midValue           = float4( midValue.xyz, 1.0f );
}
#line 325
float4 PS_MinMax_1x1( float4 pos : SV_Position, float2 texcoord : TEXCOORD ) : SV_Target
{
float3 minColor; float3 maxColor; float3 midColor;
float3 minValue; float3 maxValue; float3 midValue;
float getMin;    float getMin2;
float getMax;    float getMax2;
float3 minMethod0  = 1.0f;
float3 minMethod1  = 1.0f;
float3 maxMethod0  = 0.0f;
float3 maxMethod1  = 0.0f;
midValue           = 0.0f;
#line 337
int2 SampleRes     = 32;
float Sigma        = 0.0f;
#line 340
for( int y = 0; y < SampleRes.y; ++y )
{
for( int x = 0; x < SampleRes.x; ++x )
{
#line 345
minColor       = tex2Dfetch( samplerDS_1_Min, int4( x, y, 0, 0 )).xyz;
#line 347
minMethod0.xyz = min( minMethod0.xyz, minColor.xyz );
#line 349
getMin         = max( max( minColor.x, minColor.y ), minColor.z ) + dot( minColor.xyz, 1.0f );
getMin2        = max( max( minMethod1.x, minMethod1.y ), minMethod1.z ) + dot( minMethod1.xyz, 1.0f );
minMethod1.xyz = ( getMin2 >= getMin ) ? minColor.xyz : minMethod1.xyz;
#line 353
midColor       += tex2Dfetch( samplerDS_1_Mid, int4( x, y, 0, 0 )).xyz;
Sigma          += 1.0f;
#line 356
maxColor       = tex2Dfetch( samplerDS_1_Max, int4( x, y, 0, 0 )).xyz;
#line 358
maxMethod0.xyz = max( maxColor.xyz, maxMethod0.xyz );
#line 360
getMax         = dot( maxColor.xyz, 1.0f );
getMax2        = dot( maxMethod1.xyz, 1.0f );
maxMethod1.xyz = ( getMax >= getMax2 ) ? maxColor.xyz : maxMethod1.xyz;
}
}
#line 366
minValue.xyz       = rt_blackpoint_method ? minMethod1.xyz : minMethod0.xyz;
maxValue.xyz       = rt_whitepoint_method ? maxMethod1.xyz : maxMethod0.xyz;
midValue.xyz       = midColor.xyz / Sigma;
#line 372
maxValue.xyz       = ( minValue.xyz >= maxValue.xyz ) ? float3( 1.0f, 1.0f, 1.0f ) : maxValue.xyz;
#line 375
float3 prevMin     = tex2D( samplerPrevious, float2( texcoord.x / 6.0f, texcoord.y )).xyz;
float3 prevMid     = tex2D( samplerPrevious, float2(( texcoord.x + 2.0f ) / 6.0f, texcoord.y )).xyz;
float3 prevMax     = tex2D( samplerPrevious, float2(( texcoord.x + 4.0f ) / 6.0f, texcoord.y )).xyz;
float smoothf      = transition_speed * 4.0f + 1.0f;
float time         = frametime * 0.001f;
maxValue.xyz       = enable_fade ? interpolate( prevMax.xyz, maxValue.xyz, smoothf, time ) : maxValue.xyz;
minValue.xyz       = enable_fade ? interpolate( prevMin.xyz, minValue.xyz, smoothf, time ) : minValue.xyz;
midValue.xyz       = enable_fade ? interpolate( prevMid.xyz, midValue.xyz, smoothf, time ) : midValue.xyz;
#line 384
maxValue.xyz       = freeze ? prevMax.xyz : maxValue.xyz;
minValue.xyz       = freeze ? prevMin.xyz : minValue.xyz;
midValue.xyz       = freeze ? prevMid.xyz : midValue.xyz;
#line 388
if( pos.x < 2 )
return float4( minValue.xyz, 1.0f );
else if( pos.x >= 2 && pos.x < 4 )
return float4( midValue.xyz, 1.0f );
else
return float4( maxValue.xyz, 1.0f );
return float4( 0.5, 0.5, 0.5, 1.0 );
}
#line 397
float4 PS_RemoveTint(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
float4 color       = tex2D( samplerColor, texcoord );
#line 402
float4 dnoise      = dither( samplerRGBNoise, texcoord.xy, 0, enable_dither, dither_strength, 1, 0.5f );
color.xyz          = saturate( color.xyz + dnoise.xyz );
#line 405
float3 minValue    = tex2D( samplerDS_1x1, float2( texcoord.x / 6.0f, texcoord.y )).xyz;
float3 midValue    = tex2D( samplerDS_1x1, float2(( texcoord.x + 2.0f ) / 6.0f, texcoord.y )).xyz;
float3 maxValue    = tex2D( samplerDS_1x1, float2(( texcoord.x + 4.0f ) / 6.0f, texcoord.y )).xyz;
#line 409
float middle       = dot( float2( dot( minValue.xyz, 0.333333f ), dot( maxValue.xyz, 0.333333f )), 0.5f );
middle             = mid_use_alt_method ? middle : 0.5f;
#line 412
minValue.xyz       = lerp( 0.0f, minValue.xyz, rt_bp_str );
minValue.xyz       = rt_enable_blackpoint_correction ? minValue.xyz : 0.0f;
#line 415
maxValue.xyz       = lerp( 1.0f, maxValue.xyz, rt_wp_str );
maxValue.xyz       = rt_enable_whitepoint_correction ? maxValue.xyz : 1.0f;
#line 418
midValue.xyz       = midValue.xyz - middle;
midValue.xyz       *= midCC_scale;
midValue.xyz       = rt_enable_midpoint_correction ? midValue.xyz : 0.0f;
#line 422
color.xyz          = saturate( color.xyz - minValue.xyz ) / ( maxValue.xyz - minValue.xyz );
#line 424
float avgMax       = dot( maxValue.xyz, 0.333333f );
color.xyz          = lerp( color.xyz, color.xyz * avgMax, rt_whitepoint_respect_luma * rt_wp_rl_str );
#line 427
float avgMin       = dot( minValue.xyz, 0.333333f );
color.xyz          = lerp( color.xyz, color.xyz * ( 1.0f - avgMin ) + avgMin, rt_blackpoint_respect_luma * rt_bp_rl_str );
#line 430
float avgCol       = dot( color.xyz, 0.333333f ); 
float avgMid       = dot( midValue.xyz, 0.333333f );
avgCol             = 1.0f - abs( avgCol * 2.0f - 1.0f );
color.xyz          = saturate( color.xyz - midValue.xyz * avgCol + avgMid * avgCol * rt_midpoint_respect_luma );
#line 444
return float4( color.xyz, 1.0f );
}
#line 447
float4 PS_StorePrev( float4 pos : SV_Position, float2 texcoord : TEXCOORD ) : SV_Target
{
float3 minValue    = tex2D( samplerDS_1x1, float2( texcoord.x / 6.0f, texcoord.y )).xyz;
float3 midValue    = tex2D( samplerDS_1x1, float2(( texcoord.x + 2.0f ) / 6.0f, texcoord.y )).xyz;
float3 maxValue    = tex2D( samplerDS_1x1, float2(( texcoord.x + 4.0f ) / 6.0f, texcoord.y )).xyz;
if( pos.x < 2 )
return float4( minValue.xyz, 1.0f );
else if( pos.x >= 2 && pos.x < 4 )
return float4( midValue.xyz, 1.0f );
else
return float4( maxValue.xyz, 1.0f );
}
#line 461
technique prod80_01B_RT_Correct_Color
< ui_tooltip = "Remove Tint/Color Cast\n\n"
"Automatically adjust Blackpoint, Whitepoint, and remove color tints/casts while enhancing contrast.\n"
"Both correcting per individual channel, as well as Light/Dark colors are supported.\n"
"This shader will not adjust tinting applied in gamma, and this is considered out of scope.\n\n"
#line 467
"RT_PRECISION_LEVEL_0_TO_4\n"
"Sets the precision level in detecting the white and black points. Higher levels mean less precision and more color removal.\n"
"Too high values will remove significant amounts of color and may cause shifts in color, contrast, or banding artefacts.";>
{
pass prod80_pass0
{
VertexShader       = PostProcessVS;
PixelShader        = PS_WriteColor;
RenderTarget       = texColor;
}
pass prod80_pass1
{
VertexShader       = PostProcessVS;
PixelShader        = PS_MinMax_1;
RenderTarget0      = texDS_1_Min;
RenderTarget1      = texDS_1_Max;
RenderTarget2      = texDS_1_Mid;
}
pass prod80_pass2
{
VertexShader       = PostProcessVS;
PixelShader        = PS_MinMax_1x1;
RenderTarget       = texDS_1x1;
}
pass prod80_pass3
{
VertexShader       = PostProcessVS;
PixelShader        = PS_RemoveTint;
}
pass prod80_pass4
{
VertexShader       = PostProcessVS;
PixelShader        = PS_StorePrev;
RenderTarget       = texPrevious;
}
}
}
