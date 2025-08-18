import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_storage.dart';
import 'package:ilolo/utils/style.dart';

// List of data to cycle through on an onboarding screen
final List<OnboardingPageData> onBoardData = [
  OnboardingPageData(
    title: "Broaden Your Horizon",
    description:
        "Explore your favorite products at the wimps of your finger tips",
    imagePath: "assets/images/onboard_1.png",
  ),
  OnboardingPageData(
    title: "Reach for the stars",
    description:
        "Explore your favorite products all around the you, in different cities and town",
    imagePath: 'assets/images/onboard_2.png',
  ),
  OnboardingPageData(
    title: "Take the Next step",
    description: "flexible and easy to use features",
    imagePath: 'assets/images/onboard_3.png',
  ),
];

class OnboardingPageData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onNextTap() async {
    if (_currentPage < onBoardData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      await AppStorage().onboardUser();
      if (mounted) {
        GoRouter.of(context).go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onBoardData.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    data: onBoardData[index],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Page indicator dots
                  Row(
                    children: List.generate(
                      onBoardData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: index == _currentPage ? 15 : 12,
                        height: index == _currentPage ? 15 : 12,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? const Color(0xffC92125)
                              : const Color(0xffC4C4C4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Next/Done button
                  InkWell(
                    onTap: _onNextTap,
                    child: Container(
                      width: 254,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: mainColor,
                      ),
                      child: Text(
                        _currentPage == onBoardData.length - 1
                            ? "Done"
                            : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(data.imagePath),
          const SizedBox(height: 30),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
