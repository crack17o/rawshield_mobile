import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/routes.dart';
import '../../l10n/app_strings.dart';
import '../../providers/tab_index_provider.dart';
import '../../services/app_prefs.dart';
import '../../theme/rawshield_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
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
            Text(s.profileTitle, style: t.headlineMedium?.copyWith(color: RawShieldColors.text)),
            const SizedBox(height: RawShieldSpacing.lg),

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
                        Text(s.verified, style: t.labelSmall?.copyWith(color: RawShieldColors.gold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),

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
                  Text(s.accountLimitsTitle, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.md),
                  _LimitRow(label: s.dailyTransferLimit, value: '5,000,000 CDF'),
                  const SizedBox(height: RawShieldSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RawShieldRadii.full),
                    child: Container(
                      height: 6,
                      color: RawShieldColors.surfaceLight,
                      child: const FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.45,
                        child: ColoredBox(color: RawShieldColors.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: RawShieldSpacing.xs),
                  Text('2,250,000 CDF ${s.usedToday}', style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
                  const SizedBox(height: RawShieldSpacing.md),
                  _LimitRow(label: s.monthlyWithdrawal, value: '50,000,000 CDF'),
                ],
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),

            _MenuItem(
              icon: LucideIcons.user,
              title: s.menuPersonalInfo,
              subtitle: s.menuPersonalInfoSub,
              onTap: () => context.push(AppRoutes.profilePersonalInfo),
            ),
            _MenuItem(
              icon: LucideIcons.keyRound,
              title: s.menuPin,
              subtitle: s.menuPinSub,
              onTap: () {
                ref.read(tabIndexProvider.notifier).setIndex(2);
                context.go(AppRoutes.tabs);
              },
            ),
            _MenuItem(
              icon: LucideIcons.settings,
              title: s.menuSettings,
              subtitle: s.menuSettingsSub,
              onTap: () => context.push(AppRoutes.profileSettings),
            ),
            _MenuItem(
              icon: LucideIcons.helpCircle,
              title: s.menuHelp,
              subtitle: s.menuHelpSub,
              onTap: () => context.push(AppRoutes.profileHelp),
            ),

            const SizedBox(height: RawShieldSpacing.lg),

            OutlinedButton.icon(
              onPressed: () async {
                await AppPrefs.setSignedIn(false);
                if (!context.mounted) return;
                context.go(AppRoutes.login);
              },
              icon: const Icon(LucideIcons.logOut, color: RawShieldColors.error),
              label: Text(s.logout, style: t.bodyMedium?.copyWith(color: RawShieldColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: RawShieldColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.lg)),
                padding: const EdgeInsets.all(RawShieldSpacing.md),
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),
            Center(child: Text(s.appVersion, style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted))),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      child: Material(
        color: RawShieldColors.surface,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RawShieldRadii.lg),
          child: Container(
            padding: const EdgeInsets.all(RawShieldSpacing.md),
            decoration: BoxDecoration(
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
          ),
        ),
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
