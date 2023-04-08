import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:interactive_gallery/widgets/interactive_grid.dart';
import 'package:interactive_gallery/widgets/masonry_grid.dart';

class DistortedInteractiveGrid extends StatefulWidget {
  const DistortedInteractiveGrid({
    super.key,
    this.children = const [],
    this.enableSnapping = true,
    this.enableDistortion = true,
    this.crossAxisCount = 2,
  });

  final List<Widget> children;
  final int crossAxisCount;
  final bool enableSnapping;
  final bool enableDistortion;

  int get maxItemsPerViewport => (children.length / (crossAxisCount * crossAxisCount)).floor();

  @override
  State<DistortedInteractiveGrid> createState() => _DistortedInteractiveGridState();
}

class _DistortedInteractiveGridState extends State<DistortedInteractiveGrid>
    with SingleTickerProviderStateMixin {
  final _distortionAmountNotifier = ValueNotifier<double>(0);
  late List<Widget> viewports;
  static const Duration addDistortionDuration = Duration(milliseconds: 300);
  static const Duration removeDistortionDuration = Duration(milliseconds: 800);
  static Duration snapDuration = Duration(
    milliseconds: removeDistortionDuration.inMilliseconds - 100,
  );

  Duration _distortionDuration = addDistortionDuration;

  List<Widget> _generateViewports() {
    final slicedChildren =
        widget.children.slices(widget.maxItemsPerViewport).toList();

    return List.generate(
      slicedChildren.length,
      (urlsSliceIndex) {
        final childrenSlice = slicedChildren[urlsSliceIndex];

        return MasonryGrid(
          index: urlsSliceIndex,
          children: childrenSlice.toList(),
        );
      },
    );
  }

  void _onGridInteractionStart() {
    _distortionAmountNotifier.value = 0.9;
  }

  Future<void> _onGridInteractionEnd() async {
    _distortionDuration = removeDistortionDuration;
    _distortionAmountNotifier.value = 0.0;
    await Future<dynamic>.delayed(_distortionDuration);
    _distortionDuration = addDistortionDuration;
  }

  @override
  void initState() {
    viewports = _generateViewports();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DistortedInteractiveGrid oldWidget) {
    if (oldWidget.crossAxisCount != widget.crossAxisCount) {
      viewports = _generateViewports();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ValueListenableBuilder(
      valueListenable: _distortionAmountNotifier,
      builder: (context, double distortionAmount, Widget? child) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: distortionAmount),
          curve: Curves.easeOutSine,
          duration: _distortionDuration,
          builder: (context, double distortionAmount, Widget? child) {
            return PincushionDistortion(
              enabled: widget.enableDistortion,
              distortionAmount: distortionAmount,
              child: child!,
            );
          },
          child: child,
        );
      },
      child: InteractiveGrid(
        viewportSize: screenSize,
        crossAxisCount: widget.crossAxisCount,
        enableSnapping: widget.enableSnapping,
        onScrollStart: _onGridInteractionStart,
        onScrollEnd: _onGridInteractionEnd,
        snapDuration: snapDuration,
        children: viewports,
      ),
    );
  }
}
