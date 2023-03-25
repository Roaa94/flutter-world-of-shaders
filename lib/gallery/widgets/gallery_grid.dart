import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: const [
                    Expanded(child: GalleryItem()),
                    Expanded(child: GalleryItem()),
                  ],
                ),
              ),
              const Expanded(
                flex: 2,
                child: GalleryItem(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: GalleryItem()),
                    Expanded(
                      child: Row(
                        children: const [
                          Expanded(
                            child: GalleryItem(),
                          ),
                          Expanded(
                            child: GalleryItem(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: GalleryItem()),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: const [
              Expanded(child: GalleryItem()),
              Expanded(child: GalleryItem()),
              Expanded(child: GalleryItem()),
            ],
          ),
        ),
      ],
    );
  }
}
