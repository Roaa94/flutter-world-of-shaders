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

// A 4-dimentional vector representing the color to be returned from the shader
// The 4 dimentions here correspond to the color channels R, G, B, and A
out vec4 fragColor;

void main() {
    // The local position of the pixel being evaluated
    // A varying value that contains the local coordinates for the
    // particular fragment being evaluated
    //
    // The value returned from FlutterFragCoord is distinct from gl_FragCoord.
    // gl_FragCoord provides the screen space coordinates and should generally be avoided
    // to ensure that shaders are consistent across backends.
    // When targeting a Skia backend, the calls to gl_FragCoord are rewritten to access local coordinates
    // but this rewriting isn’t possible with Impeller
    vec2 localPos = FlutterFragCoord().xy;

    // The normalized position of the pixel being evaluated
    //
    // `uv` here are texture coordinates
    // `st` are also coordinates that are sometimes alternatively used
    //
    // The `uv` letters generally come from the UV Mapping process of generating a
    // 2D representation of a 3D object
    //
    // The main idea, is NOT to use xyz coordinates as they are reserved for the coordinates
    // of the 3D object in 3D space, and here in shaders we are working with a 2D surface
    vec2 uv = localPos / uSize;

    // Linear Interpolation: Representing Y in relation to X
    //
    // This is what will allow us to plot lines to represent y in terms of x
    // For example, the following will produce a straight line
    // ```
    // float y = uv.x;
    // ```
    // While the following will produce a curved line
    // ```
    // float y = pow(uv.x, 5.0);
    // ```
    float y = pow(uv.x, 5.0);

    // Create gradient color that represents y in relation to the uv.x coordinate
    // This assigns y to the 3 values of the vec3 type
    //
    // How is the gradient created?
    // If `y = uv.x`, the `color` variable will take the following values
    // as we move along the x-axis:
    // color = vec3(0.0, 0.0, 0.0) => black
    // color = vec3(0.1, 0.1, 0.1)
    // color = vec3(0.2, 0.2, 0.2)
    // ...
    // color = vec3(1.0, 1.0, 1.0) => white
    vec3 color = vec3(y);

    // Define some colors
    vec3 greenColor = vec3(0.0, 0.1, 0.0);
    vec3 pinkColor = vec3(1.0, 0.0, 1.0);

    // Plot representing the relationship between uv.x & uv.y
    //
    // Given a range of two numbers and a value, the `smoothstep` function
    // will interpolate the value between the defined range.
    // The two first parameters are for the beginning and end of the transition,
    // while the third is for the value to interpolate.
    // See: https://thebookofshaders.com/glossary/?search=smoothstep
    //
    // For example, given `uv`, the normalized 2D surface coordinates,
    // the following function call will plot a line on Y using a value between 0.0-1.0
    float uvPlot = smoothstep(0.01, 0.0, abs(uv.y - uv.x));
    // Add a color to the uv plot
    vec3 uvPlotColored = uvPlot * greenColor;

    float pct = smoothstep(y - 0.01, y, uv.y) - smoothstep(y, y + 0.01, uv.y);

    // Add plots to the gradient color
//    color = (1.0 - pct) * color + pct * pinkColor + uvPlotColored;

    // fragColor = vec4(1.0, 0.0, 1.0, 1.0);
    fragColor = vec4(color, 1.0);
}