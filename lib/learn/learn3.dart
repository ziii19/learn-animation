import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:learn_animate/learn/learn4.dart';

class Learn3 extends StatelessWidget {
  const Learn3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: const Text('Eye Tracking Animation'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Learn4()),
                );
              },
            )
          ],
        ),
        body: const Center(
          child: EyeWidget(),
        ));
  }
}

class EyeWidget extends StatefulWidget {
  const EyeWidget({super.key});

  @override
  State<EyeWidget> createState() => _EyeWidgetState();
}

class _EyeWidgetState extends State<EyeWidget>
    with SingleTickerProviderStateMixin {
  Offset leftEyePosition = const Offset(150, 200);
  Offset rightEyePosition = const Offset(260, 200);
  double eyeRadius = 50;

  Offset leftPupilPosition = const Offset(150, 200);
  Offset rightPupilPosition = const Offset(260, 200);

  Timer? _tapUpTimer;
  final Duration tapUpDelay = const Duration(seconds: 3);

  late AnimationController _controller;
  late Animation<Offset> _leftPupilAnimation;
  late Animation<Offset> _rightPupilAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _leftPupilAnimation =
        Tween<Offset>(begin: leftPupilPosition, end: leftPupilPosition)
            .animate(_controller);
    _rightPupilAnimation =
        Tween<Offset>(begin: rightPupilPosition, end: rightPupilPosition)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tapUpTimer?.cancel();

    super.dispose();
  }

  void _movePupils(Offset leftPosition, Offset? rightPosition) {
    setState(() {
      _leftPupilAnimation =
          Tween<Offset>(begin: leftPupilPosition, end: leftPosition)
              .animate(_controller);
      _rightPupilAnimation =
          Tween<Offset>(begin: rightPupilPosition, end: rightPosition)
              .animate(_controller);

      _controller.forward(from: 0);

      _leftPupilAnimation.addListener(() {
        setState(() {
          leftPupilPosition = _leftPupilAnimation.value;
        });
      });
      _rightPupilAnimation.addListener(() {
        setState(() {
          rightPupilPosition = _rightPupilAnimation.value;
        });
      });
    });
  }

  void _handleTapDown(TapDownDetails details) {
    _tapUpTimer?.cancel();

    _movePupils(details.localPosition, details.localPosition);
  }

  void _handleTapUp(TapUpDetails details) {
    _tapUpTimer?.cancel();

    _tapUpTimer = Timer(tapUpDelay, () {
      _movePupils(const Offset(150, 200), const Offset(250, 200));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onPanUpdate: (details) {
        setState(() {
          leftPupilPosition = details.localPosition;
          rightPupilPosition = details.localPosition;
        });
      },
      onPanEnd: (details) {
        Future.delayed(const Duration(seconds: 4), () {
          _movePupils(const Offset(150, 200), const Offset(250, 200));
        });
      },
      child: Stack(
        children: [
          SizedBox(
            width: 400,
            height: 400,
            child: CustomPaint(
              painter: DoubleEyePainter(
                leftEyeCenter: leftEyePosition,
                rightEyeCenter: rightEyePosition,
                eyeRadius: eyeRadius,
                leftPupilOffset:
                    _calculatePupilOffset(leftEyePosition, leftPupilPosition),
                rightPupilOffset:
                    _calculatePupilOffset(rightEyePosition, rightPupilPosition),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Offset _calculatePupilOffset(Offset eyeCenter, Offset pupilTarget) {
    final dx = pupilTarget.dx - eyeCenter.dx;
    final dy = pupilTarget.dy - eyeCenter.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final maxDistance = eyeRadius / 2;

    if (distance < maxDistance) {
      return pupilTarget;
    } else {
      final angle = atan2(dy, dx);
      return Offset(
        eyeCenter.dx + cos(angle) * maxDistance,
        eyeCenter.dy + sin(angle) * maxDistance,
      );
    }
  }
}

class DoubleEyePainter extends CustomPainter {
  final Offset leftEyeCenter;
  final Offset rightEyeCenter;
  final double eyeRadius;
  final Offset leftPupilOffset;
  final Offset rightPupilOffset;

  DoubleEyePainter({
    required this.leftEyeCenter,
    required this.rightEyeCenter,
    required this.eyeRadius,
    required this.leftPupilOffset,
    required this.rightPupilOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawEye(canvas, leftEyeCenter, leftPupilOffset);

    _drawEye(canvas, rightEyeCenter, rightPupilOffset);
  }

  void _drawEye(Canvas canvas, Offset eyeCenter, Offset pupilOffset) {
    Paint eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(eyeCenter, eyeRadius, eyePaint);

    Paint eyeBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(eyeCenter, eyeRadius, eyeBorderPaint);

    Paint pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(pupilOffset, eyeRadius / 3, pupilPaint);

    Paint pupilReflectionPaint = Paint()..color = Colors.white;
    Offset reflectionOffset = Offset(pupilOffset.dx - 5, pupilOffset.dy - 5);
    canvas.drawCircle(reflectionOffset, eyeRadius / 8, pupilReflectionPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
