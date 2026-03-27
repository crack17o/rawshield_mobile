import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_strings.dart';
import '../../l10n/language_globe_button.dart';
import '../../theme/rawshield_theme.dart';

class StatementScreen extends ConsumerStatefulWidget {
  const StatementScreen({super.key});

  @override
  ConsumerState<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends ConsumerState<StatementScreen> {
  String _range = '30d';

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appStringsProvider);
    final t = Theme.of(context).textTheme;

    final options = <(String, String)>[
      (s.statementRange7d, '7d'),
      (s.statementRange30d, '30d'),
      (s.statementRange3m, '3m'),
      (s.statementRange6m, '6m'),
    ];

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
                      s.statementTitle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleLarge?.copyWith(color: RawShieldColors.text),
                    ),
                  ),
                  const LanguageGlobeButton(),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
                children: [
                  Text(s.statementChooseRange, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.md),
                  ...options.map((o) {
                    final selected = _range == o.$2;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
                      child: Material(
                        color: RawShieldColors.surface,
                        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                        child: InkWell(
                          onTap: () => setState(() => _range = o.$2),
                          borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                          child: Container(
                            padding: const EdgeInsets.all(RawShieldSpacing.md),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                              border: Border.all(color: selected ? RawShieldColors.borderGold : RawShieldColors.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(o.$1, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                                ),
                                if (selected)
                                  const Icon(Icons.check, color: RawShieldColors.gold, size: 20)
                                else
                                  const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: RawShieldSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(s.statementRequestedSnack)),
                        );
                        context.pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: RawShieldColors.gold,
                        foregroundColor: RawShieldColors.background,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                      ),
                      child: Text(s.statementRequest),
                    ),
                  ),
                  const SizedBox(height: RawShieldSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

