import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/language.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';

/// A word shown in its own writing direction, whatever the menu language.
class TermText extends StatelessWidget {
  const TermText(this.text, {super.key, required this.language, this.style, this.textAlign});

  final String text;
  final Language language;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: language.rtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: textAlign,
      style: (style ?? const TextStyle()).copyWith(
        fontFamily: language.rtl ? 'Vazirmatn' : null,
      ),
    );
  }
}

/// Speaker button that reads a word aloud; disabled when no voice is installed.
class SpeakButton extends ConsumerWidget {
  const SpeakButton({super.key, required this.language, required this.text});

  final Language language;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final speech = ref.watch(speechProvider);
    final enabled = speech.canSpeak(language);
    return IconButton(
      tooltip: enabled ? l.pronounce : l.noVoice,
      icon: const Icon(Icons.volume_up_outlined),
      onPressed: enabled ? () => speech.speak(language, text) : null,
    );
  }
}
