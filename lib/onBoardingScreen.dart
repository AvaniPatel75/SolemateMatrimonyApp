import 'package:flutter/material.dart';
import 'package:login_screen/logonScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  bool onLastPage = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, String>> onboardingSlides = [
    {
      'image': 'assets/3561190.jpg',
      'title': 'Find Your Life Partner',
      'description': 'Search verified profiles to find your compatible life partner.',
    },
    {
      'image': 'assets/3809110.jpg',
      'title': 'Celebrate Traditions',
      'description': 'Discover matches that share your culture, community, and values.',
    },
    {
      'image': 'assets/4179725.jpg',
      'title': 'Happy Stories',
      'description': 'Be inspired by thousands of success stories from our members.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF4F9),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingSlides.length,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == onboardingSlides.length - 1);
              });
              // Reset animation only on the first page
              if (index == 0) {
                _animationController.reset();
                _animationController.forward();
              }
            },
            itemBuilder: (context, index) {
              final slide = onboardingSlides[index];
              // Only apply animation to the first slide
              if (index == 0) {
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - _animation.value)),
                        child: OnboardingSlide(
                          imagePath: slide['image']!,
                          title: slide['title']!,
                          description: slide['description']!,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return OnboardingSlide(
                  imagePath: slide['image']!,
                  title: slide['title']!,
                  description: slide['description']!,
                );
              }
            },
          ),
        ],
      ),
      bottomSheet: Container(
        height: 150,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: onboardingSlides.length,
                  effect: const WormEffect(
                    activeDotColor: Color(0xFFfb6f92),
                    dotColor: Color(0xFFE0E0E0),
                    dotHeight: 10.0,
                    dotWidth: 10.0,
                    spacing: 8.0,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: onLastPage
                      ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Logonscreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFfb6f92),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                      : ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFfb6f92),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingSlide({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 80.0, 40.0, 200.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF888888),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}