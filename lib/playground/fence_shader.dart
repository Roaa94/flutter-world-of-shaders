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
  bool isLoading = false;

  Future<void> _loadShader() async {
    program = await FragmentProgram.fromAsset('shaders/fence.glsl');
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
    setState(() => isLoading = true);
    _loadShader().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void didUpdateWidget(covariant FenceShader oldWidget) {
    _updateShader();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (shader == null) {
      return const Center(child: Text('Shader could not be loaded!'));
    }
    final screenSize = MediaQuery.of(context).size;

    final shaderAreaSize = screenSize * 0.8;

    shader!
      ..setFloat(0, shaderAreaSize.width)
      ..setFloat(1, shaderAreaSize.height);

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
    return false;
  }
}
