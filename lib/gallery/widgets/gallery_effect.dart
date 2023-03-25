import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GalleryEffect extends StatefulWidget {
  const GalleryEffect({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GalleryEffect> createState() => _GalleryEffectState();
}

class _GalleryEffectState extends State<GalleryEffect> {
  double distortion = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderBuilder(
          (BuildContext context, ui.FragmentShader shader, Widget? child) {
            return AnimatedSampler(
              (ui.Image image, size, canvas) {
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, distortion)
                  ..setImageSampler(0, image);

                canvas.drawRect(
                  Offset.zero & size,
                  Paint()..shader = shader,
                );
              },
              child: widget.child,
            );
          },
          assetKey: 'shaders/gallery_effect.glsl',
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Slider(
            value: distortion,
            onChanged: (value) {
              setState(() {
                distortion = value;
              });
            },
            divisions: 100,
          ),
        ),
      ],
    );
  }
}
