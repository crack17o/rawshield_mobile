import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../security/security_identity_sheet.dart';
import '../../l10n/app_strings.dart';
import '../../l10n/language_globe_button.dart';
import '../../services/app_prefs.dart';
import '../../theme/rawshield_theme.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  bool _biometricEnabled = true;
  bool _loadingPrefs = true;

  List<_SecurityAlert> _alerts(AppStrings s) => [
        _SecurityAlert(
          icon: LucideIcons.alertTriangle,
          color: RawShieldColors.error,
          bg: const Color.fromRGBO(255, 61, 0, 0.15),
          title: s.secAlert1Title,
          subtitle: s.secAlert1Sub,
          time: s.secAlert1Time,
          detail: s.secAlert1Detail,
        ),
        _SecurityAlert(
          icon: LucideIcons.alertTriangle,
          color: RawShieldColors.warning,
          bg: const Color.fromRGBO(255, 179, 0, 0.15),
          title: s.secAlert2Title,
          subtitle: s.secAlert2Sub,
          time: s.secAlert2Time,
          detail: s.secAlert2Detail,
        ),
        _SecurityAlert(
          icon: LucideIcons.shieldCheck,
          color: RawShieldColors.success,
          bg: const Color.fromRGBO(0, 200, 83, 0.15),
          title: s.secAlert3Title,
          subtitle: s.secAlert3Sub,
          time: s.secAlert3Time,
          detail: s.secAlert3Detail,
        ),
      ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bio = await AppPrefs.isBiometricEnabled();
    if (!mounted) return;
    setState(() {
      _biometricEnabled = bio;
      _loadingPrefs = false;
    });
  }

  Future<void> _setBiometric(bool value) async {
    await AppPrefs.setBiometricEnabled(value);
    if (!mounted) return;
    setState(() => _biometricEnabled = value);
  }

  void _showRawShieldRole(AppStrings s) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RawShieldColors.surfaceElevated,
        title: Text(s.secRawTitle, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: RawShieldColors.text)),
        content: SingleChildScrollView(
          child: Text(
            s.secRawDialogBody,
            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: RawShieldColors.textSecondary, height: 1.45),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: RawShieldColors.gold,
              foregroundColor: RawShieldColors.background,
            ),
            child: Text(s.commonUnderstood),
          ),
        ],
      ),
    );
  }

  Future<void> _openChangePassword(AppStrings s) async {
    final ok = await verifyIdentityForSensitiveAction(
      context,
      strings: s,
      title: s.secChangePasswordTitle,
      message: s.secChangePasswordMsg,
    );
    if (!ok || !mounted) return;

    final newPass = TextEditingController();
    final confirm = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: RawShieldColors.surfaceElevated,
          title: Text(s.secNewPassword, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: RawShieldColors.text)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPass,
                obscureText: true,
                decoration: InputDecoration(labelText: s.secNewPassword),
              ),
              const SizedBox(height: RawShieldSpacing.sm),
              TextField(
                controller: confirm,
                obscureText: true,
                decoration: InputDecoration(labelText: s.secConfirmPassword),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(s.commonCancel)),
            FilledButton(
              onPressed: () {
                if (newPass.text.length < 6 || newPass.text != confirm.text) return;
                Navigator.of(ctx).pop(true);
              },
              child: Text(s.commonSave),
            ),
          ],
        );
      },
    );
    newPass.dispose();
    confirm.dispose();

    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.secPasswordUpdated)),
      );
    }
  }

  Future<void> _openChangePin(AppStrings s) async {
    final ok = await verifyIdentityForSensitiveAction(
      context,
      strings: s,
      title: s.secPinFlowTitle,
      message: s.secPinFlowMsg,
    );
    if (!ok || !mounted) return;

    final pin = TextEditingController();
    final pin2 = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: RawShieldColors.surfaceElevated,
          title: Text(s.secNewPinTitle, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: RawShieldColors.text)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pin,
                keyboardType: TextInputType.number,
                maxLength: 6,
                obscureText: true,
                decoration: InputDecoration(labelText: s.secPinLabel, counterText: ''),
              ),
              const SizedBox(height: RawShieldSpacing.sm),
              TextField(
                controller: pin2,
                keyboardType: TextInputType.number,
                maxLength: 6,
                obscureText: true,
                decoration: InputDecoration(labelText: s.secConfirmPassword, counterText: ''),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(s.commonCancel)),
            FilledButton(
              onPressed: () async {
                final a = pin.text.replaceAll(RegExp(r'[^0-9]'), '');
                final b = pin2.text.replaceAll(RegExp(r'[^0-9]'), '');
                if (a.length != 6 || a != b) return;
                await AppPrefs.setTransactionPin(a);
                if (ctx.mounted) Navigator.of(ctx).pop(true);
              },
              child: Text(s.commonSave),
            ),
          ],
        );
      },
    );
    pin.dispose();
    pin2.dispose();

    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.secPinSaved)),
      );
    }
  }

  void _showAlertDetail(_SecurityAlert a) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: RawShieldColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RawShieldRadii.lg)),
      ),
      builder: (ctx) {
        final t = Theme.of(ctx).textTheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(RawShieldSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(a.icon, color: a.color, size: 22),
                      const SizedBox(width: RawShieldSpacing.sm),
                      Expanded(
                        child: Text(a.title, style: t.titleLarge?.copyWith(color: RawShieldColors.text)),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close, color: RawShieldColors.textMuted),
                        tooltip: 'Fermer',
                      ),
                    ],
                  ),
                  const SizedBox(height: RawShieldSpacing.xs),
                  Text(a.time, style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
                  const SizedBox(height: RawShieldSpacing.md),
                  Text(a.subtitle, style: t.bodyMedium?.copyWith(color: RawShieldColors.textSecondary)),
                  const SizedBox(height: RawShieldSpacing.md),
                  Text(a.detail, style: t.bodyMedium?.copyWith(color: RawShieldColors.text, height: 1.45)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    final alerts = _alerts(s);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            RawShieldSpacing.lg,
            RawShieldSpacing.xxl,
            RawShieldSpacing.lg,
            RawShieldSpacing.lg,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(s.secTitle, style: t.headlineMedium?.copyWith(color: RawShieldColors.text)),
                ),
                const LanguageGlobeButton(),
              ],
            ),
            const SizedBox(height: RawShieldSpacing.lg),

            Container(
              padding: const EdgeInsets.all(RawShieldSpacing.lg),
              decoration: BoxDecoration(
                color: RawShieldColors.surfaceElevated,
                borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                border: Border.all(color: RawShieldColors.borderGold),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(212, 175, 55, 0.25),
                      borderRadius: BorderRadius.circular(RawShieldRadii.full),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(LucideIcons.shieldCheck, size: 40, color: RawShieldColors.gold),
                  ),
                  const SizedBox(width: RawShieldSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.secLevelLabel, style: t.bodyLarge?.copyWith(color: RawShieldColors.textSecondary)),
                        const SizedBox(height: RawShieldSpacing.xs),
                        Text(s.secLevelHigh, style: t.headlineMedium?.copyWith(color: RawShieldColors.gold)),
                        const SizedBox(height: RawShieldSpacing.xs),
                        Text(
                          s.secLevelSub,
                          style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted),
                        ),
                      ],
                    ),
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
                  Text(s.secTrustTitle, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RawShieldRadii.full),
                    child: Container(
                      height: 8,
                      color: RawShieldColors.surfaceLight,
                      child: const FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.92,
                        child: ColoredBox(color: RawShieldColors.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: RawShieldSpacing.sm),
                  Text(s.secTrustValue, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                ],
              ),
            ),

            const SizedBox(height: RawShieldSpacing.lg),

            Text(s.secFeaturesTitle, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
            const SizedBox(height: RawShieldSpacing.md),

            _TappableFeatureRow(
              icon: LucideIcons.shieldCheck,
              title: s.secRawTitle,
              subtitle: s.secRawSub,
              onTap: () => _showRawShieldRole(s),
            ),

            _BiometricRow(
              loading: _loadingPrefs,
              enabled: _biometricEnabled,
              onChanged: _setBiometric,
              strings: s,
            ),

            _TappableFeatureRow(
              icon: LucideIcons.keyRound,
              title: s.secPinTitle,
              subtitle: s.secPinSub,
              onTap: () => _openChangePin(s),
            ),

            _TappableFeatureRow(
              icon: LucideIcons.key,
              title: s.secPasswordTitle,
              subtitle: s.secPasswordSub,
              onTap: () => _openChangePassword(s),
            ),

            const SizedBox(height: RawShieldSpacing.lg),
            Text(s.secAlertsTitle, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
            const SizedBox(height: RawShieldSpacing.md),
            ...alerts.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
                child: _AlertTile(alert: a, onTap: () => _showAlertDetail(a)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityAlert {
  const _SecurityAlert({
    required this.icon,
    required this.color,
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.detail,
  });

  final IconData icon;
  final Color color;
  final Color bg;
  final String title;
  final String subtitle;
  final String time;
  final String detail;
}

class _TappableFeatureRow extends StatelessWidget {
  const _TappableFeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      child: Material(
        color: RawShieldColors.surface,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RawShieldRadii.lg),
          child: Container(
            padding: const EdgeInsets.all(RawShieldSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RawShieldRadii.lg),
              border: Border.all(color: RawShieldColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(212, 175, 55, 0.12),
                    borderRadius: BorderRadius.circular(RawShieldRadii.md),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: RawShieldColors.gold, size: 22),
                ),
                const SizedBox(width: RawShieldSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, color: RawShieldColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BiometricRow extends StatelessWidget {
  const _BiometricRow({
    required this.loading,
    required this.enabled,
    required this.onChanged,
    required this.strings,
  });

  final bool loading;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: RawShieldSpacing.sm),
      child: Container(
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
                color: (enabled ? RawShieldColors.success : RawShieldColors.textMuted).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(RawShieldRadii.md),
              ),
              alignment: Alignment.center,
              child: Icon(LucideIcons.fingerprint, color: enabled ? RawShieldColors.success : RawShieldColors.textMuted, size: 22),
            ),
            const SizedBox(width: RawShieldSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.secBioTitle, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: 2),
                  Text(
                    enabled ? strings.secBioOnSub : strings.secBioOffSub,
                    style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (loading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Switch(
                value: enabled,
                onChanged: onChanged,
                activeThumbColor: RawShieldColors.gold,
              ),
          ],
        ),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert, required this.onTap});

  final _SecurityAlert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final a = alert;
    final borderColor = a.color.withValues(alpha: 0.35);
    return Material(
      color: RawShieldColors.surfaceElevated,
      borderRadius: BorderRadius.circular(RawShieldRadii.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        child: Container(
          padding: const EdgeInsets.all(RawShieldSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RawShieldRadii.lg),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: a.bg,
                  borderRadius: BorderRadius.circular(RawShieldRadii.md),
                ),
                alignment: Alignment.center,
                child: Icon(a.icon, color: a.color, size: 20),
              ),
              const SizedBox(width: RawShieldSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.title, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                    const SizedBox(height: 2),
                    Text(a.subtitle, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(a.time, style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: RawShieldColors.textMuted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
