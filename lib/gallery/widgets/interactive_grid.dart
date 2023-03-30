import 'package:flutter/gestures.dart';
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
    required this.itemBuilder,
    this.itemsPerRow = 3,
    this.itemsPerCol = 3,
    this.onScrollStart,
    this.onScrollEnd,
  });

  final double viewportWidth;
  final double viewportHeight;
  final InteractiveGridItemBuilder itemBuilder;
  final int itemsPerRow;
  final int itemsPerCol;
  final VoidCallback? onScrollStart;
  final VoidCallback? onScrollEnd;

  double get gridWidth => viewportWidth * itemsPerRow;

  double get gridHeight => viewportHeight * itemsPerCol;

  @override
  State<InteractiveGrid> createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> {
  Duration _animationDuration = Duration.zero;
  Offset _gridOffset = Offset.zero;

  void _onScaleStart(ScaleStartDetails details) {
    widget.onScrollStart?.call();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // print('Scale');
    // print(details.localFocalPoint);
    setState(() {
      _gridOffset += details.focalPointDelta;
    });
  }

  Future<void> _onScaleEnd(ScaleEndDetails details) async {
    final pannedViewportsCountX =
        (_gridOffset.dx / widget.viewportWidth).round();
    final pannedViewportsCountY =
        (_gridOffset.dy / widget.viewportHeight).round();

    setState(() {
      // Todo: change duration based on velocity
      _animationDuration = const Duration(milliseconds: 300);
      _gridOffset = Offset(
        pannedViewportsCountX * widget.viewportWidth,
        pannedViewportsCountY * widget.viewportHeight,
      );
    });
    await Future<dynamic>.delayed(Duration.zero);
    // setState(() {
    //   _animationDuration = Duration.zero;
    // });
    widget.onScrollEnd?.call();
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
        child: TweenAnimationBuilder(
          duration: _animationDuration,
          tween: Tween<Offset>(begin: Offset.zero, end: _gridOffset),
          builder: (context, Offset offset, Widget? child) {
            return Transform.translate(
              offset: offset,
              child: SizedBox(
                width: widget.gridWidth,
                height: widget.gridHeight,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: widget.itemsPerRow,
                  childAspectRatio:
                      widget.viewportWidth / widget.viewportHeight,
                  children: List.generate(
                    widget.itemsPerRow * widget.itemsPerCol,
                    (index) => widget.itemBuilder(context, index),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
