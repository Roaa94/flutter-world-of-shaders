import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:playground/playground/shader_painter.dart';

class RawShader extends StatefulWidget {
  const RawShader({super.key});

  @override
  State<RawShader> createState() => _RawShaderState();
}

class _RawShaderState extends State<RawShader> {
  FragmentProgram? program;
  FragmentShader? shader;
  bool isLoading = false;

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
    setState(() => isLoading = true);
    _loadShader().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void didUpdateWidget(covariant RawShader oldWidget) {
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

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: CustomPaint(
        painter: ShaderPainter(shader!),
      ),
    );
  }
}
