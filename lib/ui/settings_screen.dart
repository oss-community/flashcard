import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'language_picker.dart';

/// Menu language, language pair, level, study options and theme.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final languages = ref.watch(vocabularyProvider).languages;
    final notifier = ref.read(settingsProvider.notifier);
    final ui = settings.uiLanguage;

    Widget section(String title) => Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 12),
          child: Text(title, style: theme.textTheme.titleLarge),
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LanguageDropdown(
                label: l.settingsMenuLanguage,
                languages: languages,
                uiCode: ui,
                value: ui,
                onChanged: (code) => notifier.update((s) => s.copyWith(uiLanguage: code)),
              ),
              section(l.settingsLanguages),
              LanguageDropdown(
                key: ValueKey('target-${settings.target}-$ui'),
                label: l.languageToLearn,
                languages: [for (final lang in languages) if (lang.code != settings.native) lang],
                uiCode: ui,
                value: settings.target,
                onChanged: (code) => notifier.update((s) => s.copyWith(target: code)),
              ),
              const SizedBox(height: 16),
              LanguageDropdown(
                key: ValueKey('native-${settings.native}-$ui'),
                label: l.languageYouKnow,
                languages: [for (final lang in languages) if (lang.code != settings.target) lang],
                uiCode: ui,
                value: settings.native,
                onChanged: (code) => notifier.update((s) => s.copyWith(native: code)),
              ),
              const SizedBox(height: 8),
              Text(l.settingsAbout, style: theme.textTheme.bodySmall),
              section(l.settingsStudy),
              Text(l.level, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              LevelPicker(
                value: settings.level,
                onChanged: (v) => notifier.update((s) => s.copyWith(level: v)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Text(l.settingsNewPerDay)),
                  IconButton(
                    onPressed: settings.newPerDay <= 0
                        ? null
                        : () => notifier.update((s) => s.copyWith(newPerDay: s.newPerDay - 5)),
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text('${settings.newPerDay}',
                        textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                  ),
                  IconButton(
                    onPressed: settings.newPerDay >= 200
                        ? null
                        : () => notifier.update((s) => s.copyWith(newPerDay: s.newPerDay + 5)),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.settingsReversed),
                subtitle: Text(l.settingsReversedHint),
                value: settings.reversed,
                onChanged: (v) => notifier.update((s) => s.copyWith(reversed: v)),
              ),
              section(l.settingsAppearance),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(value: ThemeMode.system, label: Text(l.themeSystem)),
                  ButtonSegment(value: ThemeMode.light, label: Text(l.themeLight)),
                  ButtonSegment(value: ThemeMode.dark, label: Text(l.themeDark)),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (v) =>
                    notifier.update((s) => s.copyWith(themeMode: v.first)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
