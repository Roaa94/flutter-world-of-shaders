import 'dart:developer';

import 'package:flutter/material.dart';

typedef InteractiveGridItemBuilder = Widget Function(
  BuildContext context,
  int index,
);

class InteractiveGrid extends StatefulWidget {
  const InteractiveGrid({
    super.key,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.children,
    this.crossAxisCount = 3,
    this.onScrollStart,
    this.onScrollEnd,
    this.enableSnapping = true,
  });

  final double viewportWidth;
  final double viewportHeight;
  final List<Widget> children;
  final int crossAxisCount;
  final VoidCallback? onScrollStart;
  final VoidCallback? onScrollEnd;
  final bool enableSnapping;

  int get mainAxisCount => (children.length / crossAxisCount).ceil();

  double get gridWidth => viewportWidth * crossAxisCount;

  double get gridHeight => viewportHeight * mainAxisCount;

  @override
  State<InteractiveGrid> createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> {
  Duration _animationDuration = Duration.zero;
  final _gridOffsetNotifier = ValueNotifier<Offset>(Offset.zero);
  Offset _delta = Offset.zero;

  void _onScaleStart(ScaleStartDetails details) {
    widget.onScrollStart?.call();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    _delta = details.focalPointDelta;
    final newOffset = _gridOffsetNotifier.value + details.focalPointDelta;
    // print(newOffset);
    _gridOffsetNotifier.value = newOffset.clamp(
      Offset(
        -(widget.gridWidth - widget.viewportWidth),
        -(widget.gridHeight - widget.viewportHeight),
      ),
      Offset.zero,
    );
  }

  Future<void> _onScaleEnd(ScaleEndDetails details) async {
    widget.onScrollEnd?.call();
    if (widget.enableSnapping) {
      // print('Delta: $_delta');
      final pannedViewportsCountXRaw =
          _gridOffsetNotifier.value.dx / widget.viewportWidth;
      final pannedViewportsCountX = _delta.dx <= 0
          ? pannedViewportsCountXRaw.floor()
          : pannedViewportsCountXRaw.ceil();

      final pannedViewportsCountYRaw =
          _gridOffsetNotifier.value.dy / widget.viewportHeight;
      final pannedViewportsCountY = _delta.dy <= 0
          ? pannedViewportsCountYRaw.floor()
          : pannedViewportsCountYRaw.ceil();

      // Todo: change duration based on velocity
      // print(details.velocity);
      _animationDuration = const Duration(milliseconds: 300);

      _gridOffsetNotifier.value = Offset(
        pannedViewportsCountX * widget.viewportWidth,
        pannedViewportsCountY * widget.viewportHeight,
      );
      await Future<dynamic>.delayed(_animationDuration);
      _animationDuration = Duration.zero;
    }
  }

  @override
  void initState() {
    log('Viewport Dimensions: '
        '(${widget.viewportWidth}, ${widget.viewportHeight})');
    log('Grid Dimensions: (${widget.gridWidth}, ${widget.gridHeight})');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: OverflowBox(
        maxHeight: double.infinity,
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: ValueListenableBuilder(
          valueListenable: _gridOffsetNotifier,
          builder: (BuildContext context, Offset gridOffset, Widget? child) {
            return TweenAnimationBuilder(
              duration: _animationDuration,
              tween: Tween<Offset>(begin: Offset.zero, end: gridOffset),
              builder: (context, Offset offset, Widget? child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setTranslationRaw(offset.dx, offset.dy, 0),
                  child: child,
                );
              },
              child: child,
            );
          },
          child: SizedBox(
            width: widget.gridWidth,
            height: widget.gridHeight,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: widget.viewportWidth / widget.viewportHeight,
              children: widget.children,
            ),
          ),
        ),
      ),
    );
  }
}

extension ClampOffset on Offset {
  Offset clamp(Offset lowerLimit, Offset upperLimit) {
    return Offset(
      dx.clamp(lowerLimit.dx, upperLimit.dx),
      dy.clamp(lowerLimit.dy, upperLimit.dy),
    );
  }
}
