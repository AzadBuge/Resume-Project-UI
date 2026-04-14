import 'dart:math';
import 'package:flutter/material.dart';

class SparkleAnimation extends StatefulWidget {
  const SparkleAnimation({super.key});

  @override
  State<SparkleAnimation> createState() => _SparkleAnimationState();
}

class _SparkleAnimationState extends State<SparkleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final Random random = Random();

  final List<_Sparkle> sparkles = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // generate sparkles
    for (int i = 0; i < 40; i++) {
      sparkles.add(_Sparkle(random));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _SparklePainter(sparkles, controller.value),
          );
        },
      ),
    );
  }
}

class _Sparkle {
  double x = 0;
  double y = 0;
  double size = 0;
  double speed = 0;
  double opacity = 0;

  _Sparkle(Random random) {
    x = random.nextDouble();
    y = random.nextDouble();
    size = random.nextDouble() * 3 + 1;
    speed = random.nextDouble() * 0.8 + 0.2;
    opacity = random.nextDouble();
  }
}

class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final double progress;

  _SparklePainter(this.sparkles, this.progress);

@override
void paint(Canvas canvas, Size size) {
  final paint = Paint();

  final colors = [
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
  ];

  for (var s in sparkles) {
    // smooth infinite movement (NO reset jump)
    final offsetY =
        (s.y * size.height + (progress * 2000 * s.speed)) % size.height;

    final offsetX =
        (s.x * size.width + (progress * 50 * s.speed)) % size.width;

    paint.color = colors[s.hashCode % colors.length]
        .withOpacity(0.7 * s.opacity);

    canvas.drawCircle(
      Offset(offsetX, offsetY),
      s.size,
      paint,
    );
  }
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}