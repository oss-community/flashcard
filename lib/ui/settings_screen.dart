import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'language_picker.dart';
import 'profiles.dart';

/// Menu language, profiles, study options of the current profile, and theme.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final vocab = ref.watch(vocabularyProvider);
    final languages = vocab.languages;
    final active = settings.profile!;
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
              section(l.profiles),
              for (final profile in settings.profiles)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    profile.id == active.id ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: profile.id == active.id ? theme.colorScheme.primary : null,
                  ),
                  title: Text(profileTitle(l, vocab, ui, profile)),
                  subtitle: Text(profilePair(l, vocab, ui, profile)),
                  onTap: () => notifier.switchProfile(profile.id),
                  trailing: PopupMenuButton<bool>(
                    onSelected: (delete) => delete
                        ? deleteProfile(context, ref, profile)
                        : renameProfile(context, ref, profile),
                    itemBuilder: (_) => [
                      PopupMenuItem(value: false, child: Text(l.renameProfile)),
                      PopupMenuItem(value: true, child: Text(l.delete)),
                    ],
                  ),
                ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => NewProfileScreen.open(context),
                  icon: const Icon(Icons.add),
                  label: Text(l.newProfile),
                ),
              ),
              const SizedBox(height: 8),
              Text(l.settingsAbout, style: theme.textTheme.bodySmall),
              section(l.settingsStudyIn(profileTitle(l, vocab, ui, active))),
              Text(l.level, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              LevelPicker(
                value: settings.level,
                onChanged: (v) => notifier.updateProfile((p) => p.copyWith(level: () => v)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.settingsDailyGoal),
                        Text(l.settingsDailyGoalHint, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: settings.dailyGoal <= 0
                        ? null
                        : () =>
                              notifier.updateProfile((p) => p.copyWith(dailyGoal: p.dailyGoal - 5)),
                    icon: const Icon(Icons.remove),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 56),
                    child: Text(
                      settings.dailyGoal > 0 ? '${settings.dailyGoal}' : l.noGoal,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: settings.dailyGoal >= maxDailyGoal
                        ? null
                        : () =>
                              notifier.updateProfile((p) => p.copyWith(dailyGoal: p.dailyGoal + 5)),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.settingsReversed),
                subtitle: Text(l.settingsReversedHint),
                value: settings.reversed,
                onChanged: (v) => notifier.updateProfile((p) => p.copyWith(reversed: v)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.settingsShowForms),
                subtitle: Text(l.settingsShowFormsHint),
                value: settings.showForms,
                onChanged: (v) => notifier.updateProfile((p) => p.copyWith(showForms: v)),
              ),
              section(l.settingsAppearance),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(value: ThemeMode.system, label: Text(l.themeSystem)),
                  ButtonSegment(value: ThemeMode.light, label: Text(l.themeLight)),
                  ButtonSegment(value: ThemeMode.dark, label: Text(l.themeDark)),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (v) => notifier.update((s) => s.copyWith(themeMode: v.first)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
