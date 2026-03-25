import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/routes.dart';
import '../../theme/rawshield_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final items = const [
      (LucideIcons.user, 'Informations personnelles', 'Modifier votre profil'),
      (LucideIcons.creditCard, 'Mes cartes', 'Gérer vos cartes bancaires'),
      (LucideIcons.lock, 'Sécurité', 'Mot de passe, biométrie'),
      (LucideIcons.smartphone, 'Appareils connectés', '2 appareils actifs'),
      (LucideIcons.settings, 'Paramètres', 'Notifications, langue'),
      (LucideIcons.helpCircle, 'Aide & Support', "Centre d'aide, contact"),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            RawShieldSpacing.lg,
            RawShieldSpacing.xxl,
            RawShieldSpacing.lg,
            RawShieldSpacing.lg,
          ),
          children: [
            Text('Profil', style: t.headlineMedium?.copyWith(color: RawShieldColors.text)),
            const SizedBox(height: RawShieldSpacing.lg),

            // User Card
            Container(
              padding: const EdgeInsets.all(RawShieldSpacing.lg),
              decoration: BoxDecoration(
                color: RawShieldColors.surfaceElevated,
                borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                border: Border.all(color: RawShieldColors.border),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(212, 175, 55, 0.25),
                      shape: BoxShape.circle,
                      border: Border.all(color: RawShieldColors.gold, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text('JM', style: t.headlineLarge?.copyWith(color: RawShieldColors.gold)),
                  ),
                  const SizedBox(height: RawShieldSpacing.md),
                  Text('Jean Mutombo', style: t.titleLarge?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.xs),
                  Text('jean.mutombo@email.cd', style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text('+243 81 234 5678', style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted)),
                  const SizedBox(height: RawShieldSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.sm, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(212, 175, 55, 0.20),
                      borderRadius: BorderRadius.circular(RawShieldRadii.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.shield, size: 14, color: RawShieldColors.gold),
                        const SizedBox(width: RawShieldSpacing.xs),
                        Text('Vérifié', style: t.labelSmall?.copyWith(color: RawShieldColors.gold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),

            // Limits card
            Container(
              padding: const EdgeInsets.all(RawShieldSpacing.md),
              decoration: BoxDecoration(
                color: RawShieldColors.surface,
                borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                border: Border.all(color: RawShieldColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Plafonds du compte', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.md),
                  _LimitRow(label: 'Transfert journalier', value: '5,000,000 CDF'),
                  const SizedBox(height: RawShieldSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RawShieldRadii.full),
                    child: Container(
                      height: 6,
                      color: RawShieldColors.surfaceLight,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.45,
                        child: Container(color: RawShieldColors.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: RawShieldSpacing.xs),
                  Text("2,250,000 CDF utilisé aujourd'hui", style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
                  const SizedBox(height: RawShieldSpacing.md),
                  _LimitRow(label: 'Retrait mensuel', value: '50,000,000 CDF'),
                ],
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),

            // Menu items
            ...items.map((it) => _MenuItem(icon: it.$1, title: it.$2, subtitle: it.$3)),

            const SizedBox(height: RawShieldSpacing.lg),

            // Logout
            OutlinedButton.icon(
              onPressed: () => context.go(AppRoutes.login),
              icon: const Icon(LucideIcons.logOut, color: RawShieldColors.error),
              label: Text('Déconnexion', style: t.bodyMedium?.copyWith(color: RawShieldColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: RawShieldColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.lg)),
                padding: const EdgeInsets.all(RawShieldSpacing.md),
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),
            Center(child: Text('RAWShield AI v1.0.0', style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted))),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      padding: const EdgeInsets.all(RawShieldSpacing.md),
      decoration: BoxDecoration(
        color: RawShieldColors.surface,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        border: Border.all(color: RawShieldColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(212, 175, 55, 0.20),
              borderRadius: BorderRadius.circular(RawShieldRadii.md),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: RawShieldColors.gold, size: 22),
          ),
          const SizedBox(width: RawShieldSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: 2),
                Text(subtitle, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: RawShieldColors.textMuted),
        ],
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  const _LimitRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
        Text(value, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
      ],
    );
  }
}

