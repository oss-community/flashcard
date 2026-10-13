import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'state/providers.dart';
import 'ui/layout.dart';
import 'ui/onboarding_screen.dart';
import 'ui/settings_screen.dart';
import 'ui/stats_screen.dart';
import 'ui/study_screen.dart';
import 'ui/words_screen.dart';

GoRouter _buildRouter() => GoRouter(
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
          StatefulShellBranch(
            routes: [GoRoute(path: path, builder: (_, _) => page)],
          ),
      ],
    ),
  ],
);

ThemeData _theme(Brightness brightness, String uiLanguage) => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5), brightness: brightness),
  fontFamily: uiLanguage == 'fa' ? 'Vazirmatn' : null,
  fontFamilyFallback: const ['Vazirmatn'],
);

class FlashcardApp extends ConsumerStatefulWidget {
  const FlashcardApp({super.key});

  @override
  ConsumerState<FlashcardApp> createState() => _FlashcardAppState();
}

class _FlashcardAppState extends ConsumerState<FlashcardApp> {
  final _router = _buildRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    final destinations = [
      (Icons.style_outlined, Icons.style, l.navStudy),
      (Icons.list_alt_outlined, Icons.list_alt, l.navWords),
      (Icons.bar_chart_outlined, Icons.bar_chart, l.navStats),
      (Icons.settings_outlined, Icons.settings, l.navSettings),
    ];
    void select(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);

    if (isCompact(context)) {
      return Scaffold(
        body: SafeArea(bottom: false, child: shell),
        bottomNavigationBar: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: select,
          destinations: [
            for (final (icon, selected, label) in destinations)
              NavigationDestination(icon: Icon(icon), selectedIcon: Icon(selected), label: label),
          ],
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: select,
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final (icon, selected, label) in destinations)
                NavigationRailDestination(
                  icon: Icon(icon),
                  selectedIcon: Icon(selected),
                  label: Text(label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: shell),
        ],
      ),
    );
  }
}
