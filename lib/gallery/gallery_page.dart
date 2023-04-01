import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_gallery.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  static List<String> images = List.generate(
    40,
    (index) => 'assets/gallery/trevi-fountain-thumb.png',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveGallery(
        urls: images,
      ),
    );
  }
}
