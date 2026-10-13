import 'package:flutter/material.dart';

import '../core/language.dart';

/// Dropdown of languages, each named in the current menu language.
class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({
    super.key,
    required this.label,
    required this.languages,
    required this.uiCode,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<Language> languages;
  final String uiCode;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: [
        for (final lang in languages)
          DropdownMenuItem(value: lang.code, child: Text(lang.nameIn(uiCode))),
      ],
      onChanged: (code) {
        if (code != null) onChanged(code);
      },
    );
  }
}

/// Row of A1 to C2 choice chips.
class LevelPicker extends StatelessWidget {
  const LevelPicker({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final level in levels)
          ChoiceChip(
            label: Text(level),
            selected: level == value,
            onSelected: (_) => onChanged(level),
          ),
      ],
    );
  }
}
