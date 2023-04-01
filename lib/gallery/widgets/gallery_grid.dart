import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item.dart';

class GalleryGrid extends StatefulWidget {
  const GalleryGrid({
    super.key,
    this.urls = const [],
    required this.random,
    required this.index,
  });

  final List<String> urls;
  final Random random;
  final int index;

  @override
  State<GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  late List<Widget> rows;

  static const int maxItemsPerRow = 4;

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
    final slicedUrls = widget.urls.slices(maxItemsPerRow).toList();

    return List.generate(
      slicedUrls.length,
      (urlsSliceIndex) {
        final urlsSlice = slicedUrls[urlsSliceIndex];

        var mainRowChildren = <Widget>[];

        if (urlsSliceIndex.isEven && urlsSlice.length >= 3) {
          // For rows with an even index, create a layout
          // where the last 2 or 3 items of a row are laid out in
          // a further column & row segments combination
          mainRowChildren = [
            Expanded(
              child: GalleryItem(
                heroTag: '__hero_${urlsSliceIndex}_0_grid_${widget.index}__',
                imagePath: urlsSlice[0],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: widget.random.nextInt(2) + 1,
                    child: GalleryItem(
                      heroTag: '__hero_${urlsSliceIndex}_1_'
                          'grid_${widget.index}__',
                      imagePath: urlsSlice[1],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GalleryItem(
                            heroTag: '__hero_${urlsSliceIndex}_2_'
                                'grid_${widget.index}__',
                            imagePath: urlsSlice[2],
                          ),
                        ),
                        if (urlsSlice.length == 4)
                          Expanded(
                            child: GalleryItem(
                              heroTag: '__hero_${urlsSliceIndex}_3_'
                                  'grid_${widget.index}__',
                              imagePath: urlsSlice[3],
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
            urlsSlice.length,
            (imageIndex) {
              return Expanded(
                flex: widget.random.nextInt(2) + 1,
                child: GalleryItem(
                  heroTag: '__hero_${urlsSliceIndex}_$imageIndex'
                      '_grid_${widget.index}__}',
                  imagePath: urlsSlice[imageIndex],
                ),
              );
            },
          );
        }

        return Expanded(
          flex: urlsSliceIndex.isOdd ? 1 : widget.random.nextInt(3) + 1,
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
    if (oldWidget.urls != widget.urls) {
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
