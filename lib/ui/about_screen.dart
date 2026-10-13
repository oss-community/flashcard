import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../l10n/app_localizations.dart';
import 'links.dart';

/// App name and version, links for feedback, the privacy policy and the
/// source code, and the licences of everything bundled with the app.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute<void>(builder: (_) => const AboutScreen()));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.about)),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final info = snapshot.data;
          final version = info == null ? '' : info.version;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l.appTitle, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      version.isEmpty ? '' : l.aboutVersion(version),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l.aboutBody),
                    const SizedBox(height: 24),
                    _Link(icon: Icons.feedback_outlined, title: l.aboutFeedback, url: issuesUrl),
                    _Link(
                      icon: Icons.privacy_tip_outlined,
                      title: l.privacyPolicy,
                      url: privacyUrl,
                    ),
                    _Link(icon: Icons.code, title: l.aboutSource, url: repositoryUrl),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.description_outlined),
                      title: Text(l.aboutLicenses),
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: l.appTitle,
                        applicationVersion: version,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({required this.icon, required this.title, required this.url});

  final IconData icon;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () => openLink(context, url),
    );
  }
}
