import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/routes.dart';
import '../../l10n/app_strings.dart';
import '../../l10n/language_globe_button.dart';
import '../../theme/rawshield_theme.dart';
import '../../utils/currency_utils.dart';
import 'transfer_state.dart';
import 'transfer_risk_utils.dart';
import 'transfer_plafond_utils.dart';

class TransferResultScreen extends ConsumerWidget {
  const TransferResultScreen({super.key});

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

    final riskScore = TransferRiskUtils.computeRiskScore(amountCdf: draft.amountCdf);
    final riskLevel = TransferRiskUtils.getRiskLevel(riskScore);

    final isPlafondExceeded =
        amount > TransferPlafondUtils.userPlafondCdf(debitCurrency: debitCurrency);

    final blocked = isPlafondExceeded || riskLevel == TransferRiskLevel.veryHigh;
    final delayed = !isPlafondExceeded && riskLevel == TransferRiskLevel.high;

    return Scaffold(
      backgroundColor: RawShieldColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RawShieldSpacing.lg),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: LanguageGlobeButton(),
              ),
              const SizedBox(height: RawShieldSpacing.xl),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: blocked
                      ? const Color.fromRGBO(255, 61, 0, 0.15)
                      : delayed
                          ? const Color.fromRGBO(255, 179, 0, 0.15)
                          : const Color.fromRGBO(0, 200, 83, 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  blocked
                      ? LucideIcons.alertTriangle
                      : delayed
                          ? LucideIcons.alertTriangle
                          : LucideIcons.checkCircle2,
                  color: blocked
                      ? RawShieldColors.error
                      : delayed
                          ? RawShieldColors.warning
                          : RawShieldColors.success,
                  size: 40,
                ),
              ),
              const SizedBox(height: RawShieldSpacing.lg),
              Text(
                blocked
                    ? (isPlafondExceeded ? s.trTitlePlafond : s.trTitleBlocked)
                    : delayed
                        ? s.trTitlePending
                        : s.trTitleOk,
                style: t.headlineMedium?.copyWith(color: RawShieldColors.text),
              ),
              const SizedBox(height: RawShieldSpacing.sm),
              Text(
                blocked
                    ? (isPlafondExceeded ? s.trBodyPlafond : s.trBodyBlocked)
                    : delayed
                        ? s.trBodyPending
                        : s.trBodyOk,
                textAlign: TextAlign.center,
                style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
              ),
              const SizedBox(height: RawShieldSpacing.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(RawShieldSpacing.lg),
                decoration: BoxDecoration(
                  color: RawShieldColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                  border: Border.all(color: RawShieldColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.txnDetailsSection, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                    const SizedBox(height: RawShieldSpacing.md),
                    _row(t, s.transferRecipientTitle, draft.recipientName ?? '—'),
                    _row(t, s.tfRowDebitAccount, debitCurrency),
                    _row(t, s.txnAmount, amountLabel),
                    _row(
                      t,
                      s.txnDecision,
                      blocked
                          ? (isPlafondExceeded ? s.trOutcomeNotAllowed : s.trOutcomeAutoBlock)
                          : delayed
                              ? s.trOutcomeAdvDelay
                              : s.trOutcomeAuthOk,
                    ),
                    _row(
                      t,
                      s.txnModelConfidence,
                      blocked
                          ? (isPlafondExceeded ? '—' : '20%')
                          : delayed
                              ? '55%'
                              : riskLevel == TransferRiskLevel.medium
                                  ? '71%'
                                  : '94%',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    ref.read(transferDraftProvider.notifier).reset();
                    context.go(AppRoutes.tabs);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: RawShieldColors.gold,
                    foregroundColor: RawShieldColors.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                  ),
                  child: Text(s.trBackHome),
                ),
              ),
              const SizedBox(height: RawShieldSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(transferDraftProvider.notifier).reset();
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: RawShieldColors.borderGold),
                    foregroundColor: RawShieldColors.gold,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                  ),
                  child: Text(s.trNewTransfer),
                ),
              ),
              const SizedBox(height: RawShieldSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(TextTheme t, String label, String value) {
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

