import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground/effects/pincushion_distortion_page.dart';
import 'package:playground/shader_toy_examples/shader_toy_example_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: 'Interactive Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PincushionDistortionPage(),
    );
  }
}
