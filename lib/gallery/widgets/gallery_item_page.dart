import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item.dart';

class GalleryItemPage extends StatelessWidget {
  const GalleryItemPage({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GalleryItem(
        imagePath: imagePath,
      ),
    );
  }
}
