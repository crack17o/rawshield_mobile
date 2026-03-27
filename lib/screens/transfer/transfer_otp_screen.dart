import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_strings.dart';
import '../../theme/rawshield_theme.dart';
import '../../auth/biometric_auth.dart';
import '../../services/app_prefs.dart';
import 'transfer_state.dart';
import 'transfer_risk_utils.dart';
import 'transfer_plafond_utils.dart';

class TransferOtpScreen extends ConsumerStatefulWidget {
  const TransferOtpScreen({super.key});

  @override
  ConsumerState<TransferOtpScreen> createState() => _TransferOtpScreenState();
}

class _TransferOtpScreenState extends ConsumerState<TransferOtpScreen> {
  final _controller = TextEditingController();
  final _biometricAuth = BiometricAuth();

  String _method = 'otp'; // 'otp' | 'biometric'
  bool _biometricAvailable = false;
  bool _biometricPrefEnabled = true;
  bool _biometricInProgress = false;
  bool _codeSent = false;
  bool _sendingCode = false;
  bool _processingHighRisk = false;

  @override
  void initState() {
    super.initState();
    _initBiometricAvailability();
  }

  Future<void> _initBiometricAvailability() async {
    final ok = await _biometricAuth.canCheck();
    final pref = await AppPrefs.isBiometricEnabled();
    if (!mounted) return;
    setState(() {
      _biometricAvailable = ok;
      _biometricPrefEnabled = pref;
      if (!(ok && pref) && _method == 'biometric') {
        _method = 'otp';
      }
    });
  }

  bool get _biometricUsable => _biometricAvailable && _biometricPrefEnabled;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _valid => _controller.text.replaceAll(RegExp(r'[^0-9]'), '').length >= 6;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    final draft = ref.watch(transferDraftProvider);

    final riskScore = TransferRiskUtils.computeRiskScore(amountCdf: draft.amountCdf);
    final riskLevel = TransferRiskUtils.getRiskLevel(riskScore);

    // OTP requis lorsque le risque est moyen ou élevé.
    final requiresOtp = riskLevel == TransferRiskLevel.medium || riskLevel == TransferRiskLevel.high;
    final isBlocked = riskLevel == TransferRiskLevel.veryHigh;
    final isPending = riskLevel == TransferRiskLevel.high;
    final isLow = riskLevel == TransferRiskLevel.low;

    final amountCdf = draft.amountCdf ?? 0;
    final debitCurrency = draft.debitCurrency;
    final userPlafondCdf = TransferPlafondUtils.userPlafondCdf(debitCurrency: debitCurrency);
    final isPlafondExceeded = amountCdf > userPlafondCdf;

    final isOtp = _method == 'otp';
    final canConfirmBase = isPlafondExceeded
        ? false
        : isBlocked
            ? false
            : isLow
                ? _valid // PIN uniquement (risque faible)
                : (isOtp
                    ? (_valid && (!requiresOtp || _codeSent)) // OTP + code envoyé
                    : (_biometricUsable && !_biometricInProgress)); // biométrie

    final canConfirm = canConfirmBase && !_processingHighRisk;

    final plafondLabel = TransferPlafondUtils.userPlafondLabel(debitCurrency: debitCurrency);
    final stepPart = isPlafondExceeded
        ? s.tfStepPlafond
        : isBlocked
            ? s.tfStepBlocage
            : isPending
                ? s.tfStepPending
                : isLow
                    ? s.tfStepPin
                    : s.tfStepVerify;

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
                    s.transferVerification,
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
                Text(
                  s.tfStepLabel(stepPart),
                  style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: RawShieldSpacing.lg),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
              children: [
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
                        Row(
                          children: [
                            const Icon(LucideIcons.alertTriangle, size: 18, color: RawShieldColors.error),
                            const SizedBox(width: RawShieldSpacing.sm),
                            Text(
                              s.tfTxNotAllowed,
                              style: t.titleMedium?.copyWith(color: RawShieldColors.error),
                            ),
                          ],
                        ),
                        const SizedBox(height: RawShieldSpacing.sm),
                        Text(
                          s.tfPlafondBody(plafondLabel),
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
                        Row(
                          children: [
                            const Icon(LucideIcons.alertTriangle, size: 18, color: RawShieldColors.error),
                            const SizedBox(width: RawShieldSpacing.sm),
                            Text(
                              s.secAlert1Title,
                              style: t.titleMedium?.copyWith(color: RawShieldColors.error),
                            ),
                          ],
                        ),
                        const SizedBox(height: RawShieldSpacing.sm),
                        Text(
                          s.tfBlockedBody(riskScore),
                          style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                if (!isPlafondExceeded &&
                    !isBlocked &&
                    (riskLevel == TransferRiskLevel.medium || riskLevel == TransferRiskLevel.high))
                  // Choix de la méthode de vérification
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
                          child: _MethodButton(
                            label: s.tfLabelOtp,
                            active: _method == 'otp',
                            onTap: () => setState(() => _method = 'otp'),
                          ),
                        ),
                        const SizedBox(width: RawShieldSpacing.md),
                        Expanded(
                          child: _MethodButton(
                            label: s.tfLabelBio,
                            active: _method == 'biometric',
                            disabled: !_biometricUsable,
                            onTap: !_biometricUsable
                                ? null
                                : () => setState(() => _method = 'biometric'),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: RawShieldSpacing.md),

                if (!isPlafondExceeded && riskLevel == TransferRiskLevel.high)
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
                        Row(
                          children: [
                            const Icon(LucideIcons.alertTriangle, size: 18, color: RawShieldColors.warning),
                            const SizedBox(width: RawShieldSpacing.sm),
                            Text(
                              s.tfPendingTitle,
                              style: t.titleMedium?.copyWith(color: RawShieldColors.warning),
                            ),
                          ],
                        ),
                        const SizedBox(height: RawShieldSpacing.sm),
                        Text(
                          s.tfPendingBody(riskScore),
                          style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                if (!isPlafondExceeded && !isBlocked)
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
                      if (riskLevel == TransferRiskLevel.low) ...[
                        Text(s.secPinLabel, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                        const SizedBox(height: RawShieldSpacing.xs),
                        Text(
                          s.tfPinOnly,
                          style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                        ),
                        const SizedBox(height: RawShieldSpacing.sm),
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: s.tfPinHint,
                            prefixIcon: Icon(LucideIcons.keyRound, color: RawShieldColors.textSecondary),
                          ),
                          style: const TextStyle(color: RawShieldColors.text, letterSpacing: 4),
                          maxLength: 6,
                        ),
                        const SizedBox(height: RawShieldSpacing.md),
                      ] else if (isOtp) ...[
                        if (riskLevel == TransferRiskLevel.low) ...[
                          Text(s.secPinLabel, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                          const SizedBox(height: RawShieldSpacing.xs),
                          Text(
                            s.tfPinOnly,
                            style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                          ),
                        ] else ...[
                          Text(s.tfVerifyCodeTitle, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                          const SizedBox(height: RawShieldSpacing.xs),
                          Text(
                            s.tfVerifyCodeSub,
                            style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                          ),
                        ],
                        const SizedBox(height: RawShieldSpacing.md),

                        if (requiresOtp) ...[
                          // d'abord "Envoyer le code"
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: _sendingCode
                                  ? null
                                  : () async {
                                      setState(() => _sendingCode = true);
                                      // Simulation en attente d'envoi
                                    final messenger = ScaffoldMessenger.of(context);
                                      await Future<void>.delayed(const Duration(milliseconds: 800));
                                      if (!mounted) return;
                                      setState(() {
                                        _codeSent = true;
                                        _sendingCode = false;
                                      });
                                    messenger.showSnackBar(
                                        SnackBar(content: Text(s.tfSnackSentSms)),
                                      );
                                    },
                              style: FilledButton.styleFrom(
                                backgroundColor: RawShieldColors.gold,
                                foregroundColor: RawShieldColors.background,
                              ),
                              child: _sendingCode
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: RawShieldColors.background),
                                    )
                                  : Text(s.tfSendCode),
                            ),
                          ),
                          const SizedBox(height: RawShieldSpacing.md),
                          if (_codeSent)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(s.tfResendMailSnack)),
                                  );
                                },
                                child: Text(
                                  s.tfResendMail,
                                  style: t.bodySmall?.copyWith(color: RawShieldColors.gold),
                                ),
                              ),
                            ),
                          if (!_codeSent) ...[
                            const SizedBox(height: RawShieldSpacing.sm),
                            Text(
                              s.tfTapSendFirst,
                              style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                            ),
                          ],
                          const SizedBox(height: RawShieldSpacing.md),
                        ],

                        const SizedBox(height: RawShieldSpacing.xs),
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
                          enabled: !requiresOtp || _codeSent,
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
                                  s.tfNeverShare(draft.recipientName ?? '—'),
                                  style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Text(
                          s.tfBioTitle,
                          style: t.titleMedium?.copyWith(color: RawShieldColors.text),
                        ),
                        const SizedBox(height: RawShieldSpacing.xs),
                        Text(
                          s.tfBioSub,
                          style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                        ),
                        const SizedBox(height: RawShieldSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(RawShieldSpacing.md),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 200, 83, 0.10),
                            borderRadius: BorderRadius.circular(RawShieldRadii.md),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.shield, size: 16, color: RawShieldColors.success),
                              const SizedBox(width: RawShieldSpacing.sm),
                              Expanded(
                                child: Text(
                                  s.tfRecipientLine(draft.recipientName ?? '—'),
                                  style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                onPressed: canConfirm
                    ? () async {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);

                        if (_method == 'otp') {
                          if (isLow) {
                            final expected = await AppPrefs.getTransactionPin();
                            final entered = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
                            if (entered != expected) {
                              messenger.showSnackBar(
                                SnackBar(content: Text(s.tfPinWrongSnack)),
                              );
                              return;
                            }
                          }
                          if (riskLevel == TransferRiskLevel.high) {
                            setState(() => _processingHighRisk = true);
                            await Future<void>.delayed(const Duration(seconds: 2));
                            if (!mounted) return;
                            setState(() => _processingHighRisk = false);
                            messenger.showSnackBar(
                              SnackBar(content: Text(s.tfSnackAdminOtp)),
                            );
                          }
                          navigator.pushNamed('/result');
                          return;
                        }
                        setState(() => _biometricInProgress = true);
                        final ok = await _biometricAuth.authenticate();
                        if (!mounted) return;
                        setState(() => _biometricInProgress = false);

                        if (!ok) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(s.tfSnackBioDenied)),
                          );
                          return;
                        }
                        if (riskLevel == TransferRiskLevel.high) {
                          setState(() => _processingHighRisk = true);
                          await Future<void>.delayed(const Duration(seconds: 2));
                          if (!mounted) return;
                          setState(() => _processingHighRisk = false);
                          messenger.showSnackBar(
                            SnackBar(content: Text(s.tfSnackAdminBio)),
                          );
                        }
                        navigator.pushNamed('/result');
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: RawShieldColors.gold,
                  foregroundColor: RawShieldColors.background,
                  disabledBackgroundColor: const Color.fromRGBO(212, 175, 55, 0.25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                ),
                child: Text(s.tfConfirm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodButton extends StatelessWidget {
  const _MethodButton({
    required this.label,
    required this.active,
    this.disabled = false,
    this.onTap,
  });

  final String label;
  final bool active;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(RawShieldRadii.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: RawShieldSpacing.md, horizontal: RawShieldSpacing.md),
        decoration: BoxDecoration(
          color: active
              ? const Color.fromRGBO(212, 175, 55, 0.25)
              : RawShieldColors.surfaceElevated,
          borderRadius: BorderRadius.circular(RawShieldRadii.lg),
          border: Border.all(
            color: active ? RawShieldColors.gold : RawShieldColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: t.bodyMedium?.copyWith(
            color: disabled
                ? RawShieldColors.textMuted
                : (active ? RawShieldColors.gold : RawShieldColors.textSecondary),
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

