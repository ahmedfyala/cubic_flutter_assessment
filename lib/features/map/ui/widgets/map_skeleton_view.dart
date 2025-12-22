import 'package:flutter/material.dart';

class MapSkeletonView extends StatefulWidget {
  const MapSkeletonView({super.key});

  @override
  State<MapSkeletonView> createState() => _MapSkeletonViewState();
}

class _MapSkeletonViewState extends State<MapSkeletonView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shimmer = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _pulse = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      color: bgColor,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Stack(
            children: [
              /// ===== Fake map background (Shimmer)
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment(_shimmer.value - 1, 0),
                      end: Alignment(_shimmer.value, 0),
                      colors: [
                        Colors.grey.shade300,
                        Colors.grey.shade200,
                        Colors.grey.shade300,
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.srcATop,
                  child: Container(color: Colors.grey.shade300),
                ),
              ),

              /// ===== Roads
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5 + (_controller.value * 0.5),
                  child: CustomPaint(painter: _RoadsPainter()),
                ),
              ),

              /// ===== Fake markers (Pulse animation)
              ...List.generate(
                7,
                (index) => Positioned(
                  top: 120 + index * 90,
                  left: index.isEven ? 90 : 240,
                  child: Transform.scale(
                    scale: _pulse.value,
                    child: Icon(
                      Icons.location_on,
                      size: 28,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      final y = size.height * (i / 6);

      final path = Path()
        ..moveTo(0, y)
        ..quadraticBezierTo(size.width / 2, y + 40, size.width, y);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
