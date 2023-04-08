import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class FenceShader extends StatefulWidget {
  const FenceShader({super.key});

  @override
  State<FenceShader> createState() => _FenceShaderState();
}

class _FenceShaderState extends State<FenceShader> {
  FragmentProgram? program;
  FragmentShader? shader;

  final _timerEnabled = false;
  Timer? timer;
  double time = 0;

  Future<void> _loadShader() async {
    program = await FragmentProgram.fromAsset('packages/core/shaders/fence.glsl');
    if (program != null) {
      shader = program!.fragmentShader();
    }
  }

  void _updateShader() {
    if (program != null) {
      shader = program!.fragmentShader();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_timerEnabled) {
      timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        setState(() {
          time += 0.016;
        });
      });
    }
    _loadShader();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FenceShader oldWidget) {
    _updateShader();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;
    final shaderAreaSize = screenSize * 1;

    shader!
      ..setFloat(0, shaderAreaSize.width)
      ..setFloat(1, shaderAreaSize.height)
      ..setFloat(2, time);

    return Center(
      child: SizedBox(
        width: shaderAreaSize.width,
        height: shaderAreaSize.height,
        child: CustomPaint(
          painter: FenceShaderPainter(shader!),
        ),
      ),
    );
  }
}

class FenceShaderPainter extends CustomPainter {
  FenceShaderPainter(this.shader);

  final FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..shader = shader,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
