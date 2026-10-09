import 'dart:convert';

import '../domain/recipe.dart';

/// Steps live in one JSON column: they are always read as a whole and never queried.
String encodeSteps(Iterable<RecipeStep> steps) => jsonEncode([
      for (final step in steps)
        {
          if (step.name != null) 'name': step.name,
          'text': step.text,
          if (step.note != null) 'note': step.note,
          if (step.images.isNotEmpty) 'images': [for (final image in step.images) {'key': image.key, 'url': image.url}],
          if (step.timerSeconds != null) 'timerSeconds': step.timerSeconds,
          if (step.timerLabel != null) 'timerLabel': step.timerLabel,
        },
    ]);

/// Tolerates rows saved before step names, notes and photos existed.
List<RecipeStep> decodeSteps(String json) => [
      for (final raw in jsonDecode(json) as List<dynamic>)
        RecipeStep(
          name: (raw as Map<String, dynamic>)['name'] as String?,
          text: raw['text'] as String,
          note: raw['note'] as String?,
          images: [
            for (final image in (raw['images'] as List<dynamic>?) ?? const [])
              RecipeStepImage(key: (image as Map<String, dynamic>)['key'] as String, url: image['url'] as String?),
          ],
          timerSeconds: raw['timerSeconds'] as int?,
          timerLabel: raw['timerLabel'] as String?,
        ),
    ];
