precision mediump float;

#include <flutter/runtime_effect.glsl>

// A 2-dimentional vector representing the width & height, respectively
// of the area the shader is being applied to
uniform vec2 uSize;

// The time in seconds since this shader was created
uniform float uTime;

out vec4 fragColor;

void main() {
    // The local position of the pixel being evaluated
    vec2 localPos = FlutterFragCoord().xy;

    // The normalized position of the pixel being evaluated
    vec2 uv = localPos / uSize;

    fragColor = vec4(1.0, 0.0, 0.0, 1.0); // Red color
}