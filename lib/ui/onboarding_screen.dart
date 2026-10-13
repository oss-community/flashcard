import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'language_picker.dart';

/// First screen: pick the language pair and level.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _native;
  String? _target;
  String _level = 'A1';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final languages = ref.watch(vocabularyProvider).languages;
    final same = _native != null && _native == _target;
    final ready = _native != null && _target != null && !same;
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SizedBox(
                    width: 200,
                    child: LanguageDropdown(
                      label: l.settingsMenuLanguage,
                      languages: languages,
                      uiCode: settings.uiLanguage,
                      value: settings.uiLanguage,
                      onChanged: (code) => ref
                          .read(settingsProvider.notifier)
                          .update((s) => s.copyWith(uiLanguage: code)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(l.welcomeTitle, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(l.welcomeBody, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 32),
                LanguageDropdown(
                  key: const Key('target'),
                  label: l.languageToLearn,
                  languages: languages,
                  uiCode: settings.uiLanguage,
                  value: _target,
                  onChanged: (code) => setState(() => _target = code),
                ),
                const SizedBox(height: 16),
                LanguageDropdown(
                  key: const Key('native'),
                  label: l.languageYouKnow,
                  languages: languages,
                  uiCode: settings.uiLanguage,
                  value: _native,
                  onChanged: (code) => setState(() => _native = code),
                ),
                if (same) ...[
                  const SizedBox(height: 8),
                  Text(l.sameLanguageError,
                      style: TextStyle(color: theme.colorScheme.error)),
                ],
                const SizedBox(height: 24),
                Text(l.level, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                LevelPicker(value: _level, onChanged: (v) => setState(() => _level = v)),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: ready
                      ? () => ref.read(settingsProvider.notifier).update((s) =>
                          s.copyWith(native: _native, target: _target, level: _level))
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l.start),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
