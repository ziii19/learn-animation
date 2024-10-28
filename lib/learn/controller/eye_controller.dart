import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EyeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final leftEyePosition = const Offset(150, 200);
  final rightEyePosition = const Offset(260, 200);
  final eyeRadius = 50.0;

  var leftPupilPosition = const Offset(150, 200).obs;
  var rightPupilPosition = const Offset(260, 200).obs;

  Timer? _tapUpTimer;
  final tapUpDelay = const Duration(seconds: 3);

  late AnimationController controller;
  late Animation<Offset> leftPupilAnimation;
  late Animation<Offset> rightPupilAnimation;

  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    leftPupilAnimation = Tween<Offset>(
            begin: leftPupilPosition.value, end: leftPupilPosition.value)
        .animate(controller);
    rightPupilAnimation = Tween<Offset>(
            begin: rightPupilPosition.value, end: rightPupilPosition.value)
        .animate(controller);
  }

  @override
  void onClose() {
    controller.dispose();
    _tapUpTimer?.cancel();
    super.onClose();
  }

  void movePupils(Offset leftTarget, Offset rightTarget) {
    leftPupilAnimation =
        Tween<Offset>(begin: leftPupilPosition.value, end: leftTarget)
            .animate(controller);
    rightPupilAnimation =
        Tween<Offset>(begin: rightPupilPosition.value, end: rightTarget)
            .animate(controller);

    controller.addListener(() {
      leftPupilPosition.value = leftPupilAnimation.value;
      rightPupilPosition.value = rightPupilAnimation.value;
    });

    controller.forward(from: 0).then((_) {
      leftPupilPosition.value = leftTarget;
      rightPupilPosition.value = rightTarget;
      controller.removeListener(() {});
    });
  }

  void handleTapDown(Offset position) {
    _tapUpTimer?.cancel();
    movePupils(position, position);
  }

  void handleTapUp() {
    _tapUpTimer?.cancel();
    _tapUpTimer = Timer(tapUpDelay, () {
      movePupils(leftEyePosition, rightEyePosition);
    });
  }

  void resetPupilsAfterDelay(Duration delay) {
    _tapUpTimer?.cancel();
    _tapUpTimer = Timer(delay, () {
      leftPupilPosition.value = const Offset(150, 200);
      rightPupilPosition.value = const Offset(260, 200);
    });
  }
}
