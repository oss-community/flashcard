import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/language.dart';
import '../core/vocabulary_source.dart';
import '../domain/pair.dart';

const repositoryUrl = 'https://github.com/oss-community/wordeck';
const issuesUrl = '$repositoryUrl/issues';
const privacyUrl = 'https://oss-community.github.io/wordeck/privacy.html';

/// Where mistakes in the words themselves are fixed.
const dictionaryIssuesUrl = 'https://github.com/oss-community/dictionary/issues/new';

/// Opens [url] in the browser; if that fails, shows the address so it can be
/// typed in by hand.
Future<void> openLink(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.of(context);
  var opened = false;
  try {
    opened = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
  if (!opened) messenger.showSnackBar(SnackBar(content: SelectableText(url)));
}

/// A new issue in the dictionary repository, filled in with the card as it is
/// shown, so the learner only has to say what is wrong.
String mistakeReportUrl(PairCard card, Language target, Language native) {
  String line(Language language, Term term) {
    final plural = term.plural;
    return '- ${language.names['en']}: ${term.word} (${term.type}'
        '${plural == null ? '' : ', plural: $plural'})';
  }

  final body = [
    'Card: `${card.id}` (${card.level.toUpperCase()})',
    line(target, card.target),
    line(native, card.native),
    '',
    'What is wrong:',
    '',
  ].join('\n');
  return Uri.parse(dictionaryIssuesUrl)
      .replace(
        queryParameters: {'title': 'Mistake in ${card.id}: ${card.target.word}', 'body': body},
      )
      .toString();
}
