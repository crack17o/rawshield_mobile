import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_strings.dart';
import '../screens/auth/login_screen.dart';
import '../screens/tabs/tabs_shell.dart';
import '../screens/transfer/transfer_flow.dart';
import '../screens/withdrawal/withdrawal_screen.dart';
import '../screens/tabs/notifications_screen.dart';
import '../screens/startup/onboarding_screen.dart';
import '../screens/startup/startup_gate.dart';
import 'routes.dart';
import '../screens/transfer/transfer_prefill.dart';
import '../screens/transactions/transaction_details_screen.dart';
import '../screens/profile/personal_info_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/help_support_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.root,
    errorBuilder: (context, state) => const _RouterErrorPage(),
    routes: [
      GoRoute(
        path: AppRoutes.root,
        pageBuilder: (context, state) => const NoTransitionPage(child: StartupGate()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => const NoTransitionPage(child: OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => const NoTransitionPage(child: LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.tabs,
        pageBuilder: (context, state) => const NoTransitionPage(child: TabsShell()),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (context, state) => const MaterialPage(child: NotificationsScreen()),
      ),
      GoRoute(
        path: AppRoutes.transfer,
        pageBuilder: (context, state) => CustomTransitionPage(
          opaque: false,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          transitionsBuilder: (context, animation, _, child) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
          child: TransferFlow(prefill: state.extra as TransferPrefill?),
        ),
      ),
      GoRoute(
        path: AppRoutes.transactionDetails,
        pageBuilder: (context, state) => NoTransitionPage(
          child: TransactionDetailsScreen(details: state.extra as TransactionDetails),
        ),
      ),
      GoRoute(
        path: AppRoutes.withdrawal,
        pageBuilder: (context, state) => CustomTransitionPage(
          opaque: false,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          transitionsBuilder: (context, animation, _, child) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
          child: const WithdrawalScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profilePersonalInfo,
        pageBuilder: (context, state) => const MaterialPage(child: PersonalInfoScreen()),
      ),
      GoRoute(
        path: AppRoutes.profileSettings,
        pageBuilder: (context, state) => const MaterialPage(child: SettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.profileHelp,
        pageBuilder: (context, state) => const MaterialPage(child: HelpSupportScreen()),
      ),
    ],
  );
}

class _RouterErrorPage extends ConsumerWidget {
  const _RouterErrorPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              s.errorPageNotFound,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(AppRoutes.tabs),
              child: Text(s.commonBackHome),
            ),
          ],
        ),
      ),
    );
  }
}

