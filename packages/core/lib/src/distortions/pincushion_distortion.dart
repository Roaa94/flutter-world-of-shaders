import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class PincushionDistortion extends StatelessWidget {
  const PincushionDistortion({
    super.key,
    required this.child,
    this.enabled = true,
    this.distortionAmount = 0,
    this.strength = 0.2,
  });

  /// Child to apply the effect to
  final Widget child;

  /// Whether effect is enabled
  final bool enabled;

  /// The amount of the distortion,
  /// 0 => no distortion, 1 => maximum distortion
  final double distortionAmount;

  /// The strength of the Fisheye effect
  final double strength;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      (BuildContext context, ui.FragmentShader shader, child) {
        return AnimatedSampler(
          (ui.Image image, size, canvas) {
            shader
              ..setFloat(0, size.width)
              ..setFloat(1, size.height)
              ..setFloat(2, distortionAmount)
              ..setImageSampler(0, image);

            canvas.drawRect(
              Offset.zero & size,
              Paint()..shader = shader,
            );
          },
          enabled: enabled,
          child: child!,
        );
      },
      assetKey: 'packages/core/shaders/pincushion.glsl',
      child: child,
    );
  }
}
