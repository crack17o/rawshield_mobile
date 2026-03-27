import 'package:flutter/material.dart';

import '../../auth/biometric_auth.dart';
import '../../l10n/app_strings.dart';
import '../../services/app_prefs.dart';
import '../../theme/rawshield_theme.dart';

/// Demande une validation OTP (simulé) ou biométrique si autorisé.
Future<bool> verifyIdentityForSensitiveAction(
  BuildContext context, {
  required AppStrings strings,
  required String title,
  required String message,
}) async {
  final biometricPref = await AppPrefs.isBiometricEnabled();
  final biometricDevice = await BiometricAuth().canCheck();
  final canBiometric = biometricPref && biometricDevice;

  if (!context.mounted) return false;

  final choice = await showModalBottomSheet<_IdentityChoice>(
    context: context,
    backgroundColor: RawShieldColors.surfaceElevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(RawShieldRadii.lg)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RawShieldSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: RawShieldColors.text)),
              const SizedBox(height: RawShieldSpacing.sm),
              Text(message, style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: RawShieldColors.textSecondary)),
              const SizedBox(height: RawShieldSpacing.lg),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(_IdentityChoice.otp),
                style: FilledButton.styleFrom(
                  backgroundColor: RawShieldColors.gold,
                  foregroundColor: RawShieldColors.background,
                ),
                child: Text(strings.idValidateOtp),
              ),
              if (canBiometric) ...[
                const SizedBox(height: RawShieldSpacing.sm),
                OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(_IdentityChoice.biometric),
                  child: Text(strings.idValidateBio),
                ),
              ],
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(strings.commonCancel),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (choice == null || !context.mounted) return false;

  if (choice == _IdentityChoice.biometric) {
    final ok = await BiometricAuth().authenticate();
    return ok;
  }

  // OTP simulé
  final codeController = TextEditingController();
  var codeSent = false;
  final okOtp = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setLocal) {
          return AlertDialog(
            backgroundColor: RawShieldColors.surfaceElevated,
            title: Text(strings.idOtpDialogTitle, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: RawShieldColors.text)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  strings.idOtpDialogHint,
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                ),
                const SizedBox(height: RawShieldSpacing.md),
                if (!codeSent)
                  FilledButton(
                    onPressed: () => setLocal(() => codeSent = true),
                    style: FilledButton.styleFrom(
                      backgroundColor: RawShieldColors.gold,
                      foregroundColor: RawShieldColors.background,
                    ),
                    child: Text(strings.idSendCode),
                  )
                else ...[
                  TextField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: strings.idOtpFieldHint,
                      counterText: '',
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(strings.commonCancel)),
              if (codeSent)
                FilledButton(
                  onPressed: () {
                    final entered = codeController.text.replaceAll(RegExp(r'[^0-9]'), '');
                    Navigator.of(ctx).pop(entered == AppPrefs.demoOtpCode);
                  },
                  child: Text(strings.idValidate),
                ),
            ],
          );
        },
      );
    },
  );
  codeController.dispose();
  return okOtp == true;
}

enum _IdentityChoice { otp, biometric }
