import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/rawshield_theme.dart';
import 'transfer_state.dart';

class TransferConfirmScreen extends ConsumerWidget {
  const TransferConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final draft = ref.watch(transferDraftProvider);
    final amount = draft.amountCdf ?? 0;

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
                    'Confirmation',
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
                Text('Étape 3 sur 5 : Confirmer', style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
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
                      Text('Récapitulatif', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                      const SizedBox(height: RawShieldSpacing.md),
                      _Row(label: 'Destinataire', value: draft.recipientName ?? '—'),
                      _Row(label: 'Téléphone', value: draft.recipientPhone ?? '—'),
                      _Row(label: 'Montant', value: '${amount.toString()} CDF'),
                      if ((draft.note ?? '').isNotEmpty) _Row(label: 'Motif', value: draft.note!),
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
                                    ? 'RAWShield AI demande une vérification (OTP) pour ce montant.'
                                    : 'RAWShield AI est actif — validation rapide.',
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
                child: const Text('Valider'),
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

