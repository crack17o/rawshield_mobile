import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/routes.dart';
import '../../theme/rawshield_theme.dart';
import 'transfer_state.dart';

class TransferResultScreen extends ConsumerWidget {
  const TransferResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final draft = ref.watch(transferDraftProvider);
    final amount = draft.amountCdf ?? 0;
    final blocked = amount >= 250000;

    return Scaffold(
      backgroundColor: RawShieldColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RawShieldSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: RawShieldSpacing.xl),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: blocked
                      ? const Color.fromRGBO(255, 61, 0, 0.15)
                      : const Color.fromRGBO(0, 200, 83, 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  blocked ? LucideIcons.alertTriangle : LucideIcons.checkCircle2,
                  color: blocked ? RawShieldColors.error : RawShieldColors.success,
                  size: 40,
                ),
              ),
              const SizedBox(height: RawShieldSpacing.lg),
              Text(
                blocked ? 'Transfert bloqué' : 'Transfert validé',
                style: t.headlineMedium?.copyWith(color: RawShieldColors.text),
              ),
              const SizedBox(height: RawShieldSpacing.sm),
              Text(
                blocked
                    ? 'RAWShield AI a détecté un risque élevé sur ce transfert.'
                    : 'Votre transfert a été traité avec succès.',
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
                    Text('Détails', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                    const SizedBox(height: RawShieldSpacing.md),
                    _row(t, 'Destinataire', draft.recipientName ?? '—'),
                    _row(t, 'Montant', '$amount CDF'),
                    _row(t, 'Décision', blocked ? 'Blocage automatique' : 'Autorisation'),
                    _row(t, 'Confiance modèle', blocked ? '71%' : '94%'),
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
                  child: const Text('Retour à l’accueil'),
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
                  child: const Text('Nouveau transfert'),
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

