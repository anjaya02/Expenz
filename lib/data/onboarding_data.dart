import 'package:expenz/models/onboarding_model.dart';

class OnboardingData {
  static final List<OnboardingModel> onboardingDataList = [
    OnboardingModel(
        title: "Gain total control\n  of your money",
        imagePath: "assets/images/onboard_1.png",
        description:
            "Become your own money manager\n and make every cent count"),
    OnboardingModel(
        title: "Know where your\n money goes",
        imagePath: "assets/images/onboard_2.png",
        description:
            "Track your transaction easily,\nwith categories and financial report"),
    OnboardingModel(
        title: "Planning ahead",
        imagePath: "assets/images/onboard_3.png",
        description: "Setup your budget for each category\n so you in control")
  ];
}
