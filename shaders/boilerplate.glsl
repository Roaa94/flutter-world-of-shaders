precision mediump float;

#include <flutter/runtime_effect.glsl>

// A 2-dimentional vector representing the width & height, respectively
// of the area the shader is being applied to
// Passing these values from Flutter code to the shader would look like:
// ```
// shader.setFloat(0, width)
// shader.setFloat(1, height)
// ```
uniform vec2 uSize;

out vec4 fragColor;

void main() {
    // The local position of the pixel being evaluated
    // A varying value that contains the local coordinates for the
    // particular fragment being evaluated
    vec2 localPos = FlutterFragCoord().xy;

    // The normalized position of the pixel being evaluated
    vec2 uv = localPos / uSize;

    fragColor = vec4(1.0, 0.0, 0.0, 1.0); // Red color
}