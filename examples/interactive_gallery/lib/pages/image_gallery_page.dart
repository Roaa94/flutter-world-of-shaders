import 'package:flutter/material.dart';
import 'package:interactive_gallery/pages/image_gallery_item_page.dart';
import 'package:interactive_gallery/utils/images.dart';
import 'package:interactive_gallery/utils/routes.dart';
import 'package:interactive_gallery/widgets/distorted_interactive_grid.dart';
import 'package:interactive_gallery/widgets/image_gallery_item.dart';

class ImageGalleryPage extends StatelessWidget {
  const ImageGalleryPage({super.key});

  static List<String> items = gifs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: DistortedInteractiveGrid(
        maxItemsPerViewport: 10,
        children: List.generate(
          items.length,
          (index) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                createFadeInRoute(
                  routePageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    _,
                  ) {
                    return ImageGalleryItemPage(
                      images: items,
                      initialIndex: index,
                    );
                  },
                ),
              );
            },
            child: ImageGalleryItem(
              heroTag: '__hero_${index}__',
              imagePath: items[index],
            ),
          ),
        ),
      ),
    );
  }
}
