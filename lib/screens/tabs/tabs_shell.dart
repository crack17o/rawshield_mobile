import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_strings.dart';
import '../../providers/tab_index_provider.dart';
import '../../theme/rawshield_theme.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'security_screen.dart';
import 'profile_screen.dart';

class TabsShell extends ConsumerStatefulWidget {
  const TabsShell({super.key});

  @override
  ConsumerState<TabsShell> createState() => _TabsShellState();
}

class _TabsShellState extends ConsumerState<TabsShell> {
  final _screens = const [
    HomeScreen(),
    HistoryScreen(),
    SecurityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appStringsProvider);
    final index = ref.watch(tabIndexProvider);

    return Scaffold(
      body: _screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: RawShieldColors.surfaceElevated,
          indicatorColor: const Color.fromRGBO(212, 175, 55, 0.18),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          height: 70,
          selectedIndex: index,
          onDestinationSelected: (i) => ref.read(tabIndexProvider.notifier).setIndex(i),
          destinations: [
            NavigationDestination(icon: const Icon(LucideIcons.home), label: s.tabHome),
            NavigationDestination(icon: const Icon(LucideIcons.receipt), label: s.tabHistory),
            NavigationDestination(icon: const Icon(LucideIcons.shield), label: s.tabSecurity),
            NavigationDestination(icon: const Icon(LucideIcons.user), label: s.tabProfile),
          ],
        ),
      ),
    );
  }
}
