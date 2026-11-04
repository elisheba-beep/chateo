import 'dart:math' as math;

import 'package:chateo/core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class ChatDoodleBackground extends StatelessWidget {
  const ChatDoodleBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final color = isLight
        ? AppColors.primaryBrand.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.045);

    return Stack(
      children: [
        Positioned.fill(
          // own layer: the pattern is painted once, not on every message
          child: RepaintBoundary(child: CustomPaint(painter: _DoodlePainter(color))),
        ),
        child,
      ],
    );
  }
}

typedef _Glyph = ({int kind, double dx, double dy, double rot, double scale});

class _DoodlePainter extends CustomPainter {
  _DoodlePainter(this.color);
  final Color color;

  static const _tile = 180.0;
  static const List<_Glyph> _glyphs = [
    (kind: 0, dx: 26, dy: 28, rot: -0.20, scale: 1.0), // speech bubble
    (kind: 1, dx: 118, dy: 22, rot: 0.30, scale: 0.9), // heart
    (kind: 2, dx: 156, dy: 78, rot: 0.10, scale: 0.8), // star
    (kind: 3, dx: 58, dy: 88, rot: -0.30, scale: 1.0), // paper plane
    (kind: 4, dx: 104, dy: 66, rot: 0.0, scale: 1.0), // sparkle
    (kind: 5, dx: 18, dy: 142, rot: 0.0, scale: 1.0), // ring
    (kind: 0, dx: 124, dy: 132, rot: 0.25, scale: 0.8),
    (kind: 1, dx: 70, dy: 150, rot: -0.25, scale: 0.7),
    (kind: 2, dx: 164, dy: 150, rot: 0.40, scale: 0.6),
    (kind: 4, dx: 36, dy: 62, rot: 0.0, scale: 0.8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    var row = 0;
    for (var y = 0.0; y < size.height; y += _tile, row++) {
      final startX = row.isOdd ? -_tile / 2 : 0.0; // brick offset
      for (var x = startX; x < size.width; x += _tile) {
        for (final g in _glyphs) {
          canvas
            ..save()
            ..translate(x + g.dx, y + g.dy)
            ..rotate(g.rot)
            ..scale(g.scale);
          _draw(canvas, paint, g.kind);
          canvas.restore();
        }
      }
    }
  }

  // Every glyph is drawn around (0,0) in a ~24px box.
  void _draw(Canvas canvas, Paint paint, int kind) {
    switch (kind) {
      case 0: // speech bubble
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(-11, -8, 22, 16),
            const Radius.circular(6),
          ),
          paint,
        );
        canvas.drawPath(
          Path()..moveTo(-5, 8)..lineTo(-8, 13)..lineTo(0, 8),
          paint,
        );
      case 1: // heart
        canvas.drawPath(
          Path()
            ..moveTo(0, 8)
            ..cubicTo(-14, -2, -8, -12, 0, -5)
            ..cubicTo(8, -12, 14, -2, 0, 8),
          paint,
        );
      case 2: // star
        final star = Path();
        for (var i = 0; i < 10; i++) {
          final r = i.isEven ? 10.0 : 4.5;
          final a = -math.pi / 2 + i * math.pi / 5;
          final p = Offset(r * math.cos(a), r * math.sin(a));
          i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
        }
        canvas.drawPath(star..close(), paint);
      case 3: // paper plane
        canvas.drawPath(
          Path()
            ..moveTo(-11, 0)
            ..lineTo(11, -8)
            ..lineTo(4, 8)
            ..lineTo(-1, 2)
            ..close(),
          paint,
        );
        canvas.drawLine(const Offset(-1, 2), const Offset(11, -8), paint);
      case 4: // sparkle
        canvas
          ..drawLine(const Offset(-4, 0), const Offset(4, 0), paint)
          ..drawLine(const Offset(0, -4), const Offset(0, 4), paint);
      default: // small ring
        canvas.drawCircle(Offset.zero, 3, paint);
    }
  }

  @override
  bool shouldRepaint(_DoodlePainter old) => old.color != color;
}