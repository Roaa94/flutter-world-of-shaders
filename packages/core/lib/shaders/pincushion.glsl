#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

// A 2-dimentional vector representing the width & height,
// respectively of the area the shader is being applied to
uniform vec2 uSize;

// The amount of the distortion
// 0 -> no distortion
// 1 -> max distortion
uniform float uAmount;

// The input image sampler the shader will be applied to
uniform sampler2D tInput;

// A 4-dimentional vector corresponding to the R,G, B, and A channels
// of the color to be returned from this shader for every pixel
out vec4 fragColor;

// Reusable function that applies a pincushion distortion
vec2 pincushion(vec2 st) {
    vec2 center = vec2(0.5, 0.5); // Get the center of the image
    vec2 distorted = st - center; // Calculate the distortion vector
    float r2 = dot(distorted, distorted); // calculate squared distance from center
    distorted *= 1.0 / (1.0 + uAmount * r2); // Apply pincushion distortion with input amount strength
    vec2 uv = center + distorted; // Add distortion to function input coordinates
    return uv;
}

void main() {
    // The local position of the pixel being evaluated
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 st = fragCoord.xy / uSize.xy;
    vec2 uv = pincushion(st);

    // Apply distortion to input image
    fragColor = texture(tInput, uv);
}