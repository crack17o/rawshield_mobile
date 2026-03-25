import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/routes.dart';
import '../../theme/rawshield_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showBalance = true;
  bool _refreshing = false;

  Future<void> _onRefresh() async {
    setState(() => _refreshing = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _refreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: RawShieldColors.gold,
          onRefresh: _onRefresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              RawShieldSpacing.lg,
              RawShieldSpacing.xxl,
              RawShieldSpacing.lg,
              RawShieldSpacing.lg,
            ),
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: RawShieldColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(RawShieldRadii.full),
                          border: Border.all(color: RawShieldColors.borderGold),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(LucideIcons.user, color: RawShieldColors.gold),
                      ),
                      const SizedBox(width: RawShieldSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bonjour,', style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                          Text('Jean', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.push(AppRoutes.notifications),
                    borderRadius: BorderRadius.circular(RawShieldRadii.full),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: RawShieldColors.surface,
                        borderRadius: BorderRadius.circular(RawShieldRadii.full),
                      ),
                      child: Stack(
                        children: [
                          const Center(child: Icon(LucideIcons.bell, color: RawShieldColors.text)),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: RawShieldColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RawShieldSpacing.lg),

              // Balance card
              Container(
                padding: const EdgeInsets.all(RawShieldSpacing.lg),
                decoration: BoxDecoration(
                  color: RawShieldColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(RawShieldRadii.xl),
                  border: Border.all(color: RawShieldColors.border),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.sm, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(212, 175, 55, 0.20),
                            borderRadius: BorderRadius.circular(RawShieldRadii.sm),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.shield, size: 14, color: RawShieldColors.gold),
                              const SizedBox(width: RawShieldSpacing.xs),
                              Text('RAWShield AI Actif', style: t.labelSmall?.copyWith(color: RawShieldColors.gold)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _showBalance = !_showBalance),
                          icon: Icon(_showBalance ? LucideIcons.eyeOff : LucideIcons.eye, color: RawShieldColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: RawShieldSpacing.md),
                    Text('Solde disponible', style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                    const SizedBox(height: RawShieldSpacing.xs),
                    Text(
                      _showBalance ? '2 457 800 CDF' : '•••••••',
                      style: t.headlineLarge?.copyWith(color: RawShieldColors.text),
                    ),
                    const SizedBox(height: RawShieldSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('**** **** **** 4521', style: t.bodyLarge?.copyWith(color: RawShieldColors.textSecondary, letterSpacing: 2)),
                        Text('Expire 12/27', style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: RawShieldSpacing.md),
                    Container(height: 3, color: RawShieldColors.gold),
                  ],
                ),
              ),

              const SizedBox(height: RawShieldSpacing.lg),

              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ActionButton(
                    icon: LucideIcons.send,
                    label: 'Envoyer',
                    bg: const Color.fromRGBO(212, 175, 55, 0.30),
                    fg: RawShieldColors.background,
                    onTap: () => context.push(AppRoutes.transfer),
                  ),
                  _ActionButton(
                    icon: LucideIcons.download,
                    label: 'Retirer',
                    bg: const Color.fromRGBO(0, 200, 83, 0.15),
                    fg: RawShieldColors.success,
                    onTap: () => context.push(AppRoutes.withdrawal),
                  ),
                  _ActionButton(
                    icon: LucideIcons.receipt,
                    label: 'Factures',
                    bg: const Color.fromRGBO(33, 150, 243, 0.15),
                    fg: RawShieldColors.info,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: RawShieldSpacing.xl),

              // Placeholder sections
              Text('Contacts fréquents', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
              const SizedBox(height: RawShieldSpacing.md),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(width: RawShieldSpacing.md),
                  itemBuilder: (_, i) => Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: RawShieldColors.surfaceElevated,
                          shape: BoxShape.circle,
                          border: Border.all(color: RawShieldColors.border),
                        ),
                        alignment: Alignment.center,
                        child: Text('M', style: t.titleLarge?.copyWith(color: RawShieldColors.gold)),
                      ),
                      const SizedBox(height: RawShieldSpacing.xs),
                      Text('Marie', style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: RawShieldSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transactions récentes', style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                  TextButton(
                    onPressed: () {},
                    child: Text('Voir tout', style: t.bodySmall?.copyWith(color: RawShieldColors.gold)),
                  ),
                ],
              ),
              const SizedBox(height: RawShieldSpacing.md),
              Container(
                decoration: BoxDecoration(
                  color: RawShieldColors.surface,
                  borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                  border: Border.all(color: RawShieldColors.border),
                ),
                child: Column(
                  children: const [
                    _TxnRow(title: 'Marie Kabongo', subtitle: 'Transfert amical', amount: '-50 000 CDF', isIn: false),
                    Divider(height: 1, color: RawShieldColors.border),
                    _TxnRow(title: 'Vous', subtitle: 'Paiement facture #1234', amount: '+150 000 CDF', isIn: true),
                    Divider(height: 1, color: RawShieldColors.border),
                    _TxnRow(title: 'Retrait ATM', subtitle: 'Gare Centrale', amount: '-100 000 CDF', isIn: false),
                  ],
                ),
              ),

              if (_refreshing) const SizedBox(height: 0), // keep analyzer calm
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RawShieldRadii.lg),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(RawShieldRadii.lg),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: fg, size: 26),
          ),
          const SizedBox(height: RawShieldSpacing.sm),
          Text(label, style: t.bodySmall?.copyWith(color: RawShieldColors.text)),
        ],
      ),
    );
  }
}

class _TxnRow extends StatelessWidget {
  const _TxnRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIn,
  });

  final String title;
  final String subtitle;
  final String amount;
  final bool isIn;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.md, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isIn ? const Color.fromRGBO(0, 200, 83, 0.15) : RawShieldColors.surfaceLight,
          borderRadius: BorderRadius.circular(RawShieldRadii.md),
        ),
        alignment: Alignment.center,
        child: Icon(isIn ? LucideIcons.download : LucideIcons.send, color: isIn ? RawShieldColors.success : RawShieldColors.text),
      ),
      title: Text(title, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
      subtitle: Text(subtitle, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
      trailing: Text(amount, style: t.bodyMedium?.copyWith(color: isIn ? RawShieldColors.success : RawShieldColors.text)),
    );
  }
}

