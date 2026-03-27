import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_strings.dart';
import '../../theme/rawshield_theme.dart';

/// Données fictives cohérentes avec un dossier « ouverture de compte » en agence.
class PersonalInfoScreen extends ConsumerWidget {
  const PersonalInfoScreen({super.key});

  static const _fullName = 'Jean Mutombo Kabasele';
  static const _birthDate = '14 mars 1990';
  static const _birthPlace = 'Kinshasa, RDC';
  static const _nationality = 'Congolaise (RDC)';
  static const _idType = 'Carte d’électeur / passeport';
  static const _idNumber = 'CD-PAS-90-14-XXXXX';
  static const _address = 'Avenue du Commerce 120, Gombe, Kinshasa';
  static const _phone = '+243 81 234 5678';
  static const _email = 'jean.mutombo@email.cd';
  static const _profession = 'Ingénieur logiciel';
  static const _employer = 'Tech Solutions SARL';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
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
                      s.personalInfoTitle,
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
                padding: const EdgeInsets.fromLTRB(
                  RawShieldSpacing.lg,
                  0,
                  RawShieldSpacing.lg,
                  RawShieldSpacing.xxl,
                ),
                children: [
                  Text(
                    s.piBankNote,
                    style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary, height: 1.45),
                  ),
                  const SizedBox(height: RawShieldSpacing.lg),
                  _InfoCard(
                    children: [
                      _InfoRow(label: s.piFullName, value: _fullName, icon: LucideIcons.user),
                      _InfoRow(label: s.piBirthDate, value: _birthDate, icon: LucideIcons.calendar),
                      _InfoRow(label: s.piBirthPlace, value: _birthPlace, icon: LucideIcons.mapPin),
                      _InfoRow(label: s.piNationality, value: _nationality, icon: LucideIcons.flag),
                      _InfoRow(label: s.piIdType, value: _idType, icon: LucideIcons.creditCard),
                      _InfoRow(label: s.piIdNumber, value: _idNumber, icon: LucideIcons.fileText),
                      _InfoRow(label: s.piAddress, value: _address, icon: LucideIcons.home),
                      _InfoRow(label: s.piPhone, value: _phone, icon: LucideIcons.phone),
                      _InfoRow(label: s.piEmail, value: _email, icon: LucideIcons.mail),
                      _InfoRow(label: s.piProfession, value: _profession, icon: LucideIcons.briefcase),
                      _InfoRow(label: s.piEmployer, value: _employer, icon: LucideIcons.building),
                    ],
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RawShieldSpacing.md),
      decoration: BoxDecoration(
        color: RawShieldColors.surface,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        border: Border.all(color: RawShieldColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: RawShieldSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: RawShieldColors.gold),
          const SizedBox(width: RawShieldSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
