#version 330 compatibility

/*
   Hyllian Smart-Blur Shader
  
   Copyright (C) 2011-2016 Hyllian - sergiogdb@gmail.com

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.

*/

// Parameter lines go here:
#pragma parameter SB_BLUR_LEVEL "Smart Blur Level" 0.66 0.00 1.00 0.02
#pragma parameter SB_RED_THRESHOLD "Smart Blur Red Threshold" 0.2 0.0 0.6 0.01
#pragma parameter SB_GREEN_THRESHOLD "Smart Blur Green Threshold" 0.2 0.0 0.6 0.01
#pragma parameter SB_BLUE_THRESHOLD "Smart Blur Blue Threshold" 0.2 0.0 0.6 0.01

#if __VERSION__ >= 130
#define COMPAT_VARYING out
#define COMPAT_ATTRIBUTE in
#define COMPAT_TEXTURE texture
#else
#define COMPAT_VARYING varying 
#define COMPAT_ATTRIBUTE attribute 
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

COMPAT_ATTRIBUTE vec4 VertexCoord;
COMPAT_ATTRIBUTE vec4 COLOR;
COMPAT_ATTRIBUTE vec4 TexCoord;
COMPAT_VARYING vec4 COL0;
COMPAT_VARYING vec4 TEX0;
COMPAT_VARYING vec4 t1;
COMPAT_VARYING vec4 t2;
COMPAT_VARYING vec4 t3;

vec4 _oPosition1; 
uniform mat4 MVPMatrix;
uniform COMPAT_PRECISION int FrameDirection;
uniform COMPAT_PRECISION int FrameCount;
uniform COMPAT_PRECISION vec2 OutputSize;
uniform COMPAT_PRECISION vec2 TextureSize;
uniform COMPAT_PRECISION vec2 InputSize;

// compatibility #defines
#define vTexCoord TEX0.xy
#define SourceSize vec4(TextureSize, 1.0 / TextureSize) //either TextureSize or InputSize
#define OutSize vec4(OutputSize, 1.0 / OutputSize)

#ifdef PARAMETER_UNIFORM
uniform COMPAT_PRECISION float SB_BLUR_LEVEL;
uniform COMPAT_PRECISION float SB_RED_THRESHOLD;
uniform COMPAT_PRECISION float SB_GREEN_THRESHOLD;
uniform COMPAT_PRECISION float SB_BLUE_THRESHOLD;
#else
#define SB_BLUR_LEVEL 0.66
#define SB_RED_THRESHOLD 0.2
#define SB_GREEN_THRESHOLD 0.2
#define SB_BLUE_THRESHOLD 0.2
#endif

void main()
{
    //gl_Position = MVPMatrix * VertexCoord;
    gl_Position = ftransform();
    float dist = distance(gl_Vertex, gl_Position);
    gl_FrontColor = (vec4(gl_Normal,1.0) * 2.0) / dist;

    TEX0.xy = TexCoord.xy;
    vec2 ps = vec2(1.0/TextureSize.x, 1.0/TextureSize.y);
    float dx = ps.x;
    float dy = ps.y;

    t1 = TEX0.xxxy + vec4(    -dx,    0.0,     dx,    -dy); //  A B C
    t2 = TEX0.xxxy + vec4(    -dx,    0.0,     dx,    0.0); //  D E F
    t3 = TEX0.xxxy + vec4(    -dx,    0.0,     dx,     dy);  //  G H I
}
