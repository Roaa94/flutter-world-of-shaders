import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:flutter_world_of_shaders/playground/shader_painter.dart';

class WithShaderBuilder extends StatelessWidget {
  const WithShaderBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ShaderBuilder(
        (BuildContext context, FragmentShader shader, Widget? child) {
          return CustomPaint(
            painter: ShaderPainter(shader),
          );
        },
        assetKey: 'shaders/playground.glsl',
      ),
    );
  }
}
