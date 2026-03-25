import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/rawshield_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _query = '';
  String _filter = 'all';
  bool _showFilters = false;

  final _filters = const [
    ('Tout', 'all'),
    ('Envoyé', 'sent'),
    ('Reçu', 'received'),
    ('Retrait', 'withdrawal'),
    ('Facture', 'bill'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
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
              child: Text('Historique', style: t.headlineMedium?.copyWith(color: RawShieldColors.text)),
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
                              decoration: const InputDecoration(
                                hintText: 'Rechercher une transaction...',
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
                height: 52,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg, vertical: RawShieldSpacing.md),
                  scrollDirection: Axis.horizontal,
                  children: _filters.map((f) {
                    final active = _filter == f.$2;
                    return Padding(
                      padding: const EdgeInsets.only(right: RawShieldSpacing.sm),
                      child: ChoiceChip(
                        selected: active,
                        label: Text(f.$1),
                        onSelected: (_) => setState(() => _filter = f.$2),
                        selectedColor: const Color.fromRGBO(212, 175, 55, 0.25),
                        backgroundColor: RawShieldColors.surface,
                        side: BorderSide(color: active ? RawShieldColors.gold : RawShieldColors.border),
                        labelStyle: TextStyle(color: active ? RawShieldColors.gold : RawShieldColors.textSecondary),
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
                      label: 'Entrées',
                      value: '+150,000 CDF',
                      color: RawShieldColors.success,
                    ),
                  ),
                  const SizedBox(width: RawShieldSpacing.md),
                  Expanded(
                    child: _StatCard(
                      label: 'Sorties',
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
                  Text('Toutes les transactions', style: t.bodyMedium?.copyWith(color: RawShieldColors.textSecondary)),
                  const SizedBox(height: RawShieldSpacing.md),
                  ..._mockRows()
                      .where((r) =>
                          (_query.isEmpty || r.title.toLowerCase().contains(_query.toLowerCase())) &&
                          (_filter == 'all' || r.type == _filter))
                      .map((r) => _TxnItem(row: r)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_TxnRowModel> _mockRows() {
    return const [
      _TxnRowModel(type: 'sent', title: 'Marie Kabongo', subtitle: 'Transfert amical', amount: '-50,000 CDF'),
      _TxnRowModel(type: 'received', title: 'Vous', subtitle: 'Paiement facture #1234', amount: '+150,000 CDF'),
      _TxnRowModel(type: 'withdrawal', title: 'Retrait ATM', subtitle: 'Gare Centrale', amount: '-100,000 CDF'),
      _TxnRowModel(type: 'sent', title: 'Pierre Ilunga', subtitle: 'Achat marchandise', amount: '-250,000 CDF'),
      _TxnRowModel(type: 'bill', title: 'SNEL', subtitle: 'Facture électricité', amount: '-45,000 CDF'),
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
  const _TxnItem({required this.row});

  final _TxnRowModel row;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isIn = row.type == 'received';
    final icon = row.type == 'received'
        ? LucideIcons.download
        : row.type == 'withdrawal'
            ? LucideIcons.receipt
            : LucideIcons.send;
    final iconColor = isIn ? RawShieldColors.success : RawShieldColors.text;

    return Container(
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
                Text('Il y a 2h', style: t.labelSmall?.copyWith(color: RawShieldColors.textMuted)),
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

