import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_strings.dart';
import '../../l10n/locale_provider.dart';
import '../../services/app_prefs.dart';
import '../../theme/rawshield_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _push = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await AppPrefs.getPushNotificationsEnabled();
    if (!mounted) return;
    setState(() {
      _push = v;
      _loading = false;
    });
  }

  Future<void> _setPush(bool v) async {
    await AppPrefs.setPushNotificationsEnabled(v);
    if (!mounted) return;
    setState(() => _push = v);
  }

  Future<void> _onLanguageSelected(String code) async {
    await ref.read(localeProvider.notifier).setLocale(Locale(code));
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appStringsProvider);
    final current = ref.watch(localeProvider).languageCode;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: RawShieldColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                RawShieldSpacing.sm,
                RawShieldSpacing.sm,
                RawShieldSpacing.lg,
                RawShieldSpacing.md,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: RawShieldColors.text),
                  ),
                  Expanded(
                    child: Text(
                      s.settingsTitle,
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
                  if (_loading)
                    const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                  else
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(LucideIcons.bell, color: RawShieldColors.gold),
                      title: Text(s.pushNotifications, style: t.bodyLarge?.copyWith(color: RawShieldColors.text)),
                      subtitle: Text(s.pushNotificationsSub, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                      value: _push,
                      activeThumbColor: RawShieldColors.gold,
                      onChanged: _setPush,
                    ),
                  const SizedBox(height: RawShieldSpacing.lg),
                  Text(s.languageTitle, style: t.titleSmall?.copyWith(color: RawShieldColors.text)),
                  const SizedBox(height: RawShieldSpacing.sm),
                  _LanguageTile(
                    label: s.languageFr,
                    selected: current == 'fr',
                    onTap: () => _onLanguageSelected('fr'),
                  ),
                  _LanguageTile(
                    label: s.languageEn,
                    selected: current == 'en',
                    onTap: () => _onLanguageSelected('en'),
                  ),
                  _LanguageTile(
                    label: s.languageLn,
                    selected: current == 'ln',
                    onTap: () => _onLanguageSelected('ln'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
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
              border: Border.all(color: selected ? RawShieldColors.borderGold : RawShieldColors.border),
            ),
            child: Row(
              children: [
                Expanded(child: Text(label, style: t.bodyMedium?.copyWith(color: RawShieldColors.text))),
                if (selected) const Icon(LucideIcons.check, color: RawShieldColors.gold, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
