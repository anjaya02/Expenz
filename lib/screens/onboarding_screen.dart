import 'package:expenz/constants/colors.dart';
import 'package:expenz/data/onboarding_data.dart';
import 'package:expenz/screens/onboarding/front_page.dart';
import 'package:expenz/screens/onboarding/shared_onboard_screen.dart';
import 'package:expenz/screens/userdata_screen.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Page controller
  final PageController _controller = PageController();
  bool showDetailsPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Onboarding screen
                PageView(
                  controller: _controller,
                  onPageChanged: (value) {
                    setState(() {
                      showDetailsPage = value == 3;
                    });
                  },
                  children: [
                    const FrontPage(),
                    SharedOnboardScreen(
                      title: OnboardingData.onboardingDataList[0].title,
                      imagePath: OnboardingData.onboardingDataList[0].imagePath,
                      description:
                          OnboardingData.onboardingDataList[0].description,
                    ),
                    SharedOnboardScreen(
                      title: OnboardingData.onboardingDataList[1].title,
                      imagePath: OnboardingData.onboardingDataList[1].imagePath,
                      description:
                          OnboardingData.onboardingDataList[1].description,
                    ),
                    SharedOnboardScreen(
                      title: OnboardingData.onboardingDataList[2].title,
                      imagePath: OnboardingData.onboardingDataList[2].imagePath,
                      description:
                          OnboardingData.onboardingDataList[2].description,
                    ),
                  ],
                ),
                // Page dot indicator
                Positioned(
                  bottom:
                      100, // Adjusted to avoid overlap with navigation button
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                      effect: const WormEffect(
                        activeDotColor: kMainColor,
                        dotColor: Color(0xffC0C0C0),
                      ),
                    ),
                  ),
                ),
                // Navigation button
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    child: GestureDetector(
                      onTap: () {
                        if (showDetailsPage) {
                          // Navigate to the user data screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserdataScreen(),
                            ),
                          );
                        } else {
                          _controller.animateToPage(
                            _controller.page!.toInt() + 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: CustomButton(
                        buttonName: showDetailsPage ? "Get Started" : "Next",
                        buttonColor: kMainColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
