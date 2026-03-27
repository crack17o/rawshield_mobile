import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_strings.dart';
import '../../theme/rawshield_theme.dart';
import 'transfer_state.dart';
import '../../utils/currency_utils.dart';

class TransferConfirmScreen extends ConsumerWidget {
  const TransferConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    final draft = ref.watch(transferDraftProvider);
    final amount = draft.amountCdf ?? 0;
    final debitCurrency = draft.debitCurrency;
    final amountInDebitCurrency = CurrencyUtils.fromCdfTo(debitCurrency, amount);
    final amountLabel = debitCurrency == CurrencyUtils.usd
        ? '${amountInDebitCurrency.toStringAsFixed(2)} ${CurrencyUtils.usd}'
        : '$amount ${CurrencyUtils.cdf}';

    return Scaffold(
      backgroundColor: RawShieldColors.background,
      body: Column(
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
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: RawShieldColors.text),
                ),
                Expanded(
                  child: Text(
                    s.transferConfirmation,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleLarge?.copyWith(color: RawShieldColors.text),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(RawShieldRadii.full),
                  child: Container(
                    height: 4,
                    color: RawShieldColors.surfaceLight,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.62,
                      child: Container(color: RawShieldColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.sm),
                Text(s.tfWizStep3, style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: RawShieldSpacing.lg),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
              children: [
                Container(
                  padding: const EdgeInsets.all(RawShieldSpacing.lg),
                  decoration: BoxDecoration(
                    color: RawShieldColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                    border: Border.all(color: RawShieldColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.tfRecap, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                      const SizedBox(height: RawShieldSpacing.md),
                      _Row(label: s.transferRecipientTitle, value: draft.recipientName ?? '—'),
                      _Row(label: s.tfRowPhone, value: draft.recipientPhone ?? '—'),
                      _Row(label: s.tfRowDebitAccount, value: debitCurrency),
                      _Row(label: s.txnAmount, value: amountLabel),
                      if ((draft.note ?? '').isNotEmpty) _Row(label: s.tfRowMotif, value: draft.note!),
                      const SizedBox(height: RawShieldSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(RawShieldSpacing.md),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(212, 175, 55, 0.15),
                          borderRadius: BorderRadius.circular(RawShieldRadii.md),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.shield, size: 16, color: RawShieldColors.gold),
                            const SizedBox(width: RawShieldSpacing.sm),
                            Expanded(
                              child: Text(
                                amount >= 250000
                                    ? s.tfOtpHighRiskLine
                                    : s.tfOtpLowRiskLine,
                                style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(RawShieldSpacing.lg),
            decoration: const BoxDecoration(
              color: RawShieldColors.background,
              border: Border(top: BorderSide(color: RawShieldColors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pushNamed('/otp'),
                style: FilledButton.styleFrom(
                  backgroundColor: RawShieldColors.gold,
                  foregroundColor: RawShieldColors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                ),
                child: Text(s.tfValider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted)),
          const SizedBox(width: RawShieldSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: t.bodyMedium?.copyWith(color: RawShieldColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

