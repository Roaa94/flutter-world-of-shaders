## Flutter Interactive Gallery
Interactive gallery with a shader pincushion distortion applied using Flutter's [`FragmentProgram`](https://docs.flutter.dev/development/ui/advanced/shaders) API.

🎨 [Design & animation Inspiration](https://twitter.com/slavakornilov/status/1592055393844625409)

Read on for implementation details 👇🏼

https://github.com/Roaa94/flutter-world-of-shaders/assets/50345358/230723114-01abce58-18ef-47cb-8880-98c44d289054

## How it's done 👩🏻‍💻

There are a few elements involved in this UI.
* The shader applying the distortion to the grid. Which involves `glsl` code and `Flutter`'s `FragmentProgram` API implementation
* An interactive grid that you can pan freely through in all directions, with snapping.
* A `Hero` animation that navigate to a page with another interavtive grid.

### The Shader

The shader can be found in [`packages/core/lib/shaders/pincushion.glsl`](https://github.com/Roaa94/flutter-world-of-shaders/blob/main/packages/core/lib/shaders/pincushion.glsl) and creates the following effect:

<img width="300" alt="Flutter pincushion distortion shader" src="https://user-images.githubusercontent.com/50345358/230730732-369bd012-793c-4887-b9a3-69ec213e358a.gif" />

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

### The Interactive Grid
<img width="350" alt="Flutter interactive grid with snapping" src="https://user-images.githubusercontent.com/50345358/230730634-f14069d3-a473-468b-869f-a7f74a20c698.gif" />


This is pure Flutter. A combination of `OverflowBox`, `GridView` and `GestureDetector` widgets. `onPanStart` of the gesture detector triggers the shader distortion, `onPanUpdate` moves the `GridView` around, and `onPanEnd` resets the distortion and snaps to the closest grid item. The grid is wrapped with a `TweenAnimationBuilder` to animate the snapping.


In [`interactive_grid.dart`](https://github.com/Roaa94/flutter-world-of-shaders/blob/main/examples/interactive_gallery/lib/widgets/interactive_grid.dart)'s build method:

```dart
return GestureDetector(
  onPanStart: _onPanStart, // Trigger distortion (set to 1)
  onPanUpdate: _onPanUpdate, // Move Grid
  onPanEnd: _onPanEnd, // Reset distortion (set to 0) and snap to closest grid item
  child: OverflowBox(
    maxHeight: double.infinity,
    maxWidth: double.infinity,
    alignment: Alignment.topLeft,
    child: TweenAnimationBuilder(
      duration: _animationDuration,
      curve: Curves.easeOutSine,
      tween: Tween<Offset>(begin: Offset.zero, end: gridOffset),
      builder: (context, Offset offset, Widget? child) {
        return Transform(
          transform: Matrix4.identity()
            ..setTranslationRaw(offset.dx, offset.dy, 0),
          child: SizedBox(
            width: widget.gridWidth,
            height: widget.gridHeight,
            child: GridView.builder(/* ... */),
          ),
        );
      },
    ),
  ),
);
```

In the actual code the `child` param of builder widgets was used for better performace (e.g. `TweenAnimationBuilder`, `ShaderBuilder`, ..etc).

---

### Resources for learning shaders:
* [The Book of Shaders](https://thebookofshaders.com/)
* [Inigo Quilez](https://iquilezles.org/)'s articles and videos about drawing with math
* [ShaderToy](https://www.shadertoy.com/) for lots of shader examples within a browser editor
* [From the Flutter docs](https://docs.flutter.dev/development/ui/advanced/shaders)
* [Renan](https://twitter.com/reNotANumber)'s [`shader_playground`](https://github.com/renancaraujo/shaders_playground) & [`glow_stuff_with_flutter`](https://github.com/renancaraujo/glow_stuff_with_flutter) repos & [podcast](https://www.youtube.com/watch?v=uBTVV1bo3dg)
* [Jochum](https://twitter.com/wolfenrain)'s [`flutter_shader_examples`](https://github.com/wolfenrain/flutter_shaders_example) repo & [this video](https://www.youtube.com/watch?v=FQ36PB3Umzk)

