import 'package:flutter/material.dart';

enum MascotSide { left, right }

enum Mascot {
  fox('fox_mascot.png', Size(1024, 1536), 721, 457),
  bunny('bunny_mascot.png', Size(721, 818), 782, 18);

  const Mascot(
    this.fileName,
    this._canvas,
    this._artHeight,
    this._bottomMargin,
  );

  final String fileName;
  final Size _canvas;
  // The visible artwork excludes the faint pixels around the transparent edge.
  final double _artHeight;
  final double _bottomMargin;

  String get imagePath => 'assets/images/mascots/$fileName';

  Size canvasFor(double height) => _canvas * (height / _artHeight);

  double bottomMarginFor(double height) => _bottomMargin * height / _artHeight;
}

/// A decorative layer for the bottom corner of a [Stack].
class CornerMascot extends StatelessWidget {
  final Mascot mascot;

  /// The displayed height of the character, excluding transparent margins.
  final double size;
  final MascotSide side;
  final double sideInset;
  final double bottomInset;

  const CornerMascot({
    super.key,
    required this.mascot,
    required this.size,
    required this.side,
    this.sideInset = 0,
    this.bottomInset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final canvas = mascot.canvasFor(size);
    return Positioned(
      left: side == MascotSide.left ? sideInset : null,
      right: side == MascotSide.right ? sideInset : null,
      bottom: bottomInset,
      child: IgnorePointer(
        child: Image.asset(
          mascot.imagePath,
          width: canvas.width,
          height: canvas.height,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
