#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Deband.fx"
#line 47
uniform int threshold_preset <
ui_type = "combo";
ui_label = "Debanding strength";
ui_items = "Low\0Medium\0High\0Custom\0";
ui_tooltip = "Debanding presets. Use Custom to be able to use custom thresholds in the advanced section.";
ui_bind = "DEBANDPRESET";
> = 3;
#line 60
uniform float Range <
ui_type = "slider";
ui_min = 1.0;
ui_max = 128.0;
ui_step = 1.0;
ui_label = "Initial radius";
ui_tooltip = "The radius increases linearly for each iteration. A higher radius will find more gradients, but a lower radius will smooth more aggressively.";
> = 128.0;
#line 69
uniform int Iterations <
ui_type = "slider";
ui_min = 1;
ui_max = 16;
ui_label = "Iterations";
ui_tooltip = "The number of debanding steps to perform per sample. Each step reduces a bit more banding, but takes time to compute.";
> = 1;
#line 77
uniform bool sky_only <
ui_type = "radio";
ui_label = "Use depth";
ui_tooltip = "Enable to have deband apply only at a specific distance. Works well for targeting exclusively the sky.";
ui_bind = "DEBANDDEPTH";
> = 0;
#line 106
uniform float custom_avgdiff <
ui_type = "slider";
ui_min = 0.0;
ui_max = 255.0;
ui_step = 0.1;
ui_label = "Average threshold";
ui_tooltip = "Threshold for the difference between the average of reference pixel values and the original pixel value. Higher numbers increase the debanding strength but progressively diminish image details. In pixel shaders a 8-bit color step equals to 1.0/255.0";
ui_category = "Advanced";
> = 255.0;
#line 116
uniform float custom_maxdiff <
ui_type = "slider";
ui_min = 0.0;
ui_max = 255.0;
ui_step = 0.1;
ui_label = "Maximum threshold";
ui_tooltip = "Threshold for the difference between the maximum difference of one of the reference pixel values and the original pixel value. Higher numbers increase the debanding strength but progressively diminish image details. In pixel shaders a 8-bit color step equals to 1.0/255.0";
ui_category = "Advanced";
> = 10.0;
#line 126
uniform float custom_middiff <
ui_type = "slider";
ui_min = 0.0;
ui_max = 255.0;
ui_step = 0.1;
ui_label = "Middle threshold";
ui_tooltip = "Threshold for the difference between the average of diagonal reference pixel values and the original pixel value. Higher numbers increase the debanding strength but progressively diminish image details. In pixel shaders a 8-bit color step equals to 1.0/255.0";
ui_category = "Advanced";
> = 255.0;
#line 136
uniform bool debug_output <
ui_type = "radio";
ui_label = "Debug view";
ui_tooltip = "Shows the low-pass filtered (blurred) output. Could be useful when making sure that range and iterations capture all of the banding in the picture.";
ui_category = "Advanced";
ui_bind = "DEBANDDEBUG";
> = 0;
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ReShade.fxh"
#line 44
namespace ReShade
{
float GetAspectRatio() { return 1920 * (1.0 / 1080); }
float2 GetPixelSize() { return float2((1.0 / 1920), (1.0 / 1080)); }
float2 GetScreenSize() { return float2(1920, 1080); }
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
#line 149 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Deband.fx"
#line 152
uniform int drandom < source = "random"; min = 0; max = 32767; >;
#line 154
float rand(float x)
{
return frac(x / 41.0);
}
#line 159
float permute(float x)
{
return ((34.0 * x + 1.0) * x) % 289.0;
}
#line 164
void analyze_pixels(float3 ori, sampler2D tex, float2 texcoord, float2 _range, float2 dir, out float3 ref_avg, out float3 ref_avg_diff, out float3 ref_max_diff, out float3 ref_mid_diff1, out float3 ref_mid_diff2)
{
#line 169
float3 ref = tex2Dlod(tex, float4(texcoord + _range * dir, 0.0, 0.0)).rgb;
float3 diff = abs(ori - ref);
ref_max_diff = diff;
ref_avg = ref;
ref_mid_diff1 = ref;
#line 176
ref = tex2Dlod(tex, float4(texcoord + _range * -dir, 0.0, 0.0)).rgb;
diff = abs(ori - ref);
ref_max_diff = max(ref_max_diff, diff);
ref_avg += ref;
ref_mid_diff1 = abs(((ref_mid_diff1 + ref) * 0.5) - ori);
#line 183
ref = tex2Dlod(tex, float4(texcoord + _range * float2(-dir.y, dir.x), 0.0, 0.0)).rgb;
diff = abs(ori - ref);
ref_max_diff = max(ref_max_diff, diff);
ref_avg += ref;
ref_mid_diff2 = ref;
#line 190
ref = tex2Dlod(tex, float4(texcoord + _range * float2( dir.y, -dir.x), 0.0, 0.0)).rgb;
diff = abs(ori - ref);
ref_max_diff = max(ref_max_diff, diff);
ref_avg += ref;
ref_mid_diff2 = abs(((ref_mid_diff2 + ref) * 0.5) - ori);
#line 196
ref_avg *= 0.25; 
ref_avg_diff = abs(ori - ref_avg);
}
#line 200
float3 PS_Deband(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
const float3 ori = tex2Dlod(ReShade::BackBuffer, float4(texcoord, 0.0, 0.0)).rgb; 
#line 209
float3 res; 
#line 225
const float avgdiff = custom_avgdiff / 255.0;
const float maxdiff = custom_maxdiff / 255.0;
const float middiff = custom_middiff / 255.0;
#line 231
float h = permute(permute(permute(texcoord.x) + texcoord.y) + drandom / 32767.0);
#line 233
float3 ref_avg; 
float3 ref_avg_diff; 
float3 ref_max_diff; 
float3 ref_mid_diff1; 
float3 ref_mid_diff2; 
#line 240
const float dir  = rand(permute(h)) * 6.2831853;
const float2 o = float2(cos(dir), sin(dir));
#line 243
for (int i = 1; i <= Iterations; ++i) {
#line 245
float dist = rand(h) * Range * i;
float2 pt = dist *  float2((1.0 / 1920), (1.0 / 1080));
#line 248
analyze_pixels(ori, ReShade::BackBuffer, texcoord, pt, o,
ref_avg,
ref_avg_diff,
ref_max_diff,
ref_mid_diff1,
ref_mid_diff2);
#line 255
float3 ref_avg_diff_threshold = avgdiff * i;
float3 ref_max_diff_threshold = maxdiff * i;
float3 ref_mid_diff_threshold = middiff * i;
#line 260
float3 factor = pow(saturate(3.0 * (1.0 - ref_avg_diff  / ref_avg_diff_threshold)) *
saturate(3.0 * (1.0 - ref_max_diff  / ref_max_diff_threshold)) *
saturate(3.0 * (1.0 - ref_mid_diff1 / ref_mid_diff_threshold)) *
saturate(3.0 * (1.0 - ref_mid_diff2 / ref_mid_diff_threshold)), 0.1);
#line 268
res = lerp(ori, ref_avg, factor);
#line 270
h = permute(h);
}
#line 273
const float dither_bit = 8.0; 
#line 279
const float grid_position = frac(dot(texcoord, ( float2(1920, 1080) * float2(1.0 / 16.0, 10.0 / 36.0)) + 0.25));
#line 282
const float dither_shift = 0.25 * (1.0 / (pow(2, dither_bit) - 1.0));
#line 288
return res + lerp(2.0 * float3(dither_shift, -dither_shift, dither_shift), -2.0 * float3(dither_shift, -dither_shift, dither_shift), grid_position);
}
#line 291
technique Deband <
ui_tooltip = "Alleviates color banding by trying to approximate original color values.";
>
{
pass
{
VertexShader = PostProcessVS;
PixelShader = PS_Deband;
}
}

