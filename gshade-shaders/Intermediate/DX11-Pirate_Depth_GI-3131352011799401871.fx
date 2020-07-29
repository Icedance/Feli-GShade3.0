#line 1 "C:\FFXIV\game\gshade-shaders\Shaders\Pirate_Depth_GI.fx"
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
#line 21 "C:\FFXIV\game\gshade-shaders\Shaders\Pirate_Depth_GI.fx"
#line 24
uniform float GI_DIFFUSE_RADIUS <
ui_label = "GI - Radius";
ui_type = "slider";
ui_min = 0.0; ui_max = 200.0;
> = 1.0;
uniform float GI_DIFFUSE_STRENGTH <
ui_label = "GI - Diffuse - Strength";
ui_type = "slider";
ui_min = 0.0; ui_max = 30.0;
> = 4.0;
#line 35
uniform int GI_DIFFUSE_MIPLEVEL <
ui_label = "GI - Diffuse - Miplevel";
ui_type = "slider";
ui_min = 0; ui_max = 		11	;
> = 4;
#line 41
uniform int GI_DIFFUSE_CURVE_MODE <
ui_label = "GI - Diffuse - Curve Mode";
ui_type = "combo";
ui_items = "Linear\0Squared\0Log\0Sine\0Mid Range Sine\0";
> = 4;
uniform int GI_DIFFUSE_BLEND_MODE <
ui_label = "GI - Diffuse - Blend Mode";
ui_type = "combo";
ui_items = "Linear\0Screen\0Soft Light\0Color Dodge\0Hybrid\0";
> = 2;
uniform float GI_REFLECT_RADIUS <
ui_label = "GI - Reflection - Radius";
ui_type = "slider";
ui_min = 0.0; ui_max = 200.0;
> = 1.0;
uniform int GI_DIFFUSE_DEBUG <
ui_label = "GI - Debug";
ui_type = "combo";
ui_items = "None\0Color\0Gatherer\0";
> = 0;
uniform int GI_FOV <
ui_label = "FoV";
ui_type = "slider";
ui_min = 10; ui_max = 90;
> = 75;
#line 68
texture2D	TexGINormalDepth {Width = 2560 * 		1.0	; Height = 1440 * 		1.0	; Format = RGBA16; MipLevels = 		11	;};
sampler2D	SamplerGIND {Texture = TexGINormalDepth; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR; AddressU = Clamp; AddressV = Clamp;};
#line 71
texture2D	TexGI {Width = 2560 *  		1.0	; Height = 1440 *  		1.0	; Format = RGBA8;};
sampler2D	SamplerGI {Texture = TexGI; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR; AddressU = Clamp; AddressV = Clamp;};
#line 74
float GetRandom(float2 co)
{
#line 77
return frac(sin(dot(co, float2(12.9898, 78.233))) * 43758.5453);
}
#line 80
float2 GetRandomVector(float2 coords)
{
return normalize(float2(GetRandom(coords)*2-1, GetRandom(1.42 * coords)*2-1));
}
#line 85
float2 Rotate45(float2 coords) {
#line 87
float x = coords.x *  0.70710678118;
float y = coords.y *  0.70710678118;
return float2(x - y, x + y);
}
#line 92
float2 Rotate90(float2 coords)
{
return float2(-coords.y, coords.x);
}
#line 97
float3 EyeVector(float3 vec)
{
vec.xy = vec.xy * 2.0 - 1.0;
vec.x -= vec.x * (1.0 - vec.z) * sin(radians(GI_FOV));
vec.y -= vec.y * (1.0 - vec.z) * sin(radians(GI_FOV * (ReShade:: GetPixelSize().y / ReShade:: GetPixelSize().x)));
return vec;
}
#line 105
float3 BlendScreen(float3 a, float3 b)
{
return 1 - ((1 - a) * (1 - b));
}
#line 110
float3 BlendSoftLight(float3 a, float3 b)
{
return (1 - 2 * b) * pow(a, 2) + 2 * b * a;
}
#line 115
float3 BlendColorDodge(float3 a, float3 b)
{
return a / (1 - b);
}
#line 121
float4 PS_DepthPrePass(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : COLOR
{
const float2 offsety = float2(0.0, ReShade:: GetPixelSize().y);
const float2 offsetx = float2(ReShade:: GetPixelSize().x, 0.0);
#line 126
float pointdepth = saturate(ReShade::GetLinearizedDepth(texcoord));
#line 137
const float3 p = EyeVector(float3(texcoord, pointdepth));
float3 py1 = EyeVector(float3(texcoord + offsety, saturate(ReShade::GetLinearizedDepth(texcoord + offsety)))) - p;
const float3 py2 = p - EyeVector(float3(texcoord - offsety, saturate(ReShade::GetLinearizedDepth(texcoord - offsety))));
float3 px1 = EyeVector(float3(texcoord + offsetx, saturate(ReShade::GetLinearizedDepth(texcoord + offsetx)))) - p;
const float3 px2 = p - EyeVector(float3(texcoord - offsetx, saturate(ReShade::GetLinearizedDepth(texcoord - offsetx))));
py1 = lerp(py1, py2, abs(py1.z) > abs(py2.z));
px1 = lerp(px1, px2, abs(px1.z) > abs(px2.z));
#line 146
return float4((normalize(cross(py1, px1)) + 1.0) * 0.5, pointdepth);
}
#line 149
float4 PS_GIDiffuse(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : COLOR
{
float4 res;
float4 pointnd = tex2D(SamplerGIND, texcoord);
if (pointnd.w == 1.0) return 0.0;
pointnd.xyz = (pointnd.xyz * 2.0) - 1.0;
#line 156
const float3 pointvector = EyeVector(float3(texcoord, pointnd.w));
#line 163
float2 randomvector = GetRandomVector(texcoord * pointnd.w) * (0.5 + GetRandom(texcoord)/2);
#line 166
float2 psize = lerp(GI_DIFFUSE_RADIUS, 1.0, pow(abs(pointnd.w), 0.25)) * ReShade:: GetPixelSize();
psize /=  		1.0	;
#line 169
for(int p=1; p <= 		4	; p++)
{
float2 coordmult = psize * p;
#line 176
for(int i=0; i < 4; i++)
{
randomvector = Rotate90(randomvector);
float2 tapcoord = texcoord + randomvector * coordmult;
#line 183
float4 tapnd = tex2Dlod(SamplerGIND, float4(tapcoord, 0, GI_DIFFUSE_MIPLEVEL));
#line 185
tapnd.xyz = (tapnd.xyz * 2.0) - 1.0;
if (tapnd.w == 1.0) continue;
float3 tapvector = EyeVector(float3(tapcoord, tapnd.w));
#line 189
float3 pttvector = tapvector - pointvector;
#line 191
float weight = (1.0 - max(0.0, dot(pointnd.xyz, tapnd.xyz))); 
weight *= max(0.0, -dot(normalize(pttvector), tapnd.xyz)); 
weight *= saturate(coordmult.x - abs(pttvector.z)) / coordmult.x; 
float3 coltap = tex2Dlod(ReShade::BackBuffer, float4(tapcoord, 0, 0)).rgb;
res.rgb += coltap * weight;
res.w += weight;
}
randomvector = Rotate45(randomvector);
}
#line 201
res /= 4 * 		4	;
#line 203
return res;
}
#line 208
float4 PS_GICombine(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : COLOR
{
float4 diffuse = tex2D(SamplerGI, texcoord);
float4 res = tex2D(ReShade::BackBuffer, texcoord);
#line 215
if (GI_DIFFUSE_CURVE_MODE == 1) 
diffuse = pow(diffuse, 2);
else if (GI_DIFFUSE_CURVE_MODE == 2) 
diffuse = log10(diffuse * 10.0);
else if (GI_DIFFUSE_CURVE_MODE == 3) 
diffuse = (sin( 4.71238898038f + diffuse *  3.14159265359f) + 1) / 2;
else if (GI_DIFFUSE_CURVE_MODE == 4) 
diffuse = sin(diffuse *  3.14159265359f);
diffuse = saturate(diffuse * GI_DIFFUSE_STRENGTH);
#line 225
if (GI_DIFFUSE_BLEND_MODE == 0) 
res.rgb += diffuse.rgb;
else if (GI_DIFFUSE_BLEND_MODE == 1) 
res.rgb = BlendScreen(res.rgb, diffuse.rgb);
else if (GI_DIFFUSE_BLEND_MODE == 2) 
res.rgb = BlendSoftLight(res.rgb, 0.5 + diffuse.rgb);
else if (GI_DIFFUSE_BLEND_MODE == 3) 
res.rgb = BlendColorDodge(res.rgb, diffuse.rgb);
else 
res.rgb = lerp(res.rgb + diffuse.rgb, res.rgb * (1.0 + diffuse.rgb), dot(res.rgb, 0.3333));
#line 237
if (GI_DIFFUSE_DEBUG == 1)
res.rgb = diffuse.rgb;
else if (GI_DIFFUSE_DEBUG == 2)
res.rgb = diffuse.w;
#line 243
res.w = 1.0;
return res;
}
#line 247
technique Pirate_GI
{
pass DepthPre
{
VertexShader = PostProcessVS;
PixelShader  = PS_DepthPrePass;
RenderTarget = TexGINormalDepth;
}
pass Diffuse
{
VertexShader = PostProcessVS;
PixelShader  = PS_GIDiffuse;
RenderTarget = TexGI;
}
pass GITest
{
VertexShader = PostProcessVS;
PixelShader  = PS_GICombine;
}
}
