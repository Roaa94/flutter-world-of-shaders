import 'package:flutter/material.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          'assets/gallery/trevi-fountain-thumb.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
