import 'dart:developer';

import 'package:flutter/material.dart';

typedef InteractiveGridItemBuilder = Widget Function(
  BuildContext context,
  int index,
);

class InteractiveGrid extends StatefulWidget {
  const InteractiveGrid({
    super.key,
    required this.viewportSize,
    required this.children,
    this.crossAxisCount = 3,
    this.onScrollStart,
    this.onScrollEnd,
    this.enableSnapping = true,
    required this.snapDuration,
  });

  final Size viewportSize;
  final List<Widget> children;
  final int crossAxisCount;
  final VoidCallback? onScrollStart;
  final VoidCallback? onScrollEnd;
  final bool enableSnapping;
  final Duration snapDuration;

  int get mainAxisCount => (children.length / crossAxisCount).ceil();

  double get gridWidth => viewportSize.width * crossAxisCount;

  double get gridHeight => viewportSize.height * mainAxisCount;

  @override
  State<InteractiveGrid> createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> {
  Duration _animationDuration = Duration.zero;
  final _gridOffsetNotifier = ValueNotifier<Offset>(Offset.zero);
  Offset _panStartOffset = Offset.zero;

  static const double tolerance = 20;

  void _onPanStart(DragStartDetails details) {
    _panStartOffset = _gridOffsetNotifier.value;
    widget.onScrollStart?.call();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final newOffset = _gridOffsetNotifier.value + details.delta;
    _gridOffsetNotifier.value = newOffset.clamp(
      Offset(
        -(widget.gridWidth - widget.viewportSize.width),
        -(widget.gridHeight - widget.viewportSize.height),
      ),
      Offset.zero,
    );
  }

  Offset _calculatePannedViewports(
    Offset panStartOffset,
    Offset panEndOffset,
    Size viewportSize, {
    double tolerance = tolerance,
  }) {
    final panDelta = panEndOffset - panStartOffset;
    log('panDelta: $panDelta');

    return Offset(
      panEndOffset.dx / widget.viewportSize.width,
      panEndOffset.dy / widget.viewportSize.height,
    ).floorOrCeil(panDelta, tolerance: tolerance);
  }

  Offset _calculatePanEndGridOffset(
    Offset panStartOffset,
    Offset panEndOffset, {
    double tolerance = tolerance,
  }) {
    final pannedViewports = _calculatePannedViewports(
      panStartOffset,
      panEndOffset,
      widget.viewportSize,
      tolerance: tolerance,
    );
    log('pannedViewports: $pannedViewports');

    return Offset(
      pannedViewports.dx * widget.viewportSize.width,
      pannedViewports.dy * widget.viewportSize.height,
    );
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    widget.onScrollEnd?.call();
    if (widget.enableSnapping) {
      final panEndOffset = _gridOffsetNotifier.value;

      _animationDuration = widget.snapDuration;
      _gridOffsetNotifier.value = _calculatePanEndGridOffset(
        _panStartOffset,
        panEndOffset,
      );

      await Future<dynamic>.delayed(_animationDuration);
      _animationDuration = Duration.zero;
    }
  }

  @override
  void initState() {
    log('Viewport Dimensions: '
        '(${widget.viewportSize.width}, ${widget.viewportSize.height})');
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
                childAspectRatio:
                    widget.viewportSize.width / widget.viewportSize.height,
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
    final dTolerance = Offset(
      delta.dx.abs() / delta.dx * tolerance,
      delta.dy.abs() / delta.dy * tolerance,
    );

    return Offset(
      delta.dx < dTolerance.dx ? dx.floorToDouble() : dx.ceilToDouble(),
      delta.dy < dTolerance.dy ? dy.floorToDouble() : dy.ceilToDouble(),
    );
  }
}
