import 'package:flutter/material.dart';

class MapSkeletonView extends StatelessWidget {
  const MapSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      color: bgColor,
      child: Stack(
        children: [
          /// Background (fake map tiles)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade200,
                    Colors.grey.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          /// Fake roads
          Positioned.fill(child: CustomPaint(painter: _RoadsPainter())),

          /// Fake markers
          ...List.generate(
            7,
            (index) => Positioned(
              top: 100 + index * 90,
              left: index.isEven ? 80 : 220,
              child: Icon(
                Icons.location_on,
                size: 28,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
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
      final path = Path()
        ..moveTo(0, size.height * (i / 6))
        ..quadraticBezierTo(
          size.width / 2,
          size.height * (i / 6) + 40,
          size.width,
          size.height * (i / 6),
        );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
