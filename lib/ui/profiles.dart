import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vocabulary_repository.dart';
import '../domain/profile.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'language_picker.dart';

/// The learner's name for [profile], or one made from its two languages.
String profileTitle(AppLocalizations l, Vocabulary vocab, String ui, Profile profile) =>
    profile.name ??
    l.profileDefaultName(
      vocab.language(profile.native).nameIn(ui),
      vocab.language(profile.target).nameIn(ui),
    );

/// "German from Persian" for [profile].
String profilePair(AppLocalizations l, Vocabulary vocab, String ui, Profile profile) =>
    l.learningPair(
      vocab.language(profile.target).nameIn(ui),
      vocab.language(profile.native).nameIn(ui),
    );

/// Name, languages and level of a new profile.
class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({super.key, required this.submitLabel, required this.onSubmit});

  final String submitLabel;
  final Future<void> Function({
    String? name,
    required String native,
    required String target,
    String? level,
  })
  onSubmit;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _name = TextEditingController();
  String? _native;
  String? _target;
  String? _level;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final vocab = ref.watch(vocabularyProvider);
    final ui = ref.watch(settingsProvider.select((s) => s.uiLanguage));
    final same = _native != null && _native == _target;
    final ready = _native != null && _target != null && !same;
    final defaultName = ready
        ? l.profileDefaultName(
            vocab.language(_native!).nameIn(ui),
            vocab.language(_target!).nameIn(ui),
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LanguageDropdown(
          key: const Key('target'),
          label: l.languageToLearn,
          languages: vocab.languages,
          uiCode: ui,
          value: _target,
          onChanged: (code) => setState(() => _target = code),
        ),
        const SizedBox(height: 16),
        LanguageDropdown(
          key: const Key('native'),
          label: l.languageYouKnow,
          languages: vocab.languages,
          uiCode: ui,
          value: _native,
          onChanged: (code) => setState(() => _native = code),
        ),
        if (same) ...[
          const SizedBox(height: 8),
          Text(l.sameLanguageError, style: TextStyle(color: theme.colorScheme.error)),
        ],
        const SizedBox(height: 16),
        TextField(
          key: const Key('profileName'),
          controller: _name,
          decoration: InputDecoration(
            labelText: l.profileName,
            hintText: defaultName,
            helperText: l.profileNameHint,
            helperMaxLines: 3,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        Text(l.level, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        LevelPicker(value: _level, onChanged: (v) => setState(() => _level = v)),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: ready
              ? () => widget.onSubmit(
                  name: cleanName(_name.text),
                  native: _native!,
                  target: _target!,
                  level: _level,
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(widget.submitLabel),
          ),
        ),
      ],
    );
  }
}

/// Page for adding a profile once the app is set up.
class NewProfileScreen extends ConsumerWidget {
  const NewProfileScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute<void>(builder: (_) => const NewProfileScreen()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.newProfile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ProfileForm(
              submitLabel: l.createProfile,
              onSubmit: ({name, required native, required target, level}) async {
                final navigator = Navigator.of(context);
                await ref
                    .read(settingsProvider.notifier)
                    .createProfile(name: name, native: native, target: target, level: level);
                navigator.pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}

const _newProfile = -1;

/// Button with the current profile's name that switches to another profile
/// or opens the page for a new one.
class ProfileSwitcher extends ConsumerWidget {
  const ProfileSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final vocab = ref.watch(vocabularyProvider);
    final ui = settings.uiLanguage;
    final current = settings.profile!;

    return PopupMenuButton<int>(
      key: const Key('profileSwitcher'),
      tooltip: l.switchProfile,
      onSelected: (id) {
        if (id == _newProfile) {
          NewProfileScreen.open(context);
        } else {
          ref.read(settingsProvider.notifier).switchProfile(id);
        }
      },
      itemBuilder: (_) => [
        for (final p in settings.profiles)
          PopupMenuItem(
            value: p.id,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(p.id == current.id ? Icons.check : null),
              title: Text(profileTitle(l, vocab, ui, p)),
              subtitle: Text(profilePair(l, vocab, ui, p)),
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: _newProfile,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.add),
            title: Text(l.newProfile),
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              profileTitle(l, vocab, ui, current),
              style: theme.textTheme.headlineMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 32),
        ],
      ),
    );
  }
}

/// Asks for a new name; an empty one brings back the name from the languages.
Future<void> renameProfile(BuildContext context, WidgetRef ref, Profile profile) async {
  final l = AppLocalizations.of(context);
  final vocab = ref.read(vocabularyProvider);
  final ui = ref.read(settingsProvider).uiLanguage;
  final name = await showDialog<String>(
    context: context,
    builder: (_) => _RenameDialog(
      name: profile.name,
      defaultName: profileTitle(l, vocab, ui, profile.copyWith(name: () => null)),
    ),
  );
  if (name == null) return;
  await ref
      .read(settingsProvider.notifier)
      .saveProfile(profile.copyWith(name: () => cleanName(name)));
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.name, required this.defaultName});

  final String? name;
  final String defaultName;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _controller = TextEditingController(text: widget.name);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.renameProfile),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l.profileName,
          hintText: widget.defaultName,
          helperText: l.profileNameHint,
          helperMaxLines: 3,
        ),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(l.save),
        ),
      ],
    );
  }
}

/// Deletes [profile] and its progress after the learner confirms.
Future<void> deleteProfile(BuildContext context, WidgetRef ref, Profile profile) async {
  final l = AppLocalizations.of(context);
  final vocab = ref.read(vocabularyProvider);
  final ui = ref.read(settingsProvider).uiLanguage;
  final theme = Theme.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.deleteProfileTitle(profileTitle(l, vocab, ui, profile))),
      content: Text(l.deleteProfileBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  if (confirmed == true) await ref.read(settingsProvider.notifier).deleteProfile(profile.id);
}
