import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/rawshield_theme.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'security_screen.dart';
import 'profile_screen.dart';

class TabsShell extends StatefulWidget {
  const TabsShell({super.key});

  @override
  State<TabsShell> createState() => _TabsShellState();
}

class _TabsShellState extends State<TabsShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    HistoryScreen(),
    SecurityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
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
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(icon: Icon(LucideIcons.home), label: 'Accueil'),
            NavigationDestination(icon: Icon(LucideIcons.receipt), label: 'Historique'),
            NavigationDestination(icon: Icon(LucideIcons.shield), label: 'Sécurité'),
            NavigationDestination(icon: Icon(LucideIcons.user), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

