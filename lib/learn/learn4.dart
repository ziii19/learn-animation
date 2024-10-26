import 'package:flutter/material.dart';
import 'dart:math';

import 'package:learn_animate/learn/learn1.dart';

class Learn4 extends StatelessWidget {
  const Learn4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Tracking Animation with Containers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearnAnimated1()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: EyeWidget(),
      ),
    );
  }
}

class EyeWidget extends StatefulWidget {
  const EyeWidget({super.key});

  @override
  State<EyeWidget> createState() => _EyeWidgetState();
}

class _EyeWidgetState extends State<EyeWidget> {
  Offset leftEyePosition = const Offset(150, 200);
  Offset rightEyePosition = const Offset(250, 200);
  double eyeRadius = 50;

  Offset targetPosition = const Offset(200, 200);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          targetPosition = details.localPosition;
        });
      },
      child: SizedBox(
        width: 400,
        height: 400,
        child: Stack(
          children: [
            Positioned(
              left: 120,
              top: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: eyeRadius * 2,
                    height: eyeRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                  ),
                  TweenAnimationBuilder(
                    tween: Tween<Offset>(
                        begin: leftEyePosition, end: targetPosition),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    builder: (context, Offset newPupilPosition, child) {
                      Offset pupilOffset = _calculatePupilOffset(
                          leftEyePosition, newPupilPosition);
                      return Transform.translate(
                        offset: Offset(
                          pupilOffset.dx - leftEyePosition.dx,
                          pupilOffset.dy - leftEyePosition.dy,
                        ),
                        child: Container(
                          width: eyeRadius / 1.5,
                          height: eyeRadius / 1.5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: 220,
              top: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: eyeRadius * 2,
                    height: eyeRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                  ),
                  TweenAnimationBuilder(
                    tween: Tween<Offset>(
                        begin: rightEyePosition, end: targetPosition),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    builder: (context, Offset newPupilPosition, child) {
                      Offset pupilOffset = _calculatePupilOffset(
                          rightEyePosition, newPupilPosition);
                      return Transform.translate(
                        offset: Offset(
                          pupilOffset.dx - rightEyePosition.dx,
                          pupilOffset.dy - rightEyePosition.dy,
                        ),
                        child: Container(
                          width: eyeRadius / 1.5,
                          height: eyeRadius / 1.5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
