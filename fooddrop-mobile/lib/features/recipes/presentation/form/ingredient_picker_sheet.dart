import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/api/api_error.dart';
import '../../data/ingredient_catalog.dart';

Future<IngredientOption?> showIngredientPicker(BuildContext context) => showModalBottomSheet<IngredientOption>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const IngredientPickerSheet(),
    );

/// Search the shared ingredient catalog; a missing ingredient can be added on the spot.
class IngredientPickerSheet extends ConsumerStatefulWidget {
  const IngredientPickerSheet({super.key});

  @override
  ConsumerState<IngredientPickerSheet> createState() => _IngredientPickerSheetState();
}

class _IngredientPickerSheetState extends ConsumerState<IngredientPickerSheet> {
  static const _debounce = Duration(milliseconds: 250);

  final _query = ValueNotifier('');
  final _error = ValueNotifier<String?>(null);
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _query.dispose();
    _error.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _timer?.cancel();
    _timer = Timer(_debounce, () => _query.value = value.trim());
  }

  Future<void> _create(String name) async {
    try {
      final created = await ref.read(ingredientCatalogProvider).create(name);
      if (mounted) Navigator.of(context).pop(created);
    } catch (error) {
      _error.value = describeApiError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = MediaQuery.sizeOf(context).height * 0.8;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                autofocus: true,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: 'Tìm nguyên liệu',
                  prefixIcon: Icon(Icons.search_rounded, color: colors.textMuted),
                  filled: true,
                  fillColor: colors.surfaceRaised,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _query,
                builder: (context, query, _) => _Results(
                  query: query,
                  onPick: (option) => Navigator.of(context).pop(option),
                  onCreate: _create,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _error,
              builder: (context, error, _) => error == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(error, style: TextStyle(color: colors.danger, fontSize: 13)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query, required this.onPick, required this.onCreate});

  final String query;
  final ValueChanged<IngredientOption> onPick;
  final ValueChanged<String> onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final results = ref.watch(ingredientSearchProvider(query));

    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(describeApiError(error), style: TextStyle(color: colors.danger))),
      data: (options) {
        final hasExact = options.any((o) => o.name.toLowerCase() == query.toLowerCase());
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            for (final option in options)
              ListTile(
                minTileHeight: 52,
                title: Text(option.name),
                onTap: () => onPick(option),
              ),
            if (query.isNotEmpty && !hasExact)
              ListTile(
                minTileHeight: 52,
                leading: Icon(Icons.add_circle_outline_rounded, color: colors.accent),
                title: Text('Thêm "$query" làm nguyên liệu mới', style: TextStyle(color: colors.accent)),
                onTap: () => onCreate(query),
              ),
            if (options.isEmpty && query.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Gõ tên nguyên liệu để tìm.', style: TextStyle(color: colors.textMuted)),
              ),
          ],
        );
      },
    );
  }
}
