// http://www.pouet.net/prod.php?which=57245
// Credits: 'Danilo Guanabara'
// On ShaderToy: https://www.shadertoy.com/view/XsXXDn
// Edited to work with Flutter
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

void main() {
    vec2 localPos = FlutterFragCoord().xy;

    vec3 c;
    float l, z = uTime;
    for (int i = 0; i < 3; i++) {
        vec2 uv, p = localPos / uSize;
        uv = p;
        p -= .5;
        p.x *= uSize.x / uSize.y;
        z += .07;
        l = length(p);
        uv += p / l * (sin(z) + 1.) * abs(sin(l * 9. - z - z));
        c[i] = .01 / length(mod(uv, 1.) - .5);
    }
    fragColor = vec4(c / l, uTime);
}