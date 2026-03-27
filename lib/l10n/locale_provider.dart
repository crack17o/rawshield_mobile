import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_prefs.dart';

/// Locale UI (fr / en / ln). Chargée depuis [AppPrefs] au démarrage.
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('fr');

  Future<void> load() async {
    final code = await AppPrefs.getLanguageCode();
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    await AppPrefs.setLanguageCode(locale.languageCode);
    state = locale;
  }
}
