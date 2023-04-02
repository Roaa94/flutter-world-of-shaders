import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:interactive_gallery/playground/shader_painter.dart';

class ShapesShaders extends StatelessWidget {
  const ShapesShaders({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: ShaderBuilder(
          (BuildContext context, FragmentShader shader, Widget? child) {
            shader
              ..setFloat(0, screenSize.width)
              ..setFloat(1, screenSize.height);

            return CustomPaint(
              painter: ShaderPainter(shader),
            );
          },
          assetKey: 'shaders/playground/rectangle.glsl',
        ),
      ),
    );
  }
}
