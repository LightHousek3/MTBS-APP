import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppHashLoader extends StatefulWidget {
  const AppHashLoader({
    this.size = 42,
    this.color = const Color(0xFFE30713),
    super.key,
  });

  final double size;
  final Color color;

  @override
  State<AppHashLoader> createState() => _AppHashLoaderState();
}

class _AppHashLoaderState extends State<AppHashLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final phase = _controller.value <= 0.5
              ? _controller.value * 2
              : (1 - _controller.value) * 2;
          final scale = 0.2 + (phase * 0.8);

          return Transform.rotate(
            angle: _controller.value * math.pi * 2,
            child: CustomPaint(
              painter: _HashLoaderPainter(color: widget.color, scale: scale),
            ),
          );
        },
      ),
    );
  }
}

class _HashLoaderPainter extends CustomPainter {
  const _HashLoaderPainter({required this.color, required this.scale});

  final Color color;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final thickness = side * 0.2;
    final offset = side * 0.2;
    final radius = Radius.circular(thickness / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final horizontalWidth = side * scale;
    final horizontalLeft = (side - horizontalWidth) / 2;
    final verticalHeight = side * scale;
    final verticalTop = (side - verticalHeight) / 2;

    void drawRoundRect(Rect rect) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
    }

    drawRoundRect(
      Rect.fromLTWH(horizontalLeft, offset, horizontalWidth, thickness),
    );
    drawRoundRect(
      Rect.fromLTWH(
        horizontalLeft,
        side - offset - thickness,
        horizontalWidth,
        thickness,
      ),
    );
    drawRoundRect(
      Rect.fromLTWH(offset, verticalTop, thickness, verticalHeight),
    );
    drawRoundRect(
      Rect.fromLTWH(
        side - offset - thickness,
        verticalTop,
        thickness,
        verticalHeight,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _HashLoaderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.scale != scale;
  }
}
