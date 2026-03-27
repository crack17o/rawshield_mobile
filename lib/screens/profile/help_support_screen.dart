import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_strings.dart';
import '../../theme/rawshield_theme.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  static const _supportPhone = '123456';

  Future<void> _call(BuildContext context, WidgetRef ref) async {
    final uri = Uri.parse('tel:$_supportPhone');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!ok) {
      final s = ref.read(appStringsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.phoneLaunchError)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: RawShieldColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                RawShieldSpacing.sm,
                RawShieldSpacing.sm,
                RawShieldSpacing.lg,
                RawShieldSpacing.md,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: RawShieldColors.text),
                  ),
                  Expanded(
                    child: Text(
                      s.helpTitle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleLarge?.copyWith(color: RawShieldColors.text),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
                children: [
                  Text(s.faqTitle, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.md),
                  _FaqTile(question: s.faq1q, answer: s.faq1a),
                  _FaqTile(question: s.faq2q, answer: s.faq2a),
                  const SizedBox(height: RawShieldSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () => _call(context, ref),
                      style: FilledButton.styleFrom(
                        backgroundColor: RawShieldColors.gold,
                        foregroundColor: RawShieldColors.background,
                      ),
                      icon: const Icon(LucideIcons.phone, size: 22),
                      label: Text(s.callService),
                    ),
                  ),
                  const SizedBox(height: RawShieldSpacing.sm),
                  Text(
                    '${s.callServiceHint} ($_supportPhone)',
                    textAlign: TextAlign.center,
                    style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted),
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

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      child: Material(
        color: RawShieldColors.surface,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        child: InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(RawShieldRadii.lg),
          child: Container(
            padding: const EdgeInsets.all(RawShieldSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RawShieldRadii.lg),
              border: Border.all(color: RawShieldColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.question, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                    ),
                    Icon(
                      _open ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                      color: RawShieldColors.textMuted,
                      size: 20,
                    ),
                  ],
                ),
                if (_open) ...[
                  const SizedBox(height: RawShieldSpacing.sm),
                  Text(
                    widget.answer,
                    style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary, height: 1.45),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
