import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item.dart';

class GalleryGrid extends StatefulWidget {
  const GalleryGrid({
    super.key,
    this.images = const [],
  });

  final List<String> images;

  @override
  State<GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  late List<Widget> rows;

  static Random random = Random();
  static const int maxItemsPerRow = 4;

  // Generates rows with a random layout based on the `widget.images` list
  //
  // Example layout for a list of 5 `images` with 3 `maxItemsPerRow` value:
  // Expanded(
  //    child: Row(
  //       children: [
  //          Expanded(child: GalleryItem(imagePath: '',)),
  //          Expanded(child: GalleryItem(imagePath: '',)),
  //          Expanded(child: GalleryItem(imagePath: '',)),
  //       ],
  //    ),
  // ),
  // Expanded(
  //    child: Row(
  //       children: [
  //          Expanded(child: GalleryItem(imagePath: '',)),
  //          Expanded(child: GalleryItem(imagePath: '',)),
  //       ],
  //    ),
  // ),
  List<Widget> _generateRows() {
    // Splitting the images list into chunks of
    // a maximum length of `maxItemsPerRow`
    final chunkedImages = widget.images.slices(maxItemsPerRow).toList();

    return List.generate(
      chunkedImages.length,
      (imageChunkIndex) {
        final imageChunk = chunkedImages[imageChunkIndex];

        var mainRowChildren = <Widget>[];

        if (imageChunkIndex.isEven && imageChunk.length > 2) {
          // For rows with an even index, create a layout
          // where the last 2 or 3 items of a row
          mainRowChildren = [
            Expanded(
              child: GalleryItem(
                imagePath: imageChunk[0],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GalleryItem(
                      imagePath: imageChunk[1],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GalleryItem(
                            imagePath: imageChunk[2],
                          ),
                        ),
                        if (imageChunk.length == 4)
                          Expanded(
                            child: GalleryItem(
                              imagePath: imageChunk[3],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        } else {
          mainRowChildren = List.generate(
            imageChunk.length,
            (imageIndex) {
              return Expanded(
                flex: random.nextInt(3) + 1,
                child: GalleryItem(
                  imagePath: imageChunk[imageIndex],
                ),
              );
            },
          );
        }

        return Expanded(
          flex: random.nextInt(4) + 1,
          child: Row(
            children: mainRowChildren,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    rows = _generateRows();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GalleryGrid oldWidget) {
    if (oldWidget.images != widget.images) {
      rows = _generateRows();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows.length, (i) => rows[i]),
    );
  }
}
