import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class FisheyeDistortionPage extends StatelessWidget {
  const FisheyeDistortionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FisheyeDistortion(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/bricks.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class FisheyeDistortion extends StatefulWidget {
  const FisheyeDistortion({
    super.key,
    required this.child,
    this.power = 0.2,
  });

  final Widget child;
  final double power;

  @override
  State<FisheyeDistortion> createState() => _FisheyeDistortionState();
}

class _FisheyeDistortionState extends State<FisheyeDistortion> {
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
                  ..setFloat(3, widget.power)
                  ..setImageSampler(0, image);

                canvas.drawRect(
                  Offset.zero & size,
                  Paint()..shader = shader,
                );
              },
              child: widget.child,
            );
          },
          assetKey: 'shaders/fisheye.glsl',
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Slider(
              activeColor: Colors.white,
              value: distortion,
              divisions: 200,
              onChanged: (value) {
                setState(() {
                  distortion = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
