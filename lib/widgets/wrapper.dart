import 'package:expenz/screens/main_screen.dart';
import 'package:expenz/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  final bool showMainScrren;
  const Wrapper({super.key, required this.showMainScrren});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.showMainScrren
        ? const MainScreen()
        : const OnboardingScreen();
  }
}
