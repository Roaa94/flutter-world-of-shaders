#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

// A 2-dimentional vector representing the width & height, respectively
// of the area the shader is being applied to
uniform vec2 uSize;

// The amount of the distortion
uniform float uAmount;

uniform sampler2D tInput;

out vec4 fragColor;

vec2 pincushion(vec2 st) {
    vec2 center = vec2(0.5, 0.5); // center of the image
    vec2 distorted = st - center; // calculate distortion vector
    float r2 = dot(distorted, distorted); // calculate squared distance from center
    distorted *= 1.0 / (1.0 + uAmount * r2); // apply pincushion distortion
    vec2 uv = center + distorted; // add distortion
    return uv;
}

vec4 fragment(vec2 fragCoord) {
    vec2 uv = pincushion(fragCoord);
    vec4 pixelColor = texture(tInput, uv);
    return pixelColor;
}

void main() {
    // The local position of the pixel being evaluated
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 st = fragCoord.xy / uSize.xy;

    fragColor = fragment(st);
}