import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/tabs/tabs_shell.dart';
import '../screens/transfer/transfer_flow.dart';
import '../screens/withdrawal/withdrawal_screen.dart';
import '../screens/tabs/notifications_screen.dart';
import 'routes.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              'Cette page n’existe pas.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(AppRoutes.tabs),
              child: const Text('Retour à l’accueil'),
            ),
          ],
        ),
      ),
    ),
    routes: [
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
          child: const TransferFlow(),
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
    ],
  );
}

