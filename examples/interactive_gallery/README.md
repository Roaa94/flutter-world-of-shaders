## Flutter Interactive Gallery 🏞️
Interactive gallery with a shader pincushion distortion applied using Flutter's [`FragmentShader`](https://docs.flutter.dev/development/ui/advanced/shaders) API.

🎨 [Design & animation Inspiration](https://twitter.com/slavakornilov/status/1592055393844625409)

Read on for implementation details 👇🏼

<video width="100%" src="https://user-images.githubusercontent.com/50345358/230723114-01abce58-18ef-47cb-8880-98c44d289054.mp4" alt="Flutter interactive gallery with shaders"></video>

## How it's done 👩🏻‍💻

There are a few elements involved in this UI.
* The shader applying the distortion to the grid. Which involves `glsl` code and `Flutter`'s `FragmentShader` API implementation
* An interactive grid that you can pan freely through in all directions, with snapping.
* A `Hero` animation that navigate to a page with another interavtive grid.

### 1. The Shader

The shader can be found in [`packages/core/lib/shaders/pincushion.glsl`](https://github.com/Roaa94/flutter-world-of-shaders/blob/main/packages/core/lib/shaders/pincushion.glsl) and creates the following effect:

<img width="300" alt="Flutter pincushion distortion shader" src="https://user-images.githubusercontent.com/50345358/230726841-1c8d18a0-78eb-4933-8e3a-8cb535efae9f.gif" />

A look into the GLSL code:

```glsl
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
```

➡ **In Flutter:**

You can check out how you can use shader files in your Flutter UI in the [official docs](https://docs.flutter.dev/development/ui/advanced/shaders). But in short, you import the shader file in your `pubspec.yaml` and load it using the `FragmentProgram` like so:

```dart
final program = await FragmentProgram.fromAsset('shaders/myshader.frag');
```

Then you can get the shader from the `program` and use it with the `Canvas` API to render it to your UI:
```dart
 var shader = program.createShader();
 canvas.drawRect(rect, Paint()..shader = shader);
 ```

And you can pass the `uniform`s' values defined in your shader like so:
```dart
shader.setFloat(0, 42.0); // 0 is order of the uniform
```

However, this process can be much easier using the [`flutter_shaders`](https://pub.dev/packages/flutter_shaders) package with additional features like caching and the `AnimatedSampler` that we need for this UI.

In the [`pincushion_distortion.dart`](https://github.com/Roaa94/flutter-world-of-shaders/blob/main/packages/core/lib/src/distortions/pincushion_distortion.dart) file:

* The `ShaderBuilder` widget is from the `flutter_shaders` package, it loads & caches your shaders from the `assetKey`.
* The `AnimatedSampler` widget is from the `flutter_shaders` package, it samples any scene of Flutter widgets into a dart:ui image that you can pass to the shader's `uniform sampler2D` via the `setImageSampler` method.
* We also pass other uniform values:
   * The size passed as 2 values that correspond to the first and second values of the `vec2` type.
   * The distortion amount, which is the dynamic value that is [set with a `TweenAnimationBuilder`](https://github.com/Roaa94/flutter-world-of-shaders/blob/main/examples/interactive_gallery/lib/widgets/distorted_interactive_grid.dart#L114) to get the animated distortion effect on the grid.

```dart
return ShaderBuilder(
  (BuildContext context, ui.FragmentShader shader, child) {
    return AnimatedSampler(
      (ui.Image image, size, canvas) {
        shader
          ..setFloat(0, size.width) // The first value of the `vec2` `uSize` uniform
          ..setFloat(1, size.height) // The second value of the `vec2` `uSize` uniform
          ..setFloat(2, distortionAmount) // The `uAmount`, will be animated
          ..setImageSampler(0, image); // The scene of widgets

        canvas.drawRect(
          Offset.zero & size,
          Paint()..shader = shader,
        );
      },
      child: animatedSamplerChild, // Any combination of Flutter widgets
    );
  },
  assetKey: 'packages/core/shaders/pincushion.glsl',
);
```

### 2. The Interactive Grid
This is pure Flutter.


