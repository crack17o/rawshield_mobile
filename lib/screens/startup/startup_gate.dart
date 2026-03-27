import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/routes.dart';
import '../../services/app_prefs.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  static const onboardingSeenKey = 'onboardingSeen';

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(StartupGate.onboardingSeenKey) ?? false;
    if (!seen) {
      if (!mounted) return;
      context.go(AppRoutes.onboarding);
      return;
    }
    final signedIn = prefs.getBool(AppPrefs.signedInKey) ?? false;
    if (!mounted) return;
    context.go(signedIn ? AppRoutes.tabs : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

