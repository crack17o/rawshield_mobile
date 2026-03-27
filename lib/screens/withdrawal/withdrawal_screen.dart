import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_strings.dart';
import '../../theme/rawshield_theme.dart';
import '../../utils/currency_utils.dart';
import '../transfer/transfer_plafond_utils.dart';
import '../transfer/transfer_risk_utils.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  String _mode = 'atm';
  String _debitCurrency = CurrencyUtils.cdf;
  bool _generated = false;
  int _timer = 600;
  bool _copied = false;
  Timer? _t;
  int? _selectedAmountCdf;

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _generateCode() {
    final selectedAmountCdf = _selectedAmountCdf;
    if (selectedAmountCdf == null) return;

    final userPlafondCdf = TransferPlafondUtils.userPlafondCdf(debitCurrency: _debitCurrency);
    final isPlafondExceeded = selectedAmountCdf > userPlafondCdf;
    final riskScore = TransferRiskUtils.computeRiskScore(amountCdf: selectedAmountCdf);
    final riskLevel = TransferRiskUtils.getRiskLevel(riskScore);
    final isBlocked = riskLevel == TransferRiskLevel.veryHigh;
    final isPending = riskLevel == TransferRiskLevel.high;

    final s = ref.read(appStringsProvider);
    if (isPlafondExceeded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            s.wPlafondSnack,
          ),
        ),
      );
      return;
    }
    if (isPending) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            s.wPendingSnack,
          ),
        ),
      );
      return;
    }
    if (isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            s.wBlockedSnack,
          ),
        ),
      );
      return;
    }

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
    final s = ref.watch(appStringsProvider);
    const code = '843927';

    final selectedAmountCdf = _selectedAmountCdf;
    final userPlafondCdf = TransferPlafondUtils.userPlafondCdf(debitCurrency: _debitCurrency);
    final isPlafondExceeded = selectedAmountCdf != null && selectedAmountCdf > userPlafondCdf;
    final riskScore = TransferRiskUtils.computeRiskScore(amountCdf: selectedAmountCdf);
    final riskLevel = TransferRiskUtils.getRiskLevel(riskScore);
    final isBlocked = riskLevel == TransferRiskLevel.veryHigh;
    final isPending = riskLevel == TransferRiskLevel.high;
    final canGenerate = !_generated &&
        selectedAmountCdf != null &&
        !isPlafondExceeded &&
        !isBlocked &&
        !isPending;

    final plafondLabel = TransferPlafondUtils.userPlafondLabel(debitCurrency: _debitCurrency);

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
                      s.wTitle,
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
                  Text(s.wChooseMode, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _ModeButton(
                          icon: LucideIcons.mapPin,
                          label: s.wModeAtm,
                          active: _mode == 'atm',
                          onTap: () => setState(() => _mode = 'atm'),
                        ),
                      ),
                      const SizedBox(width: RawShieldSpacing.md),
                      Expanded(
                        child: _ModeButton(
                          icon: LucideIcons.user,
                          label: s.wModeAgent,
                          active: _mode == 'agent',
                          onTap: () => setState(() => _mode = 'agent'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RawShieldSpacing.xl),
                  if (!_generated) ...[
                    Container(
                      padding: const EdgeInsets.all(RawShieldSpacing.md),
                      decoration: BoxDecoration(
                        color: RawShieldColors.surface,
                        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                        border: Border.all(color: RawShieldColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _CurrencyToggle(
                              label: 'CDF',
                              active: _debitCurrency == CurrencyUtils.cdf,
                              onTap: () => setState(() => _debitCurrency = CurrencyUtils.cdf),
                            ),
                          ),
                          const SizedBox(width: RawShieldSpacing.md),
                          Expanded(
                            child: _CurrencyToggle(
                              label: 'USD',
                              active: _debitCurrency == CurrencyUtils.usd,
                              onTap: () => setState(() => _debitCurrency = CurrencyUtils.usd),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: RawShieldSpacing.lg),
                    Text(s.wAmountToWithdraw, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                    const SizedBox(height: RawShieldSpacing.md),
                    Wrap(
                      spacing: RawShieldSpacing.md,
                      runSpacing: RawShieldSpacing.md,
                      children: [10000, 20000, 50000, 100000, 200000, 500000]
                          .map((cdfAmount) {
                            final isSelected = _selectedAmountCdf == cdfAmount;
                            final label = _debitCurrency == CurrencyUtils.usd
                                ? '${CurrencyUtils.fromCdfTo(CurrencyUtils.usd, cdfAmount).toStringAsFixed(2)} USD'
                                : '$cdfAmount CDF';
                            return _AmountChip(
                              label: label,
                              active: isSelected,
                              onTap: () => setState(() => _selectedAmountCdf = cdfAmount),
                            );
                          })
                          .toList(),
                    ),
                    const SizedBox(height: RawShieldSpacing.lg),
                    if (selectedAmountCdf != null) ...[
                      if (isPlafondExceeded)
                        Container(
                          padding: const EdgeInsets.all(RawShieldSpacing.lg),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 61, 0, 0.10),
                            borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                            border: Border.all(color: RawShieldColors.error),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(LucideIcons.alertTriangle, size: 18, color: RawShieldColors.error),
                              const SizedBox(height: RawShieldSpacing.sm),
                              Text(
                                s.wBannerNotAllowed,
                                style: t.titleMedium?.copyWith(color: RawShieldColors.error),
                              ),
                              const SizedBox(height: RawShieldSpacing.sm),
                              Text(
                                s.wBannerPlafondBody(plafondLabel),
                                style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                              ),
                            ],
                          ),
                        )
                      else if (isPending)
                        Container(
                          padding: const EdgeInsets.all(RawShieldSpacing.lg),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 179, 0, 0.10),
                            borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                            border: Border.all(color: RawShieldColors.warning),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(LucideIcons.alertTriangle, size: 18, color: RawShieldColors.warning),
                              const SizedBox(height: RawShieldSpacing.sm),
                              Text(
                                s.wBannerPendingTitle,
                                style: t.titleMedium?.copyWith(color: RawShieldColors.warning),
                              ),
                              const SizedBox(height: RawShieldSpacing.sm),
                              Text(
                                s.wBannerPendingBody(riskScore),
                                style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                              ),
                            ],
                          ),
                        )
                      else if (isBlocked)
                        Container(
                          padding: const EdgeInsets.all(RawShieldSpacing.lg),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 61, 0, 0.10),
                            borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                            border: Border.all(color: RawShieldColors.error),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(LucideIcons.alertTriangle, size: 18, color: RawShieldColors.error),
                              const SizedBox(height: RawShieldSpacing.sm),
                              Text(
                                s.wBannerBlockedTitle,
                                style: t.titleMedium?.copyWith(color: RawShieldColors.error),
                              ),
                              const SizedBox(height: RawShieldSpacing.sm),
                              Text(
                                s.wBannerBlockedBody(riskScore),
                                style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                    ],
                    const SizedBox(height: RawShieldSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: canGenerate ? _generateCode : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: RawShieldColors.gold,
                          foregroundColor: RawShieldColors.background,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                        ),
                        child: Text(s.wGenerateCode),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: RawShieldSpacing.md),
                      child: Text(
                        _selectedAmountCdf == null
                            ? s.wAmountDash
                            : _debitCurrency == CurrencyUtils.usd
                                ? s.wAmountUsd(CurrencyUtils.fromCdfTo(CurrencyUtils.usd, _selectedAmountCdf!).toStringAsFixed(2))
                                : s.wAmountCdf('$_selectedAmountCdf'),
                        style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(RawShieldSpacing.lg),
                      decoration: BoxDecoration(
                        color: RawShieldColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                        border: Border.all(color: RawShieldColors.border),
                      ),
                      child: Column(
                        children: [
                          Text(s.wWithdrawalCodeLabel, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                          const SizedBox(height: RawShieldSpacing.md),
                          // Évite le débordement horizontal sur petits écrans
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
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
                                        child: Text(
                                          d,
                                          style: t.titleLarge?.copyWith(color: RawShieldColors.text),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: RawShieldSpacing.md),
                          TextButton.icon(
                            onPressed: _copy,
                            icon: Icon(_copied ? LucideIcons.check : LucideIcons.copy, color: _copied ? RawShieldColors.success : RawShieldColors.gold),
                            label: Text(_copied ? s.wCopied : s.wCopyCode, style: t.bodySmall?.copyWith(color: RawShieldColors.gold)),
                          ),
                          const SizedBox(height: RawShieldSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.clock, size: 16, color: _timer < 60 ? RawShieldColors.error : RawShieldColors.warning),
                              const SizedBox(width: RawShieldSpacing.sm),
                              Text(
                                s.wExpiresIn(_formatTime(_timer)),
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
                          Text(s.wInstructions, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                          const SizedBox(height: RawShieldSpacing.md),
                          _Step(number: '1', text: _mode == 'atm' ? s.wStepAtm1 : s.wStepAgent1),
                          _Step(number: '2', text: s.wStep2),
                          _Step(number: '3', text: s.wStep3),
                          _Step(number: '4', text: s.wStep4),
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
                      child: Text(s.wGenerateNewCode),
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
                            s.wNeverShareCode,
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
  const _AmountChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(RawShieldRadii.md),
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - RawShieldSpacing.lg * 2 - RawShieldSpacing.md) / 2,
        padding: const EdgeInsets.symmetric(vertical: RawShieldSpacing.md),
        decoration: BoxDecoration(
          color: active ? const Color.fromRGBO(212, 175, 55, 0.25) : RawShieldColors.surface,
          borderRadius: BorderRadius.circular(RawShieldRadii.md),
          border: Border.all(color: active ? RawShieldColors.gold : RawShieldColors.border),
        ),
        alignment: Alignment.center,
        child: Text(label, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
      ),
    );
  }
}

class _CurrencyToggle extends StatelessWidget {
  const _CurrencyToggle({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(RawShieldRadii.lg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: RawShieldSpacing.md, horizontal: RawShieldSpacing.md),
        decoration: BoxDecoration(
          color: active ? const Color.fromRGBO(212, 175, 55, 0.25) : RawShieldColors.surfaceElevated,
          borderRadius: BorderRadius.circular(RawShieldRadii.lg),
          border: Border.all(color: active ? RawShieldColors.gold : RawShieldColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: t.bodyMedium?.copyWith(
            color: active ? RawShieldColors.gold : RawShieldColors.textSecondary,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
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

