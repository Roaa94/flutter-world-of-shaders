import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class GalleryGrid extends StatefulWidget {
  const GalleryGrid({
    super.key,
    this.children = const [],
    required this.index,
  });

  final List<Widget> children;
  final int index;

  @override
  State<GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  late List<Widget> rows;

  static const int maxItemsPerRow = 3;
  static Random random = Random(5);
  // Generates rows with a random-ish layout based on the `widget.images` list
  //
  // Example layout for a list of 5 `images` with 3 `maxItemsPerRow` value:
  // Expanded(
  //    flex: <random>,
  //    child: Row(
  //       children: [
  //          Expanded(child: GalleryItem(imagePath: '',)),
  //          Expanded(
  //            child: Column(
  //              children: [
  //                Expanded(child: GalleryItem(imagePath: '',)),
  //                Expanded(child: GalleryItem(imagePath: '',)),
  //              ]
  //            )
  //          ),
  //       ],
  //    ),
  // ),
  // Expanded(
  //    flex: <random>,
  //    child: Row(
  //       children: [
  //          Expanded(child: GalleryItem(imagePath: '',)),
  //          Expanded(child: GalleryItem(imagePath: '',)),
  //       ],
  //    ),
  // ),
  List<Widget> _generateRows() {
    // Splitting the images list into slices of
    // a maximum length of `maxItemsPerRow`
    final slicedChildren = widget.children.slices(maxItemsPerRow).toList();

    return List.generate(
      slicedChildren.length,
      (childrenSliceIndex) {
        final childrenSlice = slicedChildren[childrenSliceIndex];

        var mainRowChildren = <Widget>[];

        if (childrenSliceIndex.isEven && childrenSlice.length >= 3) {
          // For rows with an even index, create a layout
          // where the last 2 or 3 items of a row are laid out in
          // a further column & row segments combination
          mainRowChildren = [
            Expanded(
              child: childrenSlice[0],
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: random.nextInt(2) + 1,
                    child: childrenSlice[1],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: childrenSlice[2],
                        ),
                        if (childrenSlice.length == 4)
                          Expanded(
                            child: childrenSlice[3],
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
            childrenSlice.length,
            (imageIndex) {
              return Expanded(
                flex: random.nextInt(2) + 1,
                child: childrenSlice[imageIndex],
              );
            },
          );
        }

        return Expanded(
          flex: childrenSliceIndex.isOdd ? 1 : random.nextInt(3) + 1,
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
    if (oldWidget.children != widget.children) {
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
