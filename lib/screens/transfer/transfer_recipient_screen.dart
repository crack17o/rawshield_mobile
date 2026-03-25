import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/rawshield_theme.dart';
import 'transfer_flow.dart';
import 'transfer_state.dart';

class TransferRecipientScreen extends ConsumerStatefulWidget {
  const TransferRecipientScreen({super.key});

  @override
  ConsumerState<TransferRecipientScreen> createState() => _TransferRecipientScreenState();
}

class _TransferRecipientScreenState extends ConsumerState<TransferRecipientScreen> {
  final _controller = TextEditingController();
  String? _selected;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canContinue => _controller.text.trim().isNotEmpty || _selected != null;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: RawShieldColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TransferHeader(title: "Envoyer de l'argent"),
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
                      widthFactor: 0.2,
                      child: Container(color: RawShieldColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.sm),
                Text('Étape 1 sur 5 : Destinataire', style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: RawShieldSpacing.lg),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
              children: [
                Text('Numéro ou compte', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: RawShieldSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: RawShieldColors.surface,
                    borderRadius: BorderRadius.circular(RawShieldRadii.md),
                    border: Border.all(color: RawShieldColors.border),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.md),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.search, size: 20, color: RawShieldColors.textMuted),
                      const SizedBox(width: RawShieldSpacing.sm),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Entrez un numéro de téléphone',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: RawShieldColors.text),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.xl),
                Text('Contacts fréquents', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: RawShieldSpacing.md),
                SizedBox(
                  height: 96,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _ContactChip(
                        label: 'Nouveau',
                        icon: LucideIcons.plus,
                        selected: false,
                        onTap: () {},
                      ),
                      ...['Marie', 'Pierre', 'Sarah', 'Joseph'].map((name) {
                        final selected = _selected == name;
                        return _ContactChip(
                          label: name,
                          icon: null,
                          selected: selected,
                          onTap: () => setState(() => _selected = name),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.xl),
                Text('Récents', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: RawShieldSpacing.md),
                ...['Marie Kabongo', 'Pierre Ilunga'].map((name) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
                    padding: const EdgeInsets.all(RawShieldSpacing.md),
                    decoration: BoxDecoration(
                      color: RawShieldColors.surface,
                      borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                      border: Border.all(color: RawShieldColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(212, 175, 55, 0.20),
                            borderRadius: BorderRadius.circular(RawShieldRadii.md),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(LucideIcons.user, color: RawShieldColors.gold, size: 20),
                        ),
                        const SizedBox(width: RawShieldSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                              const SizedBox(height: 2),
                              Text('+243 81 111 2222', style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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
                onPressed: _canContinue
                    ? () {
                        final selectedName = _selected ?? _controller.text.trim();
                        ref.read(transferDraftProvider.notifier).setRecipient(
                              name: selectedName,
                              phone: '+243 81 111 2222',
                            );
                        Navigator.of(context).pushNamed('/amount');
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

class _ContactChip extends StatelessWidget {
  const _ContactChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(right: RawShieldSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: RawShieldColors.surfaceElevated,
                borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                border: Border.all(color: selected ? RawShieldColors.gold : RawShieldColors.border),
              ),
              alignment: Alignment.center,
              child: icon != null
                  ? Icon(icon, color: RawShieldColors.gold, size: 24)
                  : Text(label.substring(0, 1), style: t.titleLarge?.copyWith(color: RawShieldColors.gold)),
            ),
            const SizedBox(height: RawShieldSpacing.xs),
            SizedBox(
              width: 72,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary),
              ),
            ),
            if (selected)
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: RawShieldColors.gold, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

