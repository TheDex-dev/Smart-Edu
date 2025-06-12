import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.color = Colors.white,
    this.size = 24,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class GradientLoader extends StatefulWidget {
  final double size;
  final List<Color> colors;

  const GradientLoader({
    super.key,
    this.size = 40,
    this.colors = const [Colors.deepPurple, Colors.deepPurpleAccent],
  });

  @override
  State<GradientLoader> createState() => _GradientLoaderState();
}

class _GradientLoaderState extends State<GradientLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _LoaderPainter(
              animation: _controller,
              colors: widget.colors,
            ),
          );
        },
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Color> colors;

  _LoaderPainter({required this.animation, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

    // Create a gradient that rotates
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * 3.14, // 2 * PI
      colors: [...colors, colors.first],
      transform: GradientRotation(animation.value * 2 * 3.14),
    );

    paint.shader = gradient.createShader(rect);

    // Draw the circle
    canvas.drawArc(
      rect.deflate(paint.strokeWidth / 2),
      0,
      animation.value * 2 * 3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoaderPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}
