import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_effect.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_grid.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_grid.dart';

class GalleryWrapper extends StatefulWidget {
  const GalleryWrapper({super.key});

  @override
  State<GalleryWrapper> createState() => _GalleryWrapperState();
}

class _GalleryWrapperState extends State<GalleryWrapper>
    with SingleTickerProviderStateMixin {
  double distortionAmount = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: distortionAmount),
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
      builder: (context, double distortionAmount, Widget? child) {
        return GalleryEffect(
          distortionAmount: distortionAmount,
          child: child!,
        );
      },
      child: InteractiveGrid(
        width: screenSize.width,
        height: screenSize.height,
        onScrollStart: () {
          setState(() {
            distortionAmount = 0.9;
          });
        },
        onScrollEnd: () {
          setState(() {
            distortionAmount = 0.0;
          });
        },
        itemBuilder: (context, index) {
          return const GalleryGrid();
        },
      ),
    );
  }
}
