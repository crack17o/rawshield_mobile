import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_strings.dart';
import '../../l10n/language_globe_button.dart';
import '../../theme/rawshield_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                RawShieldSpacing.lg,
                RawShieldSpacing.xxl,
                RawShieldSpacing.lg,
                RawShieldSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      s.notifTitle,
                      overflow: TextOverflow.ellipsis,
                      style: t.headlineMedium?.copyWith(color: RawShieldColors.text),
                    ),
                  ),
                  const LanguageGlobeButton(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
                    child: Text(
                      s.notifMarkAllRead,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(color: RawShieldColors.gold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(RawShieldSpacing.md),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(212, 175, 55, 0.20),
                  borderRadius: BorderRadius.circular(RawShieldRadii.md),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.bell, size: 16, color: RawShieldColors.gold),
                    const SizedBox(width: RawShieldSpacing.sm),
                    Text(s.notifUnreadBanner, style: t.bodySmall?.copyWith(color: RawShieldColors.gold, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: RawShieldSpacing.lg),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
                children: [
                  Text(s.notifToday, style: t.bodyMedium?.copyWith(color: RawShieldColors.textSecondary)),
                  const SizedBox(height: RawShieldSpacing.md),
                  _NotificationItem(
                    icon: LucideIcons.shield,
                    iconColor: RawShieldColors.error,
                    bg: const Color.fromRGBO(255, 61, 0, 0.15),
                    title: s.notif1Title,
                    message: s.notif1Msg,
                    time: s.notifTime5m,
                    unread: true,
                  ),
                  _NotificationItem(
                    icon: LucideIcons.alertTriangle,
                    iconColor: RawShieldColors.warning,
                    bg: const Color.fromRGBO(255, 179, 0, 0.15),
                    title: s.notif2Title,
                    message: s.notif2Msg,
                    time: s.notifTime1h,
                    unread: true,
                  ),
                  _NotificationItem(
                    icon: LucideIcons.check,
                    iconColor: RawShieldColors.success,
                    bg: const Color.fromRGBO(0, 200, 83, 0.15),
                    title: s.notif3Title,
                    message: s.notif3Msg,
                    time: s.notifTime5h,
                    unread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.bg,
    required this.title,
    required this.message,
    required this.time,
    required this.unread,
  });

  final IconData icon;
  final Color iconColor;
  final Color bg;
  final String title;
  final String message;
  final String time;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      padding: const EdgeInsets.all(RawShieldSpacing.md),
      decoration: BoxDecoration(
        color: unread ? RawShieldColors.surfaceElevated : RawShieldColors.surface,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        border: Border.all(color: unread ? const Color.fromRGBO(212, 175, 55, 0.30) : RawShieldColors.border),
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
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: RawShieldSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                    ),
                    if (unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: RawShieldColors.gold, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: RawShieldSpacing.xs),
                Text(message, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                const SizedBox(height: RawShieldSpacing.xs),
                Text(time, style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(width: RawShieldSpacing.md),
          const Icon(LucideIcons.chevronRight, color: RawShieldColors.textMuted),
        ],
      ),
    );
  }
}

