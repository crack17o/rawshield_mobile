import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/routes.dart';
import '../../l10n/app_strings.dart';
import '../../theme/rawshield_theme.dart';
import '../transfer/transfer_prefill.dart';
import '../transactions/transaction_details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showBalance = true;
  bool _refreshing = false;
  int _activeBalanceCard = 0;
  final PageController _balanceCardsController = PageController(viewportFraction: 0.92);

  Future<void> _onRefresh() async {
    setState(() => _refreshing = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _refreshing = false);
  }

  @override
  void dispose() {
    _balanceCardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    final recent = _recentHomeTransactions(s);
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
                          Text(s.homeHello, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                          Text(s.homeUserName, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
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

              // Balance cards carousel
              SizedBox(
                height: 248,
                child: PageView.builder(
                  controller: _balanceCardsController,
                  padEnds: false,
                  itemCount: _balanceCards.length,
                  onPageChanged: (index) => setState(() => _activeBalanceCard = index),
                  itemBuilder: (context, index) {
                    final card = _balanceCards[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == _balanceCards.length - 1 ? 0 : RawShieldSpacing.md,
                      ),
                      child: Container(
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
                                      Text(
                                        s.accountLabel(card.currency),
                                        style: t.labelSmall?.copyWith(color: RawShieldColors.gold),
                                      ),
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
                            Text(s.homeAvailableBalance, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                            const SizedBox(height: RawShieldSpacing.xs),
                            Text(
                              _showBalance ? card.balance : '•••••••',
                              style: t.headlineLarge?.copyWith(color: RawShieldColors.text),
                            ),
                            const SizedBox(height: RawShieldSpacing.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    card.maskedNumber,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyLarge?.copyWith(
                                      color: RawShieldColors.textSecondary,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: RawShieldSpacing.sm),
                                Text(
                                  'Expire 12/27',
                                  style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: RawShieldSpacing.md),
                            Container(height: 3, color: RawShieldColors.gold),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: RawShieldSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _balanceCards.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _activeBalanceCard == index
                          ? RawShieldColors.gold
                          : RawShieldColors.textMuted.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: RawShieldSpacing.lg),

              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ActionButton(
                    icon: LucideIcons.send,
                    label: s.homeSend,
                    bg: const Color.fromRGBO(212, 175, 55, 0.30),
                    fg: RawShieldColors.background,
                    onTap: () => context.push(AppRoutes.transfer),
                  ),
                  _ActionButton(
                    icon: LucideIcons.download,
                    label: s.homeWithdraw,
                    bg: const Color.fromRGBO(0, 200, 83, 0.15),
                    fg: RawShieldColors.success,
                    onTap: () => context.push(AppRoutes.withdrawal),
                  ),
                  // _ActionButton(
                  //   icon: LucideIcons.receipt,
                  //   label: 'Factures',
                  //   bg: const Color.fromRGBO(33, 150, 243, 0.15),
                  //   fg: RawShieldColors.info,
                  //   onTap: () {},
                  // ),
                ],
              ),

              const SizedBox(height: RawShieldSpacing.xl),

              // Placeholder sections
              Text(s.homeFrequentContacts, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
              const SizedBox(height: RawShieldSpacing.md),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _frequentHomeContacts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: RawShieldSpacing.md),
                  itemBuilder: (_, i) => Column(
                    children: [
                      InkWell(
                        onTap: () => context.push(
                          AppRoutes.transfer,
                          extra: TransferPrefill(
                            recipientName: _frequentHomeContacts[i].name,
                            recipientPhone: _frequentHomeContacts[i].phone,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(RawShieldRadii.full),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: RawShieldColors.surfaceElevated,
                            shape: BoxShape.circle,
                            border: Border.all(color: RawShieldColors.border),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _frequentHomeContacts[i].name.substring(0, 1),
                            style: t.titleLarge?.copyWith(color: RawShieldColors.gold),
                          ),
                        ),
                      ),
                      const SizedBox(height: RawShieldSpacing.xs),
                      Text(
                        _frequentHomeContacts[i].name,
                        style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: RawShieldSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.homeRecentTx, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
                  TextButton(
                    onPressed: () {},
                    child: Text(s.homeSeeAll, style: t.bodySmall?.copyWith(color: RawShieldColors.gold)),
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
                  children: [
                    for (var i = 0; i < recent.length; i++) ...[
                      _TxnRow(
                        title: recent[i].receiver,
                        subtitle: recent[i].status,
                        amount: recent[i].amountLabel,
                        isIn: recent[i].amountLabel.trim().startsWith('+'),
                        onTap: () => context.push(
                          AppRoutes.transactionDetails,
                          extra: recent[i],
                        ),
                      ),
                      if (i != recent.length - 1)
                        Divider(height: 1, color: RawShieldColors.border),
                    ],
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

class _BalanceCardData {
  const _BalanceCardData({
    required this.currency,
    required this.balance,
    required this.maskedNumber,
  });

  final String currency;
  final String balance;
  final String maskedNumber;
}

const List<_BalanceCardData> _balanceCards = [
  _BalanceCardData(
    currency: 'CDF',
    balance: '2 457 800 CDF',
    maskedNumber: '**** **** **** 4521',
  ),
  _BalanceCardData(
    currency: 'USD',
    balance: '1 320 USD',
    maskedNumber: '**** **** **** 7734',
  ),
];

class _HomeContact {
  const _HomeContact({
    required this.name,
    required this.phone,
  });

  final String name;
  final String phone;
}

const List<_HomeContact> _frequentHomeContacts = [
  _HomeContact(name: 'Marie', phone: '+243 81 111 2222'),
  _HomeContact(name: 'Pierre', phone: '+243 82 333 4444'),
  _HomeContact(name: 'Sarah', phone: '+243 89 555 6666'),
  _HomeContact(name: 'Joseph', phone: '+243 97 777 8888'),
  _HomeContact(name: 'Aline', phone: '+243 80 000 1122'),
  _HomeContact(name: 'Jean', phone: '+243 70 123 4567'),
];

List<TransactionDetails> _recentHomeTransactions(AppStrings s) {
  return [
    TransactionDetails(
      id: 'txn_home_1',
      amountLabel: '-50\u202f000 CDF',
      status: s.mockTxFriendly,
      riskScore: 20,
      modelConfidence: 0.94,
      decision: s.decisionAuth,
      dateLabel: s.mockToday,
      location: 'Kinshasa',
      sender: s.commonYou,
      receiver: 'Marie Kabongo',
      currency: 'CDF',
    ),
    TransactionDetails(
      id: 'txn_home_2',
      amountLabel: '+150\u202f000 CDF',
      status: s.mockTxInvoice,
      riskScore: 15,
      modelConfidence: 0.91,
      decision: s.decisionAuth,
      dateLabel: s.mockYesterday,
      location: s.mockLocationGombe,
      sender: s.commonYou,
      receiver: s.commonYou,
      currency: 'CDF',
    ),
    TransactionDetails(
      id: 'txn_home_3',
      amountLabel: '-100\u202f000 CDF',
      status: s.mockLocationGareCentrale,
      riskScore: 55,
      modelConfidence: 0.72,
      decision: s.decisionVerify,
      dateLabel: s.mockYesterday1105,
      location: 'Kinshasa',
      sender: s.mockWithdrawalSender,
      receiver: s.commonYou,
      currency: 'CDF',
    ),
  ];
}

class _TxnRow extends StatelessWidget {
  const _TxnRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIn,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String amount;
  final bool isIn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
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

