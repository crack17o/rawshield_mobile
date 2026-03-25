import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/rawshield_theme.dart';
import 'transfer_state.dart';

class TransferOtpScreen extends ConsumerStatefulWidget {
  const TransferOtpScreen({super.key});

  @override
  ConsumerState<TransferOtpScreen> createState() => _TransferOtpScreenState();
}

class _TransferOtpScreenState extends ConsumerState<TransferOtpScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _valid => _controller.text.replaceAll(RegExp(r'[^0-9]'), '').length >= 6;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final draft = ref.watch(transferDraftProvider);

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
                    'Vérification',
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
                      widthFactor: 0.82,
                      child: Container(color: RawShieldColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.sm),
                Text('Étape 4 sur 5 : OTP', style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
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
                    color: RawShieldColors.surface,
                    borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                    border: Border.all(color: RawShieldColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code OTP', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                      const SizedBox(height: RawShieldSpacing.xs),
                      Text(
                        'Entrez le code reçu par SMS pour valider le transfert.',
                        style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                      ),
                      const SizedBox(height: RawShieldSpacing.md),
                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: '******',
                          prefixIcon: Icon(LucideIcons.keyRound, color: RawShieldColors.textSecondary),
                        ),
                        style: const TextStyle(color: RawShieldColors.text, letterSpacing: 4),
                        maxLength: 6,
                      ),
                      const SizedBox(height: RawShieldSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(RawShieldSpacing.md),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 179, 0, 0.10),
                          borderRadius: BorderRadius.circular(RawShieldRadii.md),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.alertTriangle, size: 16, color: RawShieldColors.warning),
                            const SizedBox(width: RawShieldSpacing.sm),
                            Expanded(
                              child: Text(
                                'Ne partagez jamais ce code. Destinataire: ${draft.recipientName ?? '—'}',
                                style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: RawShieldSpacing.md),
                      TextButton(
                        onPressed: () {},
                        child: Text('Renvoyer le code', style: t.bodySmall?.copyWith(color: RawShieldColors.gold)),
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
                onPressed: _valid
                    ? () => Navigator.of(context).pushNamed('/result')
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: RawShieldColors.gold,
                  foregroundColor: RawShieldColors.background,
                  disabledBackgroundColor: const Color.fromRGBO(212, 175, 55, 0.25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                ),
                child: const Text('Confirmer'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

