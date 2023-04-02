import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_item_page.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({
    super.key,
    required this.imagePath,
    required this.heroTag,
    this.heroEnabled = true,
    this.isPage = false,
  });

  final String imagePath;
  final String heroTag;
  final bool heroEnabled;
  final bool isPage;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: isPage
          ? null
          : () {
              Navigator.of(context).push(
                createFadeInRoute(
                  routePageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    _,
                  ) {
                    return GalleryItemPage(
                      heroTag: heroTag,
                      imagePath: imagePath,
                    );
                  },
                ),
              );
            },
      child: HeroMode(
        enabled: heroEnabled,
        child: Hero(
          tag: heroTag,
          child: Container(
            margin: const EdgeInsets.all(3),
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
    maintainState: false,
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
