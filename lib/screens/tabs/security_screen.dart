import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/rawshield_theme.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
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
            Text('Sécurité', style: t.headlineMedium?.copyWith(color: RawShieldColors.text)),
            const SizedBox(height: RawShieldSpacing.lg),

            // Status card
            Container(
              padding: const EdgeInsets.all(RawShieldSpacing.lg),
              decoration: BoxDecoration(
                color: RawShieldColors.surfaceElevated,
                borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                border: Border.all(color: RawShieldColors.borderGold),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(212, 175, 55, 0.25),
                      borderRadius: BorderRadius.circular(RawShieldRadii.full),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(LucideIcons.shieldCheck, size: 40, color: RawShieldColors.gold),
                  ),
                  const SizedBox(width: RawShieldSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Niveau de sécurité', style: t.bodyLarge?.copyWith(color: RawShieldColors.textSecondary)),
                        const SizedBox(height: RawShieldSpacing.xs),
                        Text('ÉLEVÉ', style: t.headlineMedium?.copyWith(color: RawShieldColors.gold)),
                        const SizedBox(height: RawShieldSpacing.xs),
                        Text(
                          'Votre compte est bien protégé par RAWShield AI',
                          style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),

            // Trust score
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
                  Text('Score de confiance RAWShield', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RawShieldRadii.full),
                    child: Container(
                      height: 8,
                      color: RawShieldColors.surfaceLight,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.92,
                        child: Container(color: RawShieldColors.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: RawShieldSpacing.sm),
                  Text('92/100', style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                ],
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),

            Text('Fonctionnalités de sécurité', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
            const SizedBox(height: RawShieldSpacing.md),
            _FeatureItem(icon: LucideIcons.shieldCheck, title: 'RAWShield AI', subtitle: 'Protection intelligente activée', active: true),
            _FeatureItem(icon: LucideIcons.lock, title: 'Authentification biométrique', subtitle: 'Empreinte & Face ID', active: true),
            _FeatureItem(icon: LucideIcons.smartphone, title: 'Appareils connectés', subtitle: '2 appareils actifs', active: false),
            _FeatureItem(icon: LucideIcons.key, title: 'Mot de passe', subtitle: 'Dernier changement il y a 15 jours', active: false),

            const SizedBox(height: RawShieldSpacing.lg),
            Text('Alertes récentes', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
            const SizedBox(height: RawShieldSpacing.md),
            _AlertItem(icon: LucideIcons.alertTriangle, color: RawShieldColors.error, bg: const Color.fromRGBO(255, 61, 0, 0.15), title: 'Transaction bloquée', subtitle: 'Montant inhabituel détecté : 250,000 CDF', time: 'Il y a 2 heures'),
            _AlertItem(icon: LucideIcons.alertTriangle, color: RawShieldColors.warning, bg: const Color.fromRGBO(255, 179, 0, 0.15), title: 'Nouvel appareil détecté', subtitle: 'Connexion depuis un nouvel appareil', time: 'Il y a 1 jour'),
            _AlertItem(icon: LucideIcons.shieldCheck, color: RawShieldColors.success, bg: const Color.fromRGBO(0, 200, 83, 0.15), title: 'Mise à jour de sécurité', subtitle: 'RAWShield AI a été mis à jour', time: 'Il y a 3 jours'),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final color = active ? RawShieldColors.success : RawShieldColors.text;
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
              color: Color.fromRGBO(color.red, color.green, color.blue, 0.12),
              borderRadius: BorderRadius.circular(RawShieldRadii.md),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 22),
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
          const SizedBox(width: RawShieldSpacing.sm),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? RawShieldColors.success : RawShieldColors.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: RawShieldSpacing.sm),
          const Icon(LucideIcons.chevronRight, color: RawShieldColors.textMuted),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  const _AlertItem({
    required this.icon,
    required this.color,
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final Color color;
  final Color bg;
  final String title;
  final String subtitle;
  final String time;

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
              color: bg,
              borderRadius: BorderRadius.circular(RawShieldRadii.md),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: RawShieldSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: 2),
                Text(subtitle, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                const SizedBox(height: 2),
                Text(time, style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

