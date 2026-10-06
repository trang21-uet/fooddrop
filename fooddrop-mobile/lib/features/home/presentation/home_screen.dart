import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Food Drop', style: textTheme.headlineLarge),
            const SizedBox(height: 12),
            Text('Open a case, get a dish, start cooking.', style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
