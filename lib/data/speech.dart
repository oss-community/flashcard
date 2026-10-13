import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/language.dart';

/// Pronunciation with the voices installed on the computer.
///
/// Works offline. A language with no installed voice simply cannot be spoken,
/// and the pronounce button is disabled for it.
class Speech {
  Speech._(this._tts, this._voices);

  final FlutterTts? _tts;

  /// Installed voices keyed by language code (`de`, `fa`, ...).
  final Map<String, Map<String, String>> _voices;

  /// Speech that can say nothing, for tests and unsupported platforms.
  factory Speech.silent() => Speech._(null, const {});

  static Future<Speech> create() async {
    try {
      final tts = FlutterTts();
      final voices = <String, Map<String, String>>{};
      final list = await tts.getVoices as List?;
      for (final voice in list ?? const []) {
        final map = Map<String, String>.from((voice as Map).map((k, v) => MapEntry('$k', '$v')));
        final locale = map['locale'];
        if (locale == null) continue;
        final code = locale.split(RegExp('[-_]')).first.toLowerCase();
        voices.putIfAbsent(code, () => map);
      }
      return Speech._(tts, voices);
    } catch (e) {
      // No speech support on this platform (e.g. Linux during development).
      debugPrint('Text-to-speech unavailable: $e');
      return Speech.silent();
    }
  }

  bool canSpeak(Language language) => _voices.containsKey(language.code);

  Future<void> speak(Language language, String text) async {
    final tts = _tts;
    final voice = _voices[language.code];
    if (tts == null || voice == null) return;
    try {
      await tts.stop();
      await tts.setVoice({'name': voice['name']!, 'locale': voice['locale']!});
      await tts.speak(text);
    } catch (e) {
      debugPrint('Could not speak: $e');
    }
  }
}
