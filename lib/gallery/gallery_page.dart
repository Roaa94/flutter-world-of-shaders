import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/images.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item_page.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_gallery.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: InteractiveGallery(
        enableDistortion: false,
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
            child: GalleryItem(
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
