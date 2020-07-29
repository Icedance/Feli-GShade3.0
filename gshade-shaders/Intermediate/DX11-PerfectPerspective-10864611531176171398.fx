#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\PerfectPerspective.fx"
#line 29
uniform int FOV <
ui_type = "slider";
ui_label = "Game field of view";
ui_tooltip = "This setting should match your in-game FOV (in degrees)";
ui_step = 0.2;
ui_min = 0; ui_max = 170;
ui_category = "Field of View";
> = 90;
#line 38
uniform int Type <
ui_type = "combo";
ui_label = "Type of FOV";
ui_tooltip = "...in stereographic mode\n"
"If image bulges in movement (too high FOV),\n"
"change it to 'Diagonal'.\n"
"When proportions are distorted at the periphery\n"
"(too low FOV), choose 'Vertical' or '4:3'.\n"
"\nAdjust so that round objects are still round \n"
"in the corners, and not oblong.\n"
"\n*This method works only in 'navigation' preset,\n"
"or k=0.5 on manual.";
ui_items =
"Horizontal FOV\0"
"Diagonal FOV\0"
"Vertical FOV\0"
"4:3 FOV\0";
ui_category = "Field of View";
> = 0;
#line 58
uniform int Projection <
ui_type = "radio";
ui_label = "Type of perspective";
ui_text = "Select game style";
ui_tooltip =
"Choose type of perspective, according to game-play style.\n"
"For manual perspective adjustment, select last option.";
ui_items =
"Navigation\0"
"Aiming\0"
"Feel of distance\0"
"manual adjustment *\0";
ui_category = "Perspective";
ui_category_closed = true;
ui_spacing = 1;
> = 0;
#line 75
uniform float K <
ui_type = "slider";
ui_label = "K (manual perspective) *";
ui_tooltip =
"K 1.0 ....Rectilinear projection (standard), preserves straight lines,"
" but doesn't preserve proportions, angles or scale.\n"
"K 0.5 ....Stereographic projection (navigation, shape) preserves angles and proportions,"
" best for navigation through tight spaces.\n"
"K 0 ......Equidistant (aiming) maintains angular speed of motion,"
" best for aiming at fast targets.\n"
"K -0.5 ...Equisolid projection (distance) preserves area relation,"
" best for navigation in open space.\n"
"K -1.0 ...Orthographic projection preserves planar luminance,"
" has extreme radial compression. Found in peephole viewer.";
ui_min = -1.0; ui_max = 1.0;
ui_category = "Perspective";
> = 1.0;
#line 93
uniform float Vertical <
ui_type = "slider";
ui_label = "Vertical distortion";
ui_tooltip = "Cylindrical perspective <<>> Spherical perspective";
ui_min = 0.0; ui_max = 1.0;
ui_category = "Perspective";
ui_text = "Global settings";
> = 1.0;
#line 102
uniform float VerticalScale <
ui_type = "slider";
ui_label = "Vertical proportions";
ui_tooltip = "Adjust anamorphic correction for cylindrical perspective";
ui_min = 0.8; ui_max = 1.0;
ui_category = "Perspective";
> = 0.95;
#line 110
uniform float Zooming <
ui_type = "slider";
ui_label = "Border scale";
ui_tooltip = "Adjust image scale and cropped area";
ui_min = 0.5; ui_max = 2.0; ui_step = 0.001;
ui_category = "Border";
ui_category_closed = true;
> = 1.0;
#line 119
uniform float BorderCorner <
ui_type = "slider";
ui_label = "Corner roundness";
ui_tooltip = "Represents corners curvature\n0.0 gives sharp corners";
ui_min = 1.0; ui_max = 0.0;
ui_category = "Border";
> = 0.062;
#line 127
uniform float4 BorderColor <
ui_type = "color";
ui_label = "Border color";
ui_tooltip = "Use Alpha to change transparency";
ui_category = "Border";
> = float4(0.027, 0.027, 0.027, 0.784);
#line 134
uniform bool MirrorBorder <
ui_type = "input";
ui_label = "Mirrored border";
ui_tooltip = "Choose original or mirrored image at the border";
ui_category = "Border";
> = true;
#line 141
uniform bool DebugPreview <
ui_type = "input";
ui_label = "Resolution scale map";
ui_tooltip = "Color map of the Resolution Scale:\n"
" Red   - under-sampling\n"
" Green - super-sampling\n"
" Blue  - neutral sampling";
ui_category = "Tools for debugging";
ui_category_closed = true;
ui_spacing = 2;
> = false;
#line 153
uniform int2 ResScale <
ui_type = "input";
ui_label = "Difference";
ui_text = "screen resolution  |  virtual, super resolution";
ui_tooltip = "Simulates application running beyond\n"
"native screen resolution (using VSR or DSR)";
ui_min = 16; ui_max = 16384; ui_step = 0.2;
ui_category = "Tools for debugging";
> = int2(1920, 1920);
#line 1 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\ReShade.fxh"
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
#line 164 "C:\SquareEnix\FINAL FANTASY XIV - A Realm Reborn\game\gshade-shaders\Shaders\PerfectPerspective.fx"
#line 167
sampler SamplerColor
{
Texture = ReShade::BackBufferTex;
AddressU = MIRROR;
AddressV = MIRROR;
};
#line 180
float grayscale(float3 Color)
{ return max(max(Color.r, Color.g), Color.b); }
#line 183
float sq(float input)
{ return input*input; }
#line 186
float linearstep(float x)
{ return clamp(x/fwidth(x), 0.0, 1.0); }
#line 199
float univPerspective(float k, float l, float2 coord)
{
#line 202
if (k >= 1.0 || FOV == 0)
return 1.0;
#line 205
float R = (l == 1.0) ?
length(coord) : 
sqrt(sq(coord.x) + sq(coord.y)*l); 
#line 209
const float omega = radians(FOV*0.5);
#line 211
float theta;
if (k>0.0)
theta = atan(R*tan(k*omega))/k;
else if (k<0.0)
theta = asin(R*sin(k*omega))/k;
else 
theta = R*omega;
#line 219
const float tanOmega = tan(omega);
return tan(theta)/(tanOmega*R);
}
#line 229
float3 PerfectPerspectivePS(float4 pos : SV_Position, float2 texCoord : TEXCOORD) : SV_Target
{
#line 232
const float aspectRatioInv = 1.0 / ReShade:: GetAspectRatio();
#line 235
float FovType; switch(Type)
{
case 0: FovType = 1.0; break; 
case 1: FovType = sqrt(sq(aspectRatioInv) + 1.0); break; 
case 2: FovType = aspectRatioInv; break; 
case 3: FovType = 4.0/3.0*aspectRatioInv; break; 
}
#line 244
float2 sphCoord = texCoord*2.0 -1.0;
#line 246
sphCoord.y *= aspectRatioInv;
#line 249
sphCoord *= clamp(Zooming, 0.5, 2.0) / FovType; 
#line 252
float k; switch (Projection)
{
case 0: k = 0.5; break;		
case 1: k = 0.0; break;		
case 2: k = -0.5; break;	
default: k = clamp(K, -1.0, 1.0); break; 
}
#line 260
sphCoord *= univPerspective(k, Vertical, sphCoord) * FovType;
#line 263
sphCoord.y *= ReShade:: GetAspectRatio();
#line 266
if(VerticalScale != 1.0 && Vertical != 1.0)
sphCoord.y /= lerp(VerticalScale, 1.0, Vertical);
#line 270
float borderMask;
if (BorderCorner == 0.0) 
borderMask = linearstep( max(abs(sphCoord.x), abs(sphCoord.y)) -1.0 );
else 
{
#line 276
float2 borderCoord = abs(sphCoord);
#line 278
if (ReShade:: GetAspectRatio() > 1.0) 
borderCoord.x = borderCoord.x*ReShade:: GetAspectRatio() + 1.0-ReShade:: GetAspectRatio();
else if (ReShade:: GetAspectRatio() < 1.0) 
borderCoord.y = borderCoord.y*aspectRatioInv + 1.0-aspectRatioInv;
#line 284
borderMask = length(max(borderCoord +BorderCorner -1.0, 0.0)) /BorderCorner;
borderMask = linearstep( borderMask-1.0 );
}
#line 289
sphCoord = sphCoord*0.5 +0.5;
#line 292
float3 display = tex2D(SamplerColor, sphCoord).rgb;
#line 295
display = lerp(
display,
lerp(
MirrorBorder ? display : tex2D(SamplerColor, texCoord).rgb,
BorderColor.rgb,
BorderColor.a
),
borderMask
);
#line 306
if(DebugPreview)
{
#line 309
float4 radialCoord = float4(texCoord, sphCoord) * 2.0 - 1.0;
#line 311
radialCoord.yw *= aspectRatioInv;
#line 314
const float3 underSmpl = float3(1.0, 0.0, 0.2); 
const float3 superSmpl = float3(0.0, 1.0, 0.5); 
const float3 neutralSmpl = float3(0.0, 0.5, 1.0); 
#line 319
float pixelScaleMap = fwidth( length(radialCoord.xy) );
#line 321
pixelScaleMap *= ResScale.x / (fwidth( length(radialCoord.zw) ) * ResScale.y);
pixelScaleMap -= 1.0;
#line 325
float3 resMap = lerp(
superSmpl,
underSmpl,
step(0.0, pixelScaleMap)
);
#line 332
pixelScaleMap = 1.0 - abs(pixelScaleMap);
pixelScaleMap = saturate(pixelScaleMap * 4.0 - 3.0); 
#line 336
resMap = lerp(resMap, neutralSmpl, pixelScaleMap);
#line 339
display = normalize(resMap) * (0.8 * grayscale(display) + 0.2);
}
#line 342
return display;
}
#line 350
technique PerfectPerspective
<
ui_label = "Perfect Perspective";
ui_tooltip = "Adjust perspective for distortion-free picture\n"
"(fish-eye, panini shader)";
>
{
pass
{
VertexShader = PostProcessVS;
PixelShader = PerfectPerspectivePS;
}
}

