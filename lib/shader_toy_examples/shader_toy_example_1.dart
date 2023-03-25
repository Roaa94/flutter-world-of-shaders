import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:flutter_world_of_shaders/shader_toy_examples/shader_painter.dart';

class ShaderToyExample1 extends StatefulWidget {
  const ShaderToyExample1({super.key});

  @override
  State<ShaderToyExample1> createState() => _ShaderToyExample1State();
}

class _ShaderToyExample1State extends State<ShaderToyExample1>
    with SingleTickerProviderStateMixin {
  double time = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        time += 0.016;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
              ..setFloat(1, screenSize.height)
              ..setFloat(2, time);

            return CustomPaint(
              painter: ShaderPainter(shader),
            );
          },
          assetKey: 'shaders/shader_toy_examples/example_1.glsl',
        ),
      ),
    );
  }
}
