import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_effect.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_grid.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_wrapper.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_grid.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return const Scaffold(
      backgroundColor: Colors.black,
      body: GalleryWrapper(),
    );
  }
}
