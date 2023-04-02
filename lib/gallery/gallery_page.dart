import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/images.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_grid.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_gallery.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveGallery(
        images: images,
      ),
    );
  }
}
