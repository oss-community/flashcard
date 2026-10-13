# Flashcards

A Windows app for learning vocabulary with flashcards and spaced repetition.
You pick the language you want to learn and the language you already know;
each card shows only those two. The words come from
[oss-community/dictionary](https://github.com/oss-community/dictionary):
about 9,000 cards in English, German, Dutch and Persian, from level A1 to C2.

## Features

- Choose a language pair (any two of English, German, Dutch, Persian). By default
  new cards come from every level in order, all of A1 first, then A2, up to C2;
  you can also pick a single level.
- Flashcards scheduled with the FSRS spaced repetition algorithm. Answer with
  Forgot or Remembered; keyboard: Space shows the answer, 1 forgot, 2 remembered.
- Every word has a difficulty (easy, medium, advanced) from the data. Each time
  you remember a word, the wait before it comes back grows: a new easy word
  first returns after a week, and easy words space out faster than medium ones,
  medium faster than advanced. Forgetting brings a word back soon. The longest
  wait is one year. You can change a word's difficulty on the card or in the
  word list; your choice is kept per language.
- Reverse cards: see the meaning first and recall the word.
- Progress is kept separately for each language pair and direction.
- Word list with search in both languages and a level filter.
- Daily statistics: answers per day, streak, words learned per level.
- Pronunciation with the voices installed in Windows.
- Menus in English (default), German, Dutch and Persian, right to left for Persian.
- Light, dark, or the same as Windows.
- Works fully offline.

## Download

Every push to `main` builds the app on GitHub Actions. Open the latest
[Windows build](../../actions/workflows/windows.yml) run, download
**Flashcards-windows**, unzip it and run `flashcard.exe`. Windows may warn that
the app is unsigned; choose "More info" and "Run anyway".

Pronunciation uses Windows voices. To add one, open Settings > Time & language >
Speech > Add voices. A language without a voice shows a disabled speaker button.

## Building

Requires Flutter 3.47 on Windows with Visual Studio's "Desktop development with C++".

```
flutter pub get
dart run tool/build_vocabulary_db.dart
flutter run -d windows
flutter build windows --release
```

`tool/build_vocabulary_db.dart` checks `data/vocabulary.csv` and writes
`assets/vocabulary.db`; run it again whenever the CSV changes. Tests:
`flutter test`.

## How it is organised

| Folder | What it holds |
|---|---|
| `data/` | `vocabulary.csv` (copied from the dictionary repository) and `languages.json` |
| `tool/` | The script that builds the word database from `data/` |
| `lib/core/` | Language list, CSV reading and checks (plain Dart) |
| `lib/data/` | Word database, progress database, pronunciation |
| `lib/domain/` | Language pairs, spaced repetition, study sessions, statistics |
| `lib/state/` | App state (Riverpod) |
| `lib/ui/` | Screens |
| `lib/l10n/` | Menu translations, one `app_<code>.arb` file per language |
| `test/` | Tests, including a check that every language has complete menus |

Two databases are kept in the app's data folder: `vocabulary.db` is replaced
with each new version of the app, `progress.sqlite` keeps your progress, so
updating the words never resets it.

## Adding a language

1. Add `<name>`, `<name>_type` and, if it has plurals, `<name>_plural` columns
   to `data/vocabulary.csv`.
2. Add the language to `data/languages.json` with its name in every menu language
   (and add its own name to the other languages).
3. Add `lib/l10n/app_<code>.arb` with every menu text translated.

No code changes are needed; `flutter test` fails if any of these is missing.

## License

Apache License 2.0. The bundled Vazirmatn font is under the SIL Open Font
License (`assets/fonts/OFL.txt`).
