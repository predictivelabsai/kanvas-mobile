import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kanvas/config/theme.dart';
import 'package:kanvas/router/app_router.dart';
import 'package:kanvas/providers/locale_provider.dart';

class KanvasApp extends ConsumerWidget {
  const KanvasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final localeCode = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Kanvas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: Locale(localeCode),
      supportedLocales: const [
        Locale('en'),
        Locale('et'),
        Locale('de'),
        Locale('fr'),
        Locale('sv'),
        Locale('lv'),
        Locale('no'),
        Locale('da'),
        Locale('pl'),
        Locale('nl'),
        Locale('fi'),
        Locale('lt'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
