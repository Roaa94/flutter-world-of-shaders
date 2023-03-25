import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/shader_toy_examples/shader_toy_example_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter World of Shaders',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ShaderToyExample1(),
    );
  }
}
