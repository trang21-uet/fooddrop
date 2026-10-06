import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/food_drop_app.dart';

void main() {
  runApp(const ProviderScope(child: FoodDropApp()));
}
