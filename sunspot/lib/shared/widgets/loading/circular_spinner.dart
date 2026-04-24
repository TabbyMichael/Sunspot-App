import 'package:flutter/material.dart';

class CircularSpinner extends StatefulWidget {
  final double size;
  final Color color;

  const CircularSpinner({
    super.key,
    this.size = 40,
    this.color = const Color(0xFFF59E0B),
  });

  @override
  State<CircularSpinner> createState() => _CircularSpinnerState();
}

class _CircularSpinnerState extends State<CircularSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation1 = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 0),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 1),
        weight: 23,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1, end: 1),
        weight: 23,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1, end: 0),
        weight: 23,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 0),
        weight: 10,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 1, curve: Curves.linear),
    ));

    _animation2 = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 0),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 1),
        weight: 23,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1, end: 1),
        weight: 23,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1, end: 0),
        weight: 23,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 0),
        weight: 10,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 1, curve: Curves.linear),
    ));
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
          return Stack(
            children: [
              _buildTriangle(_animation1, 1),
              _buildTriangle(_animation2, -1),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTriangle(Animation<double> animation, int scaleSign) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value;
        
        double scale = 1.0;
        double translateX = 0;
        double translateY = 0;
        double rotation = 0;

        if (progress < 0.1) {
          scale = 1.0;
          translateX = 0;
          translateY = 0;
          rotation = 0;
        } else if (progress < 0.33) {
          final t = (progress - 0.1) / 0.23;
          scale = 1.0;
          translateX = 20 * t;
          translateY = -20 * t;
          rotation = 0;
        } else if (progress < 0.66) {
          final t = (progress - 0.33) / 0.23;
          scale = 1.0;
          translateX = 20;
          translateY = -20;
          rotation = 180 * t;
        } else if (progress < 0.9) {
          final t = (progress - 0.66) / 0.23;
          scale = 1.0;
          translateX = 20 * (1 - t);
          translateY = -20 * (1 - t);
          rotation = 180;
        } else {
          scale = 1.0;
          translateX = 0;
          translateY = 0;
          rotation = 180;
        }

        return Transform(
          transform: Matrix4.identity()
            ..scale(scaleSign * scale, scaleSign * scale)
            ..translate(translateX, translateY)
            ..rotateZ(rotation * 3.14159 / 180),
          alignment: Alignment.center,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _TrianglePainter(color: widget.color),
          ),
        );
      },
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
