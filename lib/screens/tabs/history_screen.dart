import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../l10n/app_strings.dart';
import '../../theme/rawshield_theme.dart';
import '../transactions/transaction_details_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _query = '';
  String _filter = 'all';
  bool _showFilters = false;

  List<(String, String)> _filters(AppStrings s) => [
        (s.historyFilterAll, 'all'),
        (s.historyFilterSent, 'sent'),
        (s.historyFilterReceived, 'received'),
        (s.historyFilterWithdrawal, 'withdrawal'),
        (s.historyFilterBill, 'bill'),
      ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    final filters = _filters(s);
    return Scaffold(
      body: SafeArea(
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
              child: Text(s.historyTitle, style: t.headlineMedium?.copyWith(color: RawShieldColors.text)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
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
                              onChanged: (v) => setState(() => _query = v),
                              decoration: InputDecoration(
                                hintText: s.historySearchHint,
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: RawShieldColors.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: RawShieldSpacing.md),
                  InkWell(
                    onTap: () => setState(() => _showFilters = !_showFilters),
                    borderRadius: BorderRadius.circular(RawShieldRadii.md),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: RawShieldColors.surface,
                        borderRadius: BorderRadius.circular(RawShieldRadii.md),
                        border: Border.all(color: _showFilters ? RawShieldColors.gold : RawShieldColors.border),
                      ),
                      child: Icon(LucideIcons.filter, color: _showFilters ? RawShieldColors.gold : RawShieldColors.text),
                    ),
                  ),
                ],
              ),
            ),
            if (_showFilters)
              SizedBox(
                height: 44,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
                  scrollDirection: Axis.horizontal,
                  children: filters.map((f) {
                    final active = _filter == f.$2;
                    return Padding(
                      padding: const EdgeInsets.only(right: RawShieldSpacing.lg),
                      child: InkWell(
                        onTap: () => setState(() => _filter = f.$2),
                        borderRadius: BorderRadius.circular(RawShieldRadii.md),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                f.$1,
                                style: TextStyle(
                                  color: active ? RawShieldColors.text : RawShieldColors.textSecondary,
                                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                height: 3,
                                width: active ? 28 : 14,
                                decoration: BoxDecoration(
                                  color: active ? RawShieldColors.gold : RawShieldColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(RawShieldRadii.full),
                                  boxShadow: active
                                      ? const [
                                          BoxShadow(
                                            color: Color.fromRGBO(212, 175, 55, 0.55),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(RawShieldSpacing.lg, RawShieldSpacing.lg, RawShieldSpacing.lg, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: s.historyStatsIn,
                      value: '+150,000 CDF',
                      color: RawShieldColors.success,
                    ),
                  ),
                  const SizedBox(width: RawShieldSpacing.md),
                  Expanded(
                    child: _StatCard(
                      label: s.historyStatsOut,
                      value: '-395,000 CDF',
                      color: RawShieldColors.error,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(RawShieldSpacing.lg),
                children: [
                  Text(s.historyAllTransactions, style: t.bodyMedium?.copyWith(color: RawShieldColors.textSecondary)),
                  const SizedBox(height: RawShieldSpacing.md),
                  ..._mockRows(s)
                      .where((r) =>
                          (_query.isEmpty || r.title.toLowerCase().contains(_query.toLowerCase())) &&
                          (_filter == 'all' || r.type == _filter))
                      .map((r) => _TxnItem(row: r, strings: s)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_TxnRowModel> _mockRows(AppStrings s) {
    return [
      _TxnRowModel(type: 'sent', title: 'Marie Kabongo', subtitle: s.mockTxFriendly, amount: '-50,000 CDF'),
      _TxnRowModel(type: 'received', title: s.commonYou, subtitle: s.mockTxInvoice, amount: '+150,000 CDF'),
      _TxnRowModel(type: 'withdrawal', title: s.mockWithdrawalSender, subtitle: s.mockLocationGareCentrale, amount: '-100,000 CDF'),
      _TxnRowModel(type: 'sent', title: 'Pierre Ilunga', subtitle: s.mockTxGoods, amount: '-250,000 CDF'),
      _TxnRowModel(type: 'bill', title: s.mockCompanySnel, subtitle: s.mockTxElectricity, amount: '-45,000 CDF'),
    ];
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(RawShieldSpacing.md),
      decoration: BoxDecoration(
        color: RawShieldColors.surface,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        border: Border.all(color: RawShieldColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
          const SizedBox(height: RawShieldSpacing.xs),
          Text(value, style: t.titleMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _TxnItem extends StatelessWidget {
  const _TxnItem({required this.row, required this.strings});

  final _TxnRowModel row;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = strings;
    final isIn = row.type == 'received';
    final icon = row.type == 'received'
        ? LucideIcons.download
        : row.type == 'withdrawal'
            ? LucideIcons.receipt
            : LucideIcons.send;
    final iconColor = isIn ? RawShieldColors.success : RawShieldColors.text;

    return InkWell(
      onTap: () {
        final details = TransactionDetails(
          id: 'txn_hist_${row.title}_${row.amount}',
          amountLabel: row.amount,
          status: row.subtitle,
          riskScore: row.amount.startsWith('-') ? 55 : 15,
          modelConfidence: row.amount.startsWith('-') ? 72 : 91,
          decision: row.amount.startsWith('-') ? s.decisionVerify : s.decisionAuth,
          dateLabel: s.historyTimeAgo,
          location: row.type == 'withdrawal' ? s.mockLocationGareCentrale : 'Kinshasa',
          sender: row.type == 'received' ? row.title : s.commonYou,
          receiver: row.type == 'received' ? s.commonYou : row.title,
          currency: row.amount.contains('USD') ? 'USD' : 'CDF',
        );
        context.push(AppRoutes.transactionDetails, extra: details);
      },
      borderRadius: BorderRadius.circular(RawShieldRadii.lg),
      child: Container(
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
              color: isIn ? const Color.fromRGBO(0, 200, 83, 0.15) : RawShieldColors.surfaceLight,
              borderRadius: BorderRadius.circular(RawShieldRadii.md),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: RawShieldSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.title, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: 2),
                Text(row.subtitle, style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                const SizedBox(height: 2),
                Text(s.historyTimeAgo, style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(width: RawShieldSpacing.md),
          Text(
            row.amount,
            style: t.bodyMedium?.copyWith(color: isIn ? RawShieldColors.success : RawShieldColors.text),
          ),
          ],
        ),
      ),
    );
  }
}

class _TxnRowModel {
  const _TxnRowModel({required this.type, required this.title, required this.subtitle, required this.amount});

  final String type;
  final String title;
  final String subtitle;
  final String amount;
}

