#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Denoise.fx"
#line 97
uniform float NoiseLevel <
ui_type = "slider";
ui_min = 0.01; ui_max = 1.00;
ui_label = "Noise Level";
ui_tooltip = "Approximate level of noise in the image.";
> = 0.15;
#line 104
uniform float LerpCoefficeint <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.00;
ui_label = "Lerp Coefficient";
ui_tooltip = "Amount of blending between the original and the processed image.";
> = 0.8;
#line 111
uniform float WeightThreshold <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Weight Threshold";
> = 0.03;
#line 117
uniform float CounterThreshold <
ui_type = "slider";
ui_min = 0.0; ui_max = 1.0;
ui_label = "Counter Threshold";
> = 0.05;
#line 123
uniform float GaussianSigma <
ui_type = "slider";
ui_min = 1.0; ui_max = 100.0;
ui_label = "Gaussian Sigma";
ui_tooltip = "Controls the additional amount of gaussian blur on the image.";
> = 50.0;
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
#line 144 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\Denoise.fx"
#line 146
float3 PS_Denoise_KNN(float4 vpos : SV_POSITION, float2 texcoord : TEXCOORD) : SV_TARGET {
const float3 orig = tex2D(ReShade::BackBuffer, texcoord).rgb;
float3 texIJ;
float weight;
float3 result = 0.0;
float counter = 0.0;
float sum = 0.0;
#line 154
float iWindowArea = 2.0 *  3	 + 1.0;
iWindowArea *= iWindowArea;
#line 157
for (int i = - 3	; i <=  3	; i++) {
for (int j = - 3	; j <=  3	; j++) {
texIJ = tex2Dlod(ReShade::BackBuffer, float4(texcoord +  float2((1.0 / 1920), (1.0 / 1080)) * float2(i, j), 0.0, 0.0)).rgb;
weight = dot(orig - texIJ, orig - texIJ);
#line 162
weight = exp(-(weight * rcp(NoiseLevel) + (i * i + j * j) * rcp(GaussianSigma)));
counter += weight > WeightThreshold;
#line 165
sum += weight;
#line 167
result.rgb += texIJ * weight;
}
}
#line 171
result /= sum;
#line 173
if (counter > (CounterThreshold * iWindowArea))
return lerp(result, orig, 1.0 - LerpCoefficeint);
else
return lerp(result, orig, LerpCoefficeint);
}
#line 179
float3 PS_Denoise_NLM(float4 vpos : SV_POSITION, float2 texcoord : TEXCOORD) : SV_TARGET {
float3 result = 0.0;
float3 texIJb;
float3 texIJc;
float counter = 0.0;
float weight;
float sum = 0.0;
#line 187
float invBlockArea = 2.0 *  2	 + 1.0;
invBlockArea = rcp(invBlockArea * invBlockArea);
#line 190
for (int i = - 3	; i <=  3	; i++) {
for (int j = - 3	; j <=  3	; j++) {
#line 193
weight = 0.0;
#line 195
for (int n = - 2	; n <=  2	; n++) {
for (int m = - 2	; m <=  2	; m++) {
texIJb = tex2Dlod(ReShade::BackBuffer, float4(texcoord +  float2((1.0 / 1920), (1.0 / 1080)) * float2(i + n, j + m), 0.0, 0.0)).rgb;
texIJc = tex2Dlod(ReShade::BackBuffer, float4(texcoord +  float2((1.0 / 1920), (1.0 / 1080)) * float2(    n,     m), 0.0, 0.0)).rgb;
weight = dot(texIJb - texIJc, texIJb - texIJc) + weight;
}
}
texIJc = tex2Dlod(ReShade::BackBuffer, float4(texcoord +  float2((1.0 / 1920), (1.0 / 1080)) * float2(i, j), 0.0, 0.0)).rgb;
#line 204
weight *= invBlockArea;
weight = exp(-(weight * rcp(NoiseLevel) + (i * i + j * j) * rcp(GaussianSigma)));
#line 207
counter += weight > WeightThreshold;
#line 209
sum += weight;
#line 211
result += texIJc * weight;
}
}
#line 215
float iWindowArea = 2.0 *  3	 + 1.0;
iWindowArea *= iWindowArea;
#line 218
result /= sum;
#line 220
if (counter > (CounterThreshold * iWindowArea))
return lerp(result, tex2D(ReShade::BackBuffer, texcoord).rgb, 1.0 - LerpCoefficeint);
else
return lerp(result, tex2D(ReShade::BackBuffer, texcoord).rgb, LerpCoefficeint);
}
#line 226
technique KNearestNeighbors
{
pass
{
VertexShader = PostProcessVS;
PixelShader = PS_Denoise_KNN;
}
}
#line 235
technique NonLocalMeans
{
pass
{
VertexShader = PostProcessVS;
PixelShader = PS_Denoise_NLM;
}
}

