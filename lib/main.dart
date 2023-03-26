import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/effects/fisheye_distortion.dart';
import 'package:flutter_world_of_shaders/gallery/gallery_page.dart';

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
      home: const FisheyeDistortionPage(),
    );
  }
}
