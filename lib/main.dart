import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'data/progress_database.dart';
import 'data/progress_repository.dart';
import 'data/speech.dart';
import 'data/vocabulary_repository.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow(
      const WindowOptions(size: Size(1100, 760), minimumSize: Size(820, 600), center: true),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }

  final vocabulary = await Vocabulary.load();
  final progress = ProgressRepository(ProgressDatabase());
  final settings = await progress.readSettings();
  final profiles = await progress.profiles();
  final speech = await Speech.create();

  runApp(
    ProviderScope(
      overrides: [
        vocabularyProvider.overrideWithValue(vocabulary),
        progressRepositoryProvider.overrideWithValue(progress),
        initialSettingsProvider.overrideWithValue(settings),
        initialProfilesProvider.overrideWithValue(profiles),
        speechProvider.overrideWithValue(speech),
      ],
      child: const FlashcardApp(),
    ),
  );
}
