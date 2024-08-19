import 'package:expenz/constants/colors.dart';
import 'package:expenz/constants/constants.dart';
import 'package:flutter/material.dart';

class SharedOnboardScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;

  const SharedOnboardScreen(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding + 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 300, fit: BoxFit.cover),
          const SizedBox(
            height: 20,
          ),
          Text(
            textAlign: TextAlign.center,
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            textAlign: TextAlign.center,
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: kGrey,
            ),
          )
        ],
      ),
    );
  }
}
