/*------------------.
| :: Description :: |
'-------------------/

    Copyright (based on Layer) (version 0.7)

    Authors: CeeJay.dk, seri14, Marot Satil, Uchu Suzume, prod80, originalnicodr
    License: MIT

    About:
    Blends an image with the game.
    The idea is to give users with graphics skills the ability to create effects using a layer just like in an image editor.
    Maybe they could use this to create custom CRT effects, custom vignettes, logos, custom hud elements, toggable help screens and crafting tables or something I haven't thought of.

    History:
    (*) Feature (+) Improvement (x) Bugfix (-) Information (!) Compatibility
    
    Version 0.2 by seri14 & Marot Satil
    * Added the ability to scale and move the layer around on an x, y axis.

    Version 0.3 by seri14
    * Reduced the problem of layer color is blending with border color

    Version 0.4 by seri14 & Marot Satil
    * Added support for the additional seri14 DLL preprocessor options to minimize loaded textures.

    Version 0.5 by Uchu Suzume & Marot Satil
    * Rotation added.

    Version 0.6 by Uchu Suzume & Marot Satil
    * Added multiple blending modes thanks to the work of Uchu Suzume, prod80, and originalnicodr.

    Version 0.7 by Uchu Suzume & Marot Satil
    * Added Addition, Subtract, Divide blending modes.

    Version 0.8 by Uchu Suzume & Marot Satil
    * Sorted blending modes in a more logical fashion, grouping by type.
*/

#include "ReShade.fxh"

#ifndef cLayerTex
#define cLayerTex "cLayerA.png" // Add your own image file to \reshade-shaders\Textures\ and provide the new file name in quotes to change the image displayed!
#endif
#ifndef cLayer_SIZE_X
#define cLayer_SIZE_X BUFFER_WIDTH
#endif
#ifndef cLayer_SIZE_Y
#define cLayer_SIZE_Y BUFFER_HEIGHT
#endif

#if cLayer_SINGLECHANNEL
#define TEXFORMAT R8
#else
#define TEXFORMAT RGBA8
#endif

uniform int cLayer_Select <
    ui_label = "Copyright Selection";
    ui_tooltip = "The image/texture you'd like to use.";
    ui_type = "combo";
    ui_items= "FFXIV\0"
              "FFXIV Nalukai\0"
              "FFXIV Yomi Black\0"
              "FFXIV Yomi White\0"
              "FFXIV With GShade Dark\0"
              "FFXIV With GShade White\0"
              "NIGHTINGALE 1 Italic\0"
              "NIGHTINGALE 2 Sabon\0"
              "NIGHTINGALE 3 Source Han\0"
              "NIGHTINGALE 4 Pacifico\0"
              "NIGHTINGALE 5 Camar\0"
              "NIGHTINGALE 6 Kraskario\0"
              "NIGHTINGALE 7 Medium\0"
              "NIGHTINGALE 7 Left\0"
              "NIGHTINGALE 7 Right\0"
              "NIGHTINGALE 8 Goblet\0"
              "NIGHTINGALE 8 Lavender\0"
              "NIGHTINGALE 8 Mist\0"
              "NIGHTINGALE 8 Shirogane\0"
              "NIGHTINGALE 9 FZMing\0"
              "NIGHTINGALE 10 Seaside\0"
              "NIGHTINGALE 11 Huxiaobo\0"
              "NIGHTINGALE 12 Mirror\0"
              "NIGHTINGALE 13 Gabriola\0"
              "NIGHTINGALE 14 Butterfly\0"
              "NIGHTINGALE 15 SquareCN\0"
              "NIGHTINGALE 16 SquareEN\0";
    ui_bind = "CopyrightTexture_Source";
> = 0;

// Set default value(see above) by source code if the preset has not modified yet this variable/definition
#ifndef cLayerTexture_Source
#define cLayerTexture_Source 0
#endif

uniform int cLayer_BlendMode <
    ui_type = "combo";
    ui_label = "Blending Mode";
    ui_tooltip = "Select the blending mode applied to the layer.";
    ui_items = "Normal\0"
               "Darken\0"
               "Multiply\0"
               "Color Burn\0"
               "Linear Burn\0"
               "Lighten\0"
               "Screen\0"
               "Color Dodge\0"
               "Linear Dodge\0"
               "Addition\0"
               "Glow\0"
               "Overlay\0"
               "Soft Light\0"
               "Hard Light\0"
               "Vivid Light\0"
               "Linear Light\0"
               "Pin Light\0"
               "Hard Mix\0"
               "Difference\0"
               "Exclusion\0"
               "Subtract\0"
               "Divide\0"
               "Reflect\0"
               "Grain Merge\0"
               "Grain Extract\0"
               "Hue\0"
               "Saturation\0"
               "Color\0"
               "Luminosity\0";
> = 0;

uniform float cLayer_Blend <
    ui_label = "Blending Amount";
    ui_tooltip = "The amount of blending applied to the copyright layer.";
    ui_type = "slider";
    ui_min = 0.0;
    ui_max = 1.0;
    ui_step = 0.001;
> = 1.0;

uniform float cLayer_Scale <
  ui_type = "slider";
    ui_label = "Scale X & Y";
    ui_min = 0.001; ui_max = 5.0;
    ui_step = 0.001;
> = 1.001;

uniform float cLayer_ScaleX <
  ui_type = "slider";
    ui_label = "Scale X";
    ui_min = 0.001; ui_max = 5.0;
    ui_step = 0.001;
> = 1.0;

uniform float cLayer_ScaleY <
  ui_type = "slider";
    ui_label = "Scale Y";
    ui_min = 0.001; ui_max = 5.0;
    ui_step = 0.001;
> = 1.0;

uniform float cLayer_PosX <
  ui_type = "slider";
    ui_label = "Position X";
    ui_min = -2.0; ui_max = 2.0;
    ui_step = 0.001;
> = 0.5;

uniform float cLayer_PosY <
  ui_type = "slider";
    ui_label = "Position Y";
    ui_min = -2.0; ui_max = 2.0;
    ui_step = 0.001;
> = 0.5;

uniform int cLayer_SnapRotate <
    ui_type = "combo";
    ui_label = "Snap Rotation";
    ui_items = "None\0"
               "90 Degrees\0"
               "-90 Degrees\0"
               "180 Degrees\0"
               "-180 Degrees\0";
    ui_tooltip = "Snap rotation to a specific angle.";
> = false;

uniform float cLayer_Rotate <
    ui_label = "Rotate";
    ui_type = "slider";
    ui_min = -180.0;
    ui_max = 180.0;
    ui_step = 0.01;
> = 0;


#if   CopyrightTexture_Source == 0 // FFXIV Vanilla
#define _SOURCE_COPYRIGHT_FILE "Copyright4kH.png"
#define _SOURCE_COPYRIGHT_SIZE 1363.0, 68.0
#elif CopyrightTexture_Source == 1 // FFXIV Nalukai
#define _SOURCE_COPYRIGHT_FILE "CopyrightF4kH.png"
#define _SOURCE_COPYRIGHT_SIZE 1162.0, 135.0
#elif CopyrightTexture_Source == 2 // FFXIV Yomi Black
#define _SOURCE_COPYRIGHT_FILE "CopyrightYBlH.png"
#define _SOURCE_COPYRIGHT_SIZE 1162.0, 135.0
#elif CopyrightTexture_Source == 3 // FFXIV Yomi White
#define _SOURCE_COPYRIGHT_FILE "CopyrightYWhH.png"
#define _SOURCE_COPYRIGHT_SIZE 1162.0, 135.0
#elif CopyrightTexture_Source == 4 // FFXIV With GShade Dark
#define _SOURCE_COPYRIGHT_FILE "copyright_ffxiv_w_gshade_dark.png"
#define _SOURCE_COPYRIGHT_SIZE 1300.0, 70.0
#elif CopyrightTexture_Source == 5 // FFXIV With GShade White
#define _SOURCE_COPYRIGHT_FILE "copyright_ffxiv_w_gshade_white.png"
#define _SOURCE_COPYRIGHT_SIZE 1300.0, 70.0
#elif CopyrightTexture_Source == 6 // NIGHTINGALE 1 Italic
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_1.png"
#define _SOURCE_COPYRIGHT_SIZE 954.0, 69.0
#elif CopyrightTexture_Source == 7 // NIGHTINGALE 2 Sabon
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_2.png"
#define _SOURCE_COPYRIGHT_SIZE 1132.0, 139.0
#elif CopyrightTexture_Source == 8 // NIGHTINGALE 3 Source Han
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_3.png"
#define _SOURCE_COPYRIGHT_SIZE 1087.0, 250.0
#elif CopyrightTexture_Source == 9 // NIGHTINGALE 4 Pacifico
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_4.png"
#define _SOURCE_COPYRIGHT_SIZE 1398.0, 213.0
#elif CopyrightTexture_Source == 10 // NIGHTINGALE 5 Camar
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_5.png"
#define _SOURCE_COPYRIGHT_SIZE 1398.0, 109.0
#elif CopyrightTexture_Source == 11 // NIGHTINGALE 6 Kraskario
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_6.png"
#define _SOURCE_COPYRIGHT_SIZE 859.0, 238.0
#elif CopyrightTexture_Source == 12 // NIGHTINGALE 7 Medium
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_7_medium.png"
#define _SOURCE_COPYRIGHT_SIZE 1957.0, 269.0
#elif CopyrightTexture_Source == 13 // NIGHTINGALE 7 Left
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_7_left.png"
#define _SOURCE_COPYRIGHT_SIZE 1957.0, 269.0
#elif CopyrightTexture_Source == 14 // NIGHTINGALE 7 Right
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_7_right.png"
#define _SOURCE_COPYRIGHT_SIZE 1957.0, 269.0
#elif CopyrightTexture_Source == 15 // NIGHTINGALE 8 Goblet
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_8_goblet.png"
#define _SOURCE_COPYRIGHT_SIZE 1231.0, 152.0
#elif CopyrightTexture_Source == 16 // NIGHTINGALE 8 Lavender
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_8_lavender.png"
#define _SOURCE_COPYRIGHT_SIZE 1231.0, 152.0
#elif CopyrightTexture_Source == 17 // NIGHTINGALE 8 Mist
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_8_mist.png"
#define _SOURCE_COPYRIGHT_SIZE 1231.0, 152.0
#elif CopyrightTexture_Source == 18 // NIGHTINGALE 8 Shirogane
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_8_shirogane.png"
#define _SOURCE_COPYRIGHT_SIZE 1231.0, 152.0
#elif CopyrightTexture_Source == 19 // NIGHTINGALE 9 FZMing
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_9.png"
#define _SOURCE_COPYRIGHT_SIZE 1231.0, 101.0
#elif CopyrightTexture_Source == 20 // NIGHTINGALE 10 Seaside
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_10.png"
#define _SOURCE_COPYRIGHT_SIZE 745.0, 600.0
#elif CopyrightTexture_Source == 21 // NIGHTINGALE 11 Huxiaobo
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_11.png"
#define _SOURCE_COPYRIGHT_SIZE 408.0, 149.0
#elif CopyrightTexture_Source == 22 // NIGHTINGALE 12 Mirror
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_12.png"
#define _SOURCE_COPYRIGHT_SIZE 808.0, 149.0
#elif CopyrightTexture_Source == 23 // NIGHTINGALE 13 Gabriola
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_13.png"
#define _SOURCE_COPYRIGHT_SIZE 1228.0, 149.0
#elif CopyrightTexture_Source == 24 // NIGHTINGALE 14 Butterfly
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_14.png"
#define _SOURCE_COPYRIGHT_SIZE 464.0, 465.0
#elif CopyrightTexture_Source == 25 // NIGHTINGALE 15 SquareCN
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_15.png"
#define _SOURCE_COPYRIGHT_SIZE 564.0, 563.0
#elif CopyrightTexture_Source == 26 // NIGHTINGALE 16 SquareEN
#define _SOURCE_COPYRIGHT_FILE "copyright_nightingale_16.png"
#define _SOURCE_COPYRIGHT_SIZE 564.0, 563.0
#endif


texture Copyright_Texture <
    source = _SOURCE_COPYRIGHT_FILE;
> {
    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;
    Format = RGBA8;
};
sampler Copyright_Sampler { 
    Texture = Copyright_Texture;
    AddressU = CLAMP;
    AddressV = CLAMP;
};

// -------------------------------------
// Entrypoints
// -------------------------------------

#include "ReShade.fxh"
#include "Blending.fxh"

void PS_cLayer(in float4 pos : SV_Position, float2 texCoord : TEXCOORD, out float4 passColor : SV_Target) {
    const float3 pivot = float3(0.5, 0.5, 0.0);
    const float AspectX = (1.0 - BUFFER_WIDTH * (1.0 / BUFFER_HEIGHT));
    const float AspectY = (1.0 - BUFFER_HEIGHT * (1.0 / BUFFER_WIDTH));
    const float3 mulUV = float3(texCoord.x, texCoord.y, 1);
    const float2 ScaleSize = (float2(_SOURCE_COPYRIGHT_SIZE) * cLayer_Scale / BUFFER_SCREEN_SIZE);
    const float ScaleX =  ScaleSize.x * AspectX * cLayer_ScaleX;
    const float ScaleY =  ScaleSize.y * AspectY * cLayer_ScaleY;
    float Rotate = cLayer_Rotate * (3.1415926 / 180.0);

    switch(cLayer_SnapRotate)
    {
        default:
            break;
        case 1:
            Rotate = -90.0 * (3.1415926 / 180.0);
            break;
        case 2:
            Rotate = 90.0 * (3.1415926 / 180.0);
            break;
        case 3:
            Rotate = 0.0;
            break;
        case 4:
            Rotate = 180.0 * (3.1415926 / 180.0);
            break;
    }

    const float3x3 positionMatrix = float3x3 (
        1, 0, 0,
        0, 1, 0,
        -cLayer_PosX, -cLayer_PosY, 1
    );
    const float3x3 scaleMatrix = float3x3 (
        1/ScaleX, 0, 0,
        0,  1/ScaleY, 0,
        0, 0, 1
    );
    const float3x3 rotateMatrix = float3x3 (
       (cos (Rotate) * AspectX), (sin(Rotate) * AspectX), 0,
        (-sin(Rotate) * AspectY), (cos(Rotate) * AspectY), 0,
        0, 0, 1
    );

    const float3 SumUV = mul (mul (mul (mulUV, positionMatrix), rotateMatrix), scaleMatrix);
    const float4 backColor = tex2D(ReShade::BackBuffer, texCoord);
    passColor = tex2D(Copyright_Sampler, SumUV.rg + pivot.rg) * all(SumUV + pivot == saturate(SumUV + pivot));

    switch (cLayer_BlendMode)
    {
        // Normal
        default:
            passColor = lerp(backColor.rgb, passColor.rgb, passColor.a * cLayer_Blend);
            break;
        // Darken
        case 1:
            passColor = lerp(backColor.rgb, Darken(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Multiply
        case 2:
            passColor = lerp(backColor.rgb, Multiply(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Color Burn
        case 3:
            passColor = lerp(backColor.rgb, ColorBurn(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Linear Burn
        case 4:
            passColor = lerp(backColor.rgb, LinearBurn(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Lighten
        case 5:
            passColor = lerp(backColor.rgb, Lighten(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Screen
        case 6:
            passColor = lerp(backColor.rgb, Screen(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Color Dodge
        case 7:
            passColor = lerp(backColor.rgb, ColorDodge(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Linear Dodge
        case 8:
            passColor = lerp(backColor.rgb, LinearDodge(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Addition
        case 9:
            passColor = lerp(backColor.rgb, Addition(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Glow
        case 10:
            passColor = lerp(backColor.rgb, Glow(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Overlay
        case 11:
            passColor = lerp(backColor.rgb, Overlay(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Soft Light
        case 12:
            passColor = lerp(backColor.rgb, SoftLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Hard Light
        case 13:
            passColor = lerp(backColor.rgb, HardLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Vivid Light
        case 14:
            passColor = lerp(backColor.rgb, VividLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Linear Light
        case 15:
            passColor = lerp(backColor.rgb, LinearLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Pin Light
        case 16:
            passColor = lerp(backColor.rgb, PinLight(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Hard Mix
        case 17:
            passColor = lerp(backColor.rgb, HardMix(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Difference
        case 18:
            passColor = lerp(backColor.rgb, Difference(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Exclusion
        case 19:
            passColor = lerp(backColor.rgb, Exclusion(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Subtract
        case 20:
            passColor = lerp(backColor.rgb, Subtract(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Divide
        case 21:
            passColor = lerp(backColor.rgb, Divide(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Reflect
        case 22:
            passColor = lerp(backColor.rgb, Reflect(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Grain Merge
        case 23:
            passColor = lerp(backColor.rgb, GrainMerge(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Grain Extract
        case 24:
            passColor = lerp(backColor.rgb, GrainExtract(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Hue
        case 25:
            passColor = lerp(backColor.rgb, Hue(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Saturation
        case 26:
            passColor = lerp(backColor.rgb, Saturation(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Color
        case 27:
            passColor = lerp(backColor.rgb, ColorB(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
        // Luminosity
        case 28:
            passColor = lerp(backColor.rgb, Luminosity(backColor.rgb, passColor.rgb), passColor.a * cLayer_Blend);
            break;
    }

    passColor.a = backColor.a;
}

// -------------------------------------
// Techniques
// -------------------------------------

technique Copyright {
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader  = PS_cLayer;
    }
}
