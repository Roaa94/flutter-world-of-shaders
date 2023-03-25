precision mediump float;

#include <flutter/runtime_effect.glsl>

// A 2-dimentional vector representing the width & height, respectively
// of the area the shader is being applied to
uniform vec2 uSize;

// The time in seconds since this shader was created
//uniform float uTime;

out vec4 fragColor;

void main() {
    // The local position of the pixel being evaluated
    vec2 localPos = FlutterFragCoord().xy;

    // The normalized position of the pixel being evaluated
    vec2 uv = localPos / uSize;

    // Start with black color
    vec3 color = vec3(0.0);

    // Create the left border with a step function:
    // float left = step(0.1, uv.x);   // Similar to ( X greater than 0.1 )
    //
    // Create the top border with a step function:
    // float top = step(0.1, uv.y); // Similar to ( Y greater than 0.1 )
    //
    // We can then represent the color that combines the previous 2 functions with:
    // color = vec3(left * bottom);
    //
    // A shorter way of doinf this would be as follows:
    // `left` is now the `x` in `topLeft` and `bottom` is the `y` in `topLeft`
    vec2 topLeft = step(vec2(0.1), uv);

    // We can deduct the bottomRight pixels by inverting the `uv` coordinates
    // This converts the top left corner (0, 0) into the bottom right corner (1, 1)
    vec2 bottomRight = step(vec2(0.1), 1 - uv);

    // The outcome color for each pixel is the multiplication of all the square sides pixels
    color = vec3(topLeft.x * topLeft.y * bottomRight.x * bottomRight.y);

    // fragColor = vec4(1.0, 0.0, 0.0, 1.0); // Red color
    fragColor = vec4(color, 1.0); // Red color
}

// Notes:
// Multiplication (*) with vectors corresponds to AND operation, which adds shapes together
// Adding (+) with vectors corresponds to OR operation, which paints shapes intersections