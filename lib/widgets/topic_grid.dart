import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'corner_mascot.dart';

class TopicGrid extends StatelessWidget {
  final List<Widget> children;
  final bool showMascotPair;

  const TopicGrid({
    super.key,
    required this.children,
    this.showMascotPair = false,
  });
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(20) / 20;
      return CustomScrollView(
        semanticChildCount: children.length,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 12),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth >= 320 * math.max(1, scale)
                    ? 2
                    : 1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 210 + 80 * math.max(0, scale - 1),
              ),
              delegate: SliverChildListDelegate(children),
            ),
          ),
          if (showMascotPair)
            SliverToBoxAdapter(child: _mascotPair(constraints.maxWidth))
          else
            SliverLayoutBuilder(
              builder: (context, footer) {
                const mascot = Mascot.bunny;
                const size = 64.0;
                final canvas = mascot.canvasFor(size);
                final spareHeight =
                    footer.viewportMainAxisExtent -
                    footer.precedingScrollExtent;
                if (spareHeight < canvas.height ||
                    footer.crossAxisExtent < canvas.width) {
                  return const SliverToBoxAdapter();
                }
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: canvas.height,
                    child: const Stack(
                      children: [
                        CornerMascot(
                          mascot: mascot,
                          size: size,
                          side: MascotSide.right,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      );
    },
  );

  Widget _mascotPair(double width) {
    const fox = Mascot.fox;
    const bunny = Mascot.bunny;
    final sideInset = math.min(16.0, width / 8);
    final gap = math.min(12.0, width / 8);
    final slotWidth = (width - 2 * sideInset - gap) / 2;
    final size = math.min(
      130.0,
      slotWidth / math.max(fox.canvasFor(1).width, bunny.canvasFor(1).width),
    );
    final foxCanvas = fox.canvasFor(size);
    final bunnyCanvas = bunny.canvasFor(size);
    // Align the characters' feet despite the different transparent margins.
    final bunnyLift = fox.bottomMarginFor(size) - bunny.bottomMarginFor(size);
    return SizedBox(
      height: math.max(foxCanvas.height, bunnyCanvas.height + bunnyLift),
      child: Stack(
        children: [
          CornerMascot(
            mascot: fox,
            size: size,
            side: MascotSide.left,
            sideInset: sideInset + (slotWidth - foxCanvas.width) / 2,
          ),
          CornerMascot(
            mascot: bunny,
            size: size,
            side: MascotSide.right,
            sideInset: sideInset + (slotWidth - bunnyCanvas.width) / 2,
            bottomInset: bunnyLift,
          ),
        ],
      ),
    );
  }
}
