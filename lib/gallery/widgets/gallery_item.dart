import 'package:flutter/material.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(3.5),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
