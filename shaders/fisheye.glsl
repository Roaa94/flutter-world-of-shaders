precision mediump float;

#include <flutter/runtime_effect.glsl>

// A 2-dimentional vector representing the width & height, respectively
// of the area the shader is being applied to
uniform vec2 uSize;

// The time in seconds since this shader was created
uniform float uAmount;
uniform float uPower;

uniform sampler2D tInput;

out vec4 fragColor;

vec2 fisheye(vec2 fragCoord) {
    // Fisheye distortion
    // Source: https://www.shadertoy.com/view/td2GzW
    vec2 p = fragCoord.xy / uSize.x;
    float prop = uSize.x / uSize.y; // Screen proportions
    vec2 m = vec2(0.5, 0.5 / prop); // Center coords
    vec2 d = p - m; // Vector from center to current fragment
    float r = sqrt(dot(d, d)); // Distance of pixel from center

    float power = -uPower * sin(uAmount * 2.0);

    float bind; // Radius of 1:1 effect
    if (power > 0.0)
    bind = sqrt(dot(m, m)); // Stick to corners for Fisheye
    else {
        if (prop < 1.0)
        bind = m.x;
        else
        bind = m.y;
    } // Stick to borders for Anti-Fisheye

    // Weird formulas
    vec2 uv;
    if (power > 0.0) // Fisheye
    uv = m + normalize(d) * tan(r * power) * bind / tan(bind * power);
    else if (power < 0.0) // Anti-Fisheye
    uv = m + normalize(d) * atan(r * -power * 10.0) * bind / atan(-power * bind * 10.0);
    else uv = p; // No effect for power = 1.0

    uv.y *= prop;
    return uv;
}

vec4 fragment(vec2 fragCoord) {
    vec2 uv = fisheye(fragCoord);
    vec4 pixelColor = texture(tInput, uv);
    return pixelColor;
}

void main() {
    // The local position of the pixel being evaluated
    vec2 fragCoord = FlutterFragCoord().xy;

    fragColor = fragment(fragCoord);
}