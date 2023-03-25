import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/playground/shapes_shaders.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ShapesShaders(),
    );
  }
}
