import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_gallery.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveGallery(
        urls: List.generate(
          99,
          (index) => 'assets/gallery/trevi-fountain-thumb.png',
        ),
      ),
    );
  }
}
