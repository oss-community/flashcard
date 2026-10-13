import 'package:flutter/material.dart';

import '../core/language.dart';
import '../l10n/app_localizations.dart';

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

/// Choice chips for "all levels in order" (null) or one level, A1 to C2.
class LevelPicker extends StatelessWidget {
  const LevelPicker({super.key, required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: Text(l.levelAllInOrder),
          tooltip: l.levelAllHint,
          selected: value == null,
          onSelected: (_) => onChanged(null),
        ),
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
