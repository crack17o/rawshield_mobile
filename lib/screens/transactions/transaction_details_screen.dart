import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_strings.dart';
import '../../l10n/language_globe_button.dart';
import '../../theme/rawshield_theme.dart';

class TransactionDetails {
  const TransactionDetails({
    required this.id,
    required this.amountLabel,
    required this.status,
    required this.riskScore,
    required this.modelConfidence,
    required this.decision,
    required this.dateLabel,
    required this.location,
    required this.sender,
    required this.receiver,
    required this.currency,
  });

  final String id;
  final String amountLabel;
  final String status;
  final int riskScore;
  final double modelConfidence;
  final String decision;
  final String dateLabel;
  final String location;
  final String sender;
  final String receiver;
  final String currency;
}

class TransactionDetailsScreen extends ConsumerStatefulWidget {
  const TransactionDetailsScreen({super.key, required this.details});

  final TransactionDetails details;

  @override
  ConsumerState<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends ConsumerState<TransactionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    final d = widget.details;

    return Scaffold(
      backgroundColor: RawShieldColors.background,
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
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: RawShieldColors.text),
                  ),
                  Expanded(
                    child: Text(
                      s.txnDetailsTitle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleLarge?.copyWith(color: RawShieldColors.text),
                    ),
                  ),
                  const LanguageGlobeButton(),
                ],
              ),
            ),
            const SizedBox(height: RawShieldSpacing.sm),
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
                        Text(s.txnSummary, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                        const SizedBox(height: RawShieldSpacing.md),
                        _DetailRow(label: s.txnAmount, value: d.amountLabel),
                        _DetailRow(label: s.txnStatus, value: d.status),
                        _DetailRow(label: s.txnRisk, value: '${d.riskScore}/100'),
                        _DetailRow(label: s.txnModelConfidence, value: '${d.modelConfidence.toStringAsFixed(0)}%'),
                        _DetailRow(label: s.txnDecision, value: d.decision),
                        const SizedBox(height: RawShieldSpacing.lg),
                        Text(s.txnDetailsSection, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                        const SizedBox(height: RawShieldSpacing.md),
                        _DetailRow(label: s.txnDate, value: d.dateLabel),
                        _DetailRow(label: s.txnLocation, value: d.location),
                        _DetailRow(label: s.txnSender, value: d.sender),
                        _DetailRow(label: s.txnReceiver, value: d.receiver),
                      ],
                    ),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted)),
          ),
          Expanded(
            child: Text(
              value,
              style: t.bodyMedium?.copyWith(color: RawShieldColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

