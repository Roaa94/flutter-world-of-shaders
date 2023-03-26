import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_wrapper.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: GalleryWrapper(),
    );
  }
}
