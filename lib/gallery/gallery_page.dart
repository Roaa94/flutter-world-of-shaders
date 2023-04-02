import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/images.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_gallery.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: InteractiveGallery(
        children: List.generate(
          images.take(32).toList().length,
          (index) => GalleryItem(
            heroTag: '__hero_${index}__',
            imagePath: images[index],
          ),
        ),
      ),
    );
  }
}
