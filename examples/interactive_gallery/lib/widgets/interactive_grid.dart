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
    required this.snapDuration,
  });

  final double viewportWidth;
  final double viewportHeight;
  final List<Widget> children;
  final int crossAxisCount;
  final VoidCallback? onScrollStart;
  final VoidCallback? onScrollEnd;
  final bool enableSnapping;
  final Duration snapDuration;

  int get mainAxisCount => (children.length / crossAxisCount).ceil();

  double get gridWidth => viewportWidth * crossAxisCount;

  double get gridHeight => viewportHeight * mainAxisCount;

  @override
  State<InteractiveGrid> createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> {
  Duration _animationDuration = Duration.zero;
  final _gridOffsetNotifier = ValueNotifier<Offset>(Offset.zero);
  Offset _panStartOffset = Offset.zero;

  static const double toleranceFraction = 0.1;

  double get xTolerance => widget.viewportWidth * toleranceFraction;

  double get yTolerance => widget.viewportWidth * toleranceFraction;

  void _onPanStart(DragStartDetails details) {
    _panStartOffset = _gridOffsetNotifier.value;
    widget.onScrollStart?.call();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final newOffset = _gridOffsetNotifier.value + details.delta;
    _gridOffsetNotifier.value = newOffset.clamp(
      Offset(
        -(widget.gridWidth - widget.viewportWidth),
        -(widget.gridHeight - widget.viewportHeight),
      ),
      Offset.zero,
    );
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    widget.onScrollEnd?.call();
    if (widget.enableSnapping) {
      // Moving diagonally
      final panEndOffset = _gridOffsetNotifier.value;
      final panDelta = panEndOffset - _panStartOffset;
      log('panDelta: $panDelta');

      final pannedViewports = Offset(
        panEndOffset.dx / widget.viewportWidth,
        panEndOffset.dy / widget.viewportHeight,
      ).floorOrCeil(panDelta, tolerance: 20); // Todo: implement tolerance

      _animationDuration = widget.snapDuration;
      _gridOffsetNotifier.value = Offset(
        pannedViewports.dx * widget.viewportWidth,
        pannedViewports.dy * widget.viewportHeight,
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
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: OverflowBox(
        maxHeight: double.infinity,
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: ValueListenableBuilder(
          valueListenable: _gridOffsetNotifier,
          builder: (BuildContext context, Offset gridOffset, Widget? child) {
            return TweenAnimationBuilder(
              duration: _animationDuration,
              curve: Curves.easeOutSine,
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
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: widget.viewportWidth / widget.viewportHeight,
              ),
              itemCount: widget.children.length,
              itemBuilder: (context, index) => widget.children[index],
            ),
          ),
        ),
      ),
    );
  }
}

extension OffsetUtils on Offset {
  Offset clamp(Offset lowerLimit, Offset upperLimit) {
    return Offset(
      dx.clamp(lowerLimit.dx, upperLimit.dx),
      dy.clamp(lowerLimit.dy, upperLimit.dy),
    );
  }

  Offset ceil() {
    return Offset(dx.ceilToDouble(), dy.ceilToDouble());
  }

  Offset floor() {
    return Offset(dx.floorToDouble(), dy.floorToDouble());
  }

  Offset round() {
    return Offset(dx.roundToDouble(), dy.roundToDouble());
  }

  Offset floorOrCeil(Offset delta, {double tolerance = 0}) {
    return Offset(
      delta.dx < 0 ? dx.floorToDouble() : dx.ceilToDouble(),
      delta.dy < 0 ? dy.floorToDouble() : dy.ceilToDouble(),
    );
  }
}
