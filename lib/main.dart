import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'theme/rawshield_theme.dart';

void main() {
  runApp(const ProviderScope(child: RawShieldApp()));
}

class RawShieldApp extends StatelessWidget {
  const RawShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RAWShield AI',
      theme: rawShieldDarkTheme(),
      routerConfig: router,
    );
  }
}
