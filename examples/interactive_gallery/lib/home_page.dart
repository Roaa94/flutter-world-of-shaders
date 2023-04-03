import 'package:flutter/material.dart';
import 'package:interactive_gallery/images.dart';
import 'package:interactive_gallery/widgets/gallery_item_page.dart';
import 'package:interactive_gallery/widgets/image_gallery_item.dart';
import 'package:interactive_gallery/widgets/interactive_gallery.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: InteractiveGallery(
        children: List.generate(
          images.length,
          (index) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                createFadeInRoute(
                  routePageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    _,
                  ) {
                    return GalleryItemPage(
                      heroTag: '__hero_${index}__',
                      imagePath: images[index],
                    );
                  },
                ),
              );
            },
            child: ImageGalleryItem(
              heroTag: '__hero_${index}__',
              imagePath: images[index],
            ),
          ),
        ),
      ),
    );
  }
}

Route<dynamic> createFadeInRoute({required RoutePageBuilder routePageBuilder}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: routePageBuilder,
    opaque: false,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
