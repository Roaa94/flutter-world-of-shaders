import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GalleryEffect extends StatelessWidget {
  const GalleryEffect({
    super.key,
    required this.child,
    this.enabled = true,
    this.distortionAmount = 0,
  });

  final Widget child;
  final bool enabled;
  final double distortionAmount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderBuilder(
          (BuildContext context, ui.FragmentShader shader, child) {
            return AnimatedSampler(
              (ui.Image image, size, canvas) {
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, distortionAmount)
                  ..setFloat(3, 0.2)
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
          assetKey: 'shaders/fisheye.glsl',
          child: child,
        ),
      ],
    );
  }
}
