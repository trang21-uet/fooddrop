import 'package:flutter/material.dart';

import 'food_drop_colors.dart';

/// Shown for the instant it takes to read the stored session at launch.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(child: CircularProgressIndicator(color: context.colors.accent)),
      );
}
