import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/rawshield_theme.dart';
import 'app_strings.dart';
import 'locale_provider.dart';

class LanguageGlobeButton extends ConsumerWidget {
  const LanguageGlobeButton({super.key});

  Future<void> _openSheet(BuildContext context, WidgetRef ref) async {
    final s = ref.read(appStringsProvider);
    final current = ref.read(localeProvider).languageCode;
    final t = Theme.of(context).textTheme;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: RawShieldColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RawShieldRadii.xl)),
      ),
      builder: (ctx) {
        Future<void> setLang(String code) async {
          await ref.read(localeProvider.notifier).setLocale(Locale(code));
          if (ctx.mounted) Navigator.of(ctx).pop();
        }

        Widget tile({required String label, required bool selected, required VoidCallback onTap}) {
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
                    border: Border.all(color: selected ? RawShieldColors.borderGold : RawShieldColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(label, style: t.bodyMedium?.copyWith(color: RawShieldColors.text))),
                      if (selected) const Icon(LucideIcons.check, color: RawShieldColors.gold, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(RawShieldSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.globe, color: RawShieldColors.gold),
                    const SizedBox(width: RawShieldSpacing.sm),
                    Expanded(child: Text(s.languageTitle, style: t.titleMedium?.copyWith(color: RawShieldColors.text))),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close, color: RawShieldColors.textMuted),
                      tooltip: s.commonCancel,
                    ),
                  ],
                ),
                const SizedBox(height: RawShieldSpacing.md),
                tile(label: s.languageFr, selected: current == 'fr', onTap: () => setLang('fr')),
                tile(label: s.languageEn, selected: current == 'en', onTap: () => setLang('en')),
                tile(label: s.languageLn, selected: current == 'ln', onTap: () => setLang('ln')),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => _openSheet(context, ref),
      icon: const Icon(LucideIcons.globe, color: RawShieldColors.gold),
      tooltip: 'Langue',
    );
  }
}

