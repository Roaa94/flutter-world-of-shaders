
import 'package:flutter/material.dart';

Route<dynamic> createFadeInRoute({required RoutePageBuilder routePageBuilder}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    reverseTransitionDuration: const Duration(milliseconds: 700),
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
