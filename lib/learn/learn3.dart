
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:learn_animate/learn/learn4.dart';

import 'controller/eye_controller.dart';

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

class EyeWidget extends StatelessWidget {
  const EyeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EyeController());

    return GestureDetector(
      onTapDown: (details) => controller.handleTapDown(details.localPosition),
      onTapUp: (_) => controller.handleTapUp(),
      onPanUpdate: (details) {
        controller.leftPupilPosition.value = details.localPosition;
        controller.rightPupilPosition.value = details.localPosition;
      },
      onPanEnd: (_) => controller.resetPupilsAfterDelay(const Duration(seconds: 4)),
      child: Stack(
        children: [
          SizedBox(
            width: 400,
            height: 400,
            child: AnimatedBuilder(
              animation: controller.controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: EyePainter(
                    leftEyeCenter: controller.leftEyePosition,
                    rightEyeCenter: controller.rightEyePosition,
                    eyeRadius: controller.eyeRadius,
                    leftPupilOffset: PupilHelper.calculatePupilOffset(
                        controller.leftEyePosition,
                        controller.leftPupilPosition.value,
                        controller.eyeRadius),
                    rightPupilOffset: PupilHelper.calculatePupilOffset(
                        controller.rightEyePosition,
                        controller.rightPupilPosition.value,
                        controller.eyeRadius),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EyePainter extends CustomPainter {
  final Offset leftEyeCenter;
  final Offset rightEyeCenter;
  final double eyeRadius;
  final Offset leftPupilOffset;
  final Offset rightPupilOffset;

  EyePainter({
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

class PupilHelper {
  static Offset calculatePupilOffset(
      Offset eyeCenter, Offset pupilTarget, double eyeRadius) {
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



////////// IF CHANGE TO USE ASSETS SVG
/*
class EyeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EyeController());

    return GestureDetector(
      onTapDown: (details) => controller.handleTapDown(details.localPosition),
      onTapUp: (_) => controller.handleTapUp(),
      onPanUpdate: (details) {
        controller.leftPupilPosition.value = details.localPosition;
        controller.rightPupilPosition.value = details.localPosition;
      },
      onPanEnd: (_) {
        Future.delayed(const Duration(seconds: 4), () {
          controller.movePupils(controller.leftEyePosition, controller.rightEyePosition);
        });
      },
      child: Stack(
        children: [
          // Menggunakan SVG untuk menggambar mata kiri
          Positioned(
            left: controller.leftEyePosition.dx - controller.eyeRadius,
            top: controller.leftEyePosition.dy - controller.eyeRadius,
            child: SvgPicture.asset(
              'assets/eye.svg',
              width: controller.eyeRadius * 2,
              height: controller.eyeRadius * 2,
            ),
          ),
          // Menggunakan SVG untuk menggambar mata kanan
          Positioned(
            left: controller.rightEyePosition.dx - controller.eyeRadius,
            top: controller.rightEyePosition.dy - controller.eyeRadius,
            child: SvgPicture.asset(
              'assets/eye.svg',
              width: controller.eyeRadius * 2,
              height: controller.eyeRadius * 2,
            ),
          ),
          // Menggunakan SVG untuk menggambar pupil kiri yang bisa bergerak
          Obx(() => Positioned(
                left: controller.leftPupilPosition.value.dx - controller.eyeRadius / 3,
                top: controller.leftPupilPosition.value.dy - controller.eyeRadius / 3,
                child: SvgPicture.asset(
                  'assets/pupil.svg',
                  width: controller.eyeRadius / 1.5,
                  height: controller.eyeRadius / 1.5,
                ),
              )),
          // Menggunakan SVG untuk menggambar pupil kanan yang bisa bergerak
          Obx(() => Positioned(
                left: controller.rightPupilPosition.value.dx - controller.eyeRadius / 3,
                top: controller.rightPupilPosition.value.dy - controller.eyeRadius / 3,
                child: SvgPicture.asset(
                  'assets/pupil.svg',
                  width: controller.eyeRadius / 1.5,
                  height: controller.eyeRadius / 1.5,
                ),
              )),
        ],
      ),
    );
  }
}

*/