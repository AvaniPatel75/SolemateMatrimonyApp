import 'package:flutter/material.dart';
import 'dart:async';
import 'package:login_screen/onBoardingScreen.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideUp = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Navigate to next screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Onboardingscreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[400],
      body: Stack(
        children: [
          // Animated hearts
          ..._buildBackgroundHearts(),

          // Animated logo + text
          Center(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Right Life Partner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Find your perfect match',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundHearts() {
    // Each heart fades in with a delay
    final hearts = [
      const Offset(30, 50),
      const Offset(-20, 100),
      const Offset(70, -70),
      const Offset(-80, -120),
      const Offset(100, 200),
      const Offset(-150, 150),
    ];

    return List.generate(hearts.length, (i) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final opacity = (_controller.value - i * 0.1).clamp(0.0, 1.0);
          final offsetY = (1 - opacity) * 30;

          return Positioned(
            top: hearts[i].dy > 0 ? hearts[i].dy : null,
            bottom: hearts[i].dy < 0 ? -hearts[i].dy : null,
            left: hearts[i].dx > 0 ? hearts[i].dx : null,
            right: hearts[i].dx < 0 ? -hearts[i].dx : null,
            child: Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, offsetY),
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink[(i + 1) * 100],
                  size: 30 + i * 5,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
