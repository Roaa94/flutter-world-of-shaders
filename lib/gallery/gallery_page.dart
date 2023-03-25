import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_effect.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_grid.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GalleryEffect(
        child: GalleryGrid(),
      ),
    );
  }
}
