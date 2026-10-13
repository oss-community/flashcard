import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'state/providers.dart';
import 'ui/onboarding_screen.dart';
import 'ui/settings_screen.dart';
import 'ui/stats_screen.dart';
import 'ui/study_screen.dart';
import 'ui/words_screen.dart';

final _router = GoRouter(
  initialLocation: '/study',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _Shell(shell: shell),
      branches: [
        for (final (path, page) in [
          ('/study', const StudyScreen()),
          ('/words', const WordsScreen()),
          ('/stats', const StatsScreen()),
          ('/settings', const SettingsScreen()),
        ])
          StatefulShellBranch(routes: [GoRoute(path: path, builder: (_, _) => page)]),
      ],
    ),
  ],
);

ThemeData _theme(Brightness brightness, String uiLanguage) => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5), brightness: brightness),
      fontFamily: uiLanguage == 'fa' ? 'Vazirmatn' : null,
      fontFamilyFallback: const ['Vazirmatn'],
    );

class FlashcardApp extends ConsumerWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final locale = Locale(settings.uiLanguage);
    final theme = _theme(Brightness.light, settings.uiLanguage);
    final darkTheme = _theme(Brightness.dark, settings.uiLanguage);
    const delegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    if (!settings.hasPair) {
      return MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: delegates,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: settings.themeMode,
        home: const OnboardingScreen(),
      );
    }
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: delegates,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: settings.themeMode,
      routerConfig: _router,
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                  icon: const Icon(Icons.style_outlined),
                  selectedIcon: const Icon(Icons.style),
                  label: Text(l.navStudy)),
              NavigationRailDestination(
                  icon: const Icon(Icons.list_alt_outlined),
                  selectedIcon: const Icon(Icons.list_alt),
                  label: Text(l.navWords)),
              NavigationRailDestination(
                  icon: const Icon(Icons.bar_chart_outlined),
                  selectedIcon: const Icon(Icons.bar_chart),
                  label: Text(l.navStats)),
              NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: Text(l.navSettings)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: shell),
        ],
      ),
    );
  }
}
