<h1 align="center">Flashcards</h1>

An app for Windows, Android and iPhone for learning vocabulary with flashcards
and spaced repetition.
You pick the language you want to learn and the language you already know;
each card shows only those two. The words come from
[oss-community/dictionary](https://github.com/oss-community/dictionary):
about 9,000 cards in English, German, Dutch and Persian, from level A1 to C2.

## Features

- Profiles: each one is a language pair (any two of English, German, Dutch,
  Persian) with its own name, level, daily goal, options and progress. Its
  name is made from the two languages unless you give it one, such as
  "Persian → German". Switch profiles at the top of the study page; add,
  rename or delete them in Settings. By default
  new cards come from every level in order, all of A1 first, then A2, up to C2;
  you can also pick a single level.
- No daily limit: study as long as you like. Words due for review come first,
  then new words one after another, and a word studied earlier comes back by
  itself when its time arrives. An optional daily goal for new words only
  keeps track and never stops you.
- Flashcards scheduled with the FSRS spaced repetition algorithm. Answer with
  Forgot or Remembered; keyboard: Space shows the answer, 1 forgot, 2 remembered.
- Every word has a difficulty (easy, medium, advanced) from the data. Each time
  you remember a word, the wait before it comes back grows: a new easy word
  first returns after a week, and easy words space out faster than medium ones,
  medium faster than advanced. Forgetting brings a word back soon. The longest
  wait is one year. You can change a word's difficulty on the card or in the
  word list; your choice is kept per profile.
- Reverse cards: see the meaning first and recall the word.
- Word forms on the back of the card, in both languages: plurals, past forms of
  verbs (Persian: past and present stems), comparison of adjectives. Can be
  turned off per profile.
- Conjugation page for verbs: every tense and person, with the same form in the
  other language beside it and a switch to that language's table. Opens from a
  verb card or by tapping a word in the word list.
- Progress is kept separately for each profile and direction.
- Word list with search in both languages and a level filter.
- Daily statistics: answers per day, streak, words learned per level.
- Pronunciation with the voices installed on the device.
- Menus in English (default), German, Dutch and Persian, right to left for Persian.
- Light, dark, or the same as the system.
- On a phone the menu moves to the bottom of the screen.
- Works fully offline and collects no data; see the
  [privacy policy](https://oss-community.github.io/flashcard/privacy.html)
  (source in `docs/privacy.html`).

## Download

Every push to `main` builds the app on GitHub Actions. Open the latest
[Build](../../actions/workflows/build.yml) run and download the version you need.

### Windows

Download **Flashcards-windows**, unzip it and run `flashcard.exe`. Windows may
warn that the app is unsigned; choose "More info" and "Run anyway".

Pronunciation uses Windows voices. To add one, open Settings > Time & language >
Speech > Add voices. A language without a voice shows a disabled speaker button.

### Android

Download **Flashcards-android** and unzip it to get `Flashcards.apk`. Copy it to
the phone (or send it by email or a messenger), open it and allow installing
apps from that source when Android asks. Android 7 or newer is needed. The file
is signed with a test key, so Android may show a warning, and a later version
installs over it only if it was built the same way.

Pronunciation uses the phone's speech engine. To add a voice, open Settings >
System > Languages > Text-to-speech output (the path differs a little between
phone makers).

### iPhone

Download **Flashcards-ios** and unzip it to get `Flashcards.ipa`. The file is not
signed, and an iPhone only installs apps signed with an Apple ID. A sideloading
tool such as Sideloadly or AltStore signs and installs it from a computer with
your Apple ID. With a free Apple ID the app has to be signed again every 7 days;
a paid Apple Developer account makes it last a year.

Pronunciation uses the iPhone's voices. To add one, open Settings >
Accessibility > Spoken Content > Voices.

## Building

Requires Flutter 3.47. For Windows: a Windows computer with Visual Studio's
"Desktop development with C++". For Android: the Android SDK and Java 17. For
iPhone: a Mac with Xcode.

```
flutter pub get
dart run tool/build_vocabulary_db.dart
flutter build windows --release
flutter build apk --release
flutter build ios --release
```

`tool/build_vocabulary_db.dart` checks `data/vocabulary.csv` and
`data/conjugations.csv` and writes `assets/vocabulary.db`; run it again whenever
a CSV changes. Tests:
`flutter test`.

## How it is organised

| Folder | What it holds |
|---|---|
| `data/` | `vocabulary.csv` and `conjugations.csv` (copied from the dictionary repository) and `languages.json` |
| `tool/` | The script that builds the word database from `data/` |
| `lib/core/` | Language list, CSV reading and checks (plain Dart) |
| `lib/data/` | Word database, progress database, pronunciation |
| `lib/domain/` | Profiles, language pairs, spaced repetition, study sessions, statistics |
| `lib/state/` | App state (Riverpod) |
| `lib/ui/` | Screens |
| `lib/l10n/` | Menu translations, one `app_<code>.arb` file per language |
| `docs/` | The privacy policy, published with GitHub Pages |
| `test/` | Tests, including a check that every language has complete menus |

Two databases are kept in the app's data folder: `vocabulary.db` is replaced
with each new version of the app, `progress.sqlite` keeps your progress, so
updating the words never resets it.

## Adding a language

1. Add `<name>`, `<name>_type` and, if it has plurals, `<name>_plural` columns
   to `data/vocabulary.csv`. Other `<name>_<form>` columns are read as word
   forms; verb tables go in `data/conjugations.csv` with `<name>` as language.
2. Add the language to `data/languages.json` with its name in every menu language
   (and add its own name to the other languages).
3. Add `lib/l10n/app_<code>.arb` with every menu text translated.

No code changes are needed; `flutter test` fails if any of these is missing.

## License

Apache License 2.0. The bundled Vazirmatn font is under the SIL Open Font
License (`assets/fonts/OFL.txt`).
