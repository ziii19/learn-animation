import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Karakter Animasi')),
        body: const CharacterAnimated(),
      ),
    );
  }
}

class CharacterAnimated extends StatefulWidget {
  const CharacterAnimated({super.key});

  @override
  State<CharacterAnimated> createState() => _CharacterAnimatedState();
}

class _CharacterAnimatedState extends State<CharacterAnimated>
    with TickerProviderStateMixin {
  late final AnimationController _eyeController;
  late final Animation<double> _eyeAnimation;

  late final AnimationController _handController;
  late final Animation<Offset> _handAnimation;

  bool isHandWaving = false;

  @override
  void initState() {
    super.initState();

    _eyeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _eyeAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(
        parent: _eyeController,
        curve: Curves.easeInOut,
      ),
    );

    _eyeController.repeat(reverse: true);

    _handController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _handAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
            begin: const Offset(0, 0), end: const Offset(0, -0.3)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
            begin: const Offset(0, -0.3), end: const Offset(0.1, 0.1)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _handController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _eyeController.dispose();
    _handController.dispose();
    super.dispose();
  }

  void _toggleHandWaving() {
    setState(() {
      isHandWaving = !isHandWaving;
      if (isHandWaving) {
        _handController.repeat(reverse: true);
      } else {
        _handController.stop();
        _handController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _toggleHandWaving(),
      child: Scaffold(
        body: Center(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: AnimatedBuilder(
                      animation: _eyeAnimation,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            Positioned(
                              left: 10 - _eyeAnimation.value,
                              top: 12,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10 + _eyeAnimation.value,
                              top: 12,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 80,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SlideTransition(
                          position: _handAnimation,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
