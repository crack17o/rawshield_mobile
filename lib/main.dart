import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'l10n/locale_provider.dart';
import 'theme/rawshield_theme.dart';

void main() {
  runApp(const ProviderScope(child: RawShieldApp()));
}

class RawShieldApp extends ConsumerStatefulWidget {
  const RawShieldApp({super.key});

  @override
  ConsumerState<RawShieldApp> createState() => _RawShieldAppState();
}

class _RawShieldAppState extends ConsumerState<RawShieldApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(localeProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    // Flutter ne fournit pas Material/Cupertino localizations pour `ln` (Lingala).
    // On garde `locale` dans [localeProvider] pour [appStringsProvider] ; l’UI Material
    // utilise une locale supportée (fr ou en) comme repli pour Lingala.
    final materialLocale = locale.languageCode == 'ln' ? const Locale('fr') : locale;
    final router = createRouter();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RAWShield AI',
      locale: materialLocale,
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (loc, supported) {
        if (loc != null) {
          for (final s in supported) {
            if (s.languageCode == loc.languageCode) return s;
          }
        }
        return const Locale('fr');
      },
      theme: rawShieldDarkTheme(),
      routerConfig: router,
    );
  }
}
