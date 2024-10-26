import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learn_animate/learn/learn3.dart';

class Learn2 extends StatelessWidget {
  const Learn2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Learn3()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: AnimatedCharacter(),
      ),
    );
  }
}

class AnimatedCharacter extends StatefulWidget {
  const AnimatedCharacter({super.key});

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter>
    with TickerProviderStateMixin {
  double eyeX = 0.0;
  double eyeY = 0.0;
  bool isHandUp = false;
  Random random = Random();

  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _waveAnimation = Tween<double>(begin: 0, end: 40).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _randomizeEyeMovement();
  }

  void _randomizeEyeMovement() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        eyeX = random.nextDouble() * 20 - 10;
        eyeY = random.nextDouble() * 20 - 10;
      });
      _randomizeEyeMovement();
    });
  }

  void _moveHand() {
    setState(() {
      isHandUp = !isHandUp;
      if (isHandUp) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _moveHand();
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            radius: 100,
            backgroundColor: Colors.white,
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 60 + eyeX,
            top: 60 + eyeY,
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            right: 60 - eyeX,
            top: 60 + eyeY,
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: isHandUp ? -40 : 0,
            bottom: isHandUp ? 40 : -40,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    isHandUp ? -_waveAnimation.value : 0,
                    isHandUp ? -_waveAnimation.value : 0,
                  ),
                  child: child,
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: -40,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
