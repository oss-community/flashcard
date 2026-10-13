import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'language_picker.dart';
import 'profiles.dart';

/// First screen: pick the menu language and make the first profile.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final languages = ref.watch(vocabularyProvider).languages;
    final notifier = ref.read(settingsProvider.notifier);
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
                      onChanged: (code) => notifier.update((s) => s.copyWith(uiLanguage: code)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(l.welcomeTitle, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(l.welcomeBody, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 32),
                ProfileForm(submitLabel: l.start, onSubmit: notifier.createProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
