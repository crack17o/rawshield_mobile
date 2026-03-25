import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/rawshield_theme.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  String _mode = 'atm';
  bool _generated = false;
  int _timer = 600;
  bool _copied = false;
  Timer? _t;

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _generateCode() {
    setState(() {
      _generated = true;
      _timer = 600;
    });
    _t?.cancel();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_timer <= 0) {
        t.cancel();
      } else {
        setState(() => _timer -= 1);
      }
    });
  }

  void _copy() {
    setState(() => _copied = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _copied = false);
    });
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    const code = '843927';

    return Dialog.fullscreen(
      backgroundColor: RawShieldColors.background,
      child: SafeArea(
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
                      'Retrait',
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
                  Text('Choisir le mode de retrait', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _ModeButton(
                          icon: LucideIcons.mapPin,
                          label: 'Distributeur (ATM)',
                          active: _mode == 'atm',
                          onTap: () => setState(() => _mode = 'atm'),
                        ),
                      ),
                      const SizedBox(width: RawShieldSpacing.md),
                      Expanded(
                        child: _ModeButton(
                          icon: LucideIcons.user,
                          label: 'Agent',
                          active: _mode == 'agent',
                          onTap: () => setState(() => _mode = 'agent'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RawShieldSpacing.xl),
                  if (!_generated) ...[
                    Text('Montant à retirer', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                    const SizedBox(height: RawShieldSpacing.md),
                    Wrap(
                      spacing: RawShieldSpacing.md,
                      runSpacing: RawShieldSpacing.md,
                      children: ['10000', '20000', '50000', '100000', '200000', '500000']
                          .map((a) => _AmountChip(amount: a))
                          .toList(),
                    ),
                    const SizedBox(height: RawShieldSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _generateCode,
                        style: FilledButton.styleFrom(
                          backgroundColor: RawShieldColors.gold,
                          foregroundColor: RawShieldColors.background,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                        ),
                        child: const Text('Générer le code de retrait'),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(RawShieldSpacing.lg),
                      decoration: BoxDecoration(
                        color: RawShieldColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                        border: Border.all(color: RawShieldColors.border),
                      ),
                      child: Column(
                        children: [
                          Text('Code de retrait', style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                          const SizedBox(height: RawShieldSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: code
                                .split('')
                                .map((d) => Container(
                                      width: 44,
                                      height: 52,
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: RawShieldColors.surface,
                                        borderRadius: BorderRadius.circular(RawShieldRadii.md),
                                        border: Border.all(color: RawShieldColors.border),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(d, style: t.titleLarge?.copyWith(color: RawShieldColors.text)),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: RawShieldSpacing.md),
                          TextButton.icon(
                            onPressed: _copy,
                            icon: Icon(_copied ? LucideIcons.check : LucideIcons.copy, color: _copied ? RawShieldColors.success : RawShieldColors.gold),
                            label: Text(_copied ? 'Copié !' : 'Copier le code', style: t.bodySmall?.copyWith(color: RawShieldColors.gold)),
                          ),
                          const SizedBox(height: RawShieldSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.clock, size: 16, color: _timer < 60 ? RawShieldColors.error : RawShieldColors.warning),
                              const SizedBox(width: RawShieldSpacing.sm),
                              Text(
                                'Expire dans ${_formatTime(_timer)}',
                                style: t.bodySmall?.copyWith(color: _timer < 60 ? RawShieldColors.error : RawShieldColors.warning),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: RawShieldSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(RawShieldSpacing.md),
                      decoration: BoxDecoration(
                        color: RawShieldColors.surface,
                        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                        border: Border.all(color: RawShieldColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Instructions', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                          const SizedBox(height: RawShieldSpacing.md),
                          _Step(number: '1', text: 'Rendez-vous au ${_mode == 'atm' ? 'distributeur' : 'point agent'} le plus proche'),
                          _Step(number: '2', text: 'Sélectionnez \"Retrait sans carte\"'),
                          _Step(number: '3', text: 'Saisissez le code de retrait'),
                          _Step(number: '4', text: 'Récupérez votre argent'),
                        ],
                      ),
                    ),
                    const SizedBox(height: RawShieldSpacing.lg),
                    OutlinedButton(
                      onPressed: () => setState(() => _generated = false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: RawShieldColors.borderGold),
                        foregroundColor: RawShieldColors.gold,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: const Text('Générer un nouveau code'),
                    ),
                  ],
                  const SizedBox(height: RawShieldSpacing.lg),
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
                            'Ne partagez jamais ce code avec qui que ce soit.',
                            style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RawShieldSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RawShieldRadii.lg),
      child: Container(
        padding: const EdgeInsets.all(RawShieldSpacing.md),
        decoration: BoxDecoration(
          color: RawShieldColors.surface,
          borderRadius: BorderRadius.circular(RawShieldRadii.lg),
          border: Border.all(color: active ? RawShieldColors.gold : RawShieldColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? RawShieldColors.gold : RawShieldColors.text, size: 22),
            const SizedBox(width: RawShieldSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: t.bodySmall?.copyWith(color: active ? RawShieldColors.gold : RawShieldColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: (MediaQuery.of(context).size.width - RawShieldSpacing.lg * 2 - RawShieldSpacing.md) / 2,
      padding: const EdgeInsets.symmetric(vertical: RawShieldSpacing.md),
      decoration: BoxDecoration(
        color: RawShieldColors.surface,
        borderRadius: BorderRadius.circular(RawShieldRadii.md),
        border: Border.all(color: RawShieldColors.border),
      ),
      alignment: Alignment.center,
      child: Text('${amount} CDF', style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(212, 175, 55, 0.20),
              borderRadius: BorderRadius.circular(RawShieldRadii.full),
            ),
            alignment: Alignment.center,
            child: Text(number, style: t.labelSmall?.copyWith(color: RawShieldColors.gold)),
          ),
          const SizedBox(width: RawShieldSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}

