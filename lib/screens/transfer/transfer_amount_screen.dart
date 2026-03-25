import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/rawshield_theme.dart';
import 'transfer_state.dart';

class TransferAmountScreen extends ConsumerStatefulWidget {
  const TransferAmountScreen({super.key});

  @override
  ConsumerState<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends ConsumerState<TransferAmountScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int? get _amount {
    final raw = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final draft = ref.watch(transferDraftProvider);
    final canContinue = (_amount ?? 0) > 0;

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
                    "Envoyer de l'argent",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleLarge?.copyWith(color: RawShieldColors.text),
                  ),
                ),
                const SizedBox(width: 48), // équilibre visuel avec IconButton
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
                      widthFactor: 0.40,
                      child: Container(color: RawShieldColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.sm),
                Text('Étape 2 sur 5 : Montant', style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: RawShieldSpacing.lg),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
              children: [
                Container(
                  padding: const EdgeInsets.all(RawShieldSpacing.md),
                  decoration: BoxDecoration(
                    color: RawShieldColors.surface,
                    borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                    border: Border.all(color: RawShieldColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.user, color: RawShieldColors.gold),
                      const SizedBox(width: RawShieldSpacing.sm),
                      Expanded(
                        child: Text(
                          draft.recipientName ?? 'Destinataire',
                          style: t.bodyMedium?.copyWith(color: RawShieldColors.text),
                        ),
                      ),
                      Text(
                        draft.recipientPhone ?? '',
                        style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.lg),
                Text('Montant (CDF)', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: RawShieldSpacing.sm),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'ex: 250000',
                    prefixIcon: Icon(LucideIcons.coins, color: RawShieldColors.textSecondary),
                  ),
                  style: const TextStyle(color: RawShieldColors.text),
                ),
                const SizedBox(height: RawShieldSpacing.lg),
                Text('Motif (optionnel)', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: RawShieldSpacing.sm),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(hintText: 'ex: Transfert amical'),
                  style: const TextStyle(color: RawShieldColors.text),
                ),
                const SizedBox(height: RawShieldSpacing.xl),
                Container(
                  padding: const EdgeInsets.all(RawShieldSpacing.md),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 179, 0, 0.10),
                    borderRadius: BorderRadius.circular(RawShieldRadii.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.shield, size: 16, color: RawShieldColors.warning),
                      const SizedBox(width: RawShieldSpacing.sm),
                      Expanded(
                        child: Text(
                          'RAWShield AI vérifiera la transaction avant validation.',
                          style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.xxl),
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
                onPressed: canContinue
                    ? () {
                        final amt = _amount ?? 0;
                        ref.read(transferDraftProvider.notifier).setAmount(amt);
                        ref.read(transferDraftProvider.notifier).setNote(_noteController.text.trim());
                        Navigator.of(context).pushNamed('/confirm');
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: RawShieldColors.gold,
                  foregroundColor: RawShieldColors.background,
                  disabledBackgroundColor: const Color.fromRGBO(212, 175, 55, 0.25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                ),
                child: const Text('Continuer'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

