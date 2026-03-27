import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_strings.dart';
import '../../theme/rawshield_theme.dart';
import 'transfer_flow.dart';
import 'transfer_state.dart';

class TransferRecipientScreen extends ConsumerStatefulWidget {
  const TransferRecipientScreen({
    super.key,
    this.initialRecipientName,
    this.initialRecipientPhone,
  });

  final String? initialRecipientName;
  final String? initialRecipientPhone;

  @override
  ConsumerState<TransferRecipientScreen> createState() => _TransferRecipientScreenState();
}

class _TransferRecipientScreenState extends ConsumerState<TransferRecipientScreen> {
  final _controller = TextEditingController();
  String? _selected;
  final List<_SavedContact> _frequentContacts = [
    const _SavedContact(name: 'Marie', phone: '+243 81 111 2222'),
    const _SavedContact(name: 'Pierre', phone: '+243 82 333 4444'),
    const _SavedContact(name: 'Sarah', phone: '+243 89 555 6666'),
    const _SavedContact(name: 'Joseph', phone: '+243 97 777 8888'),
  ];

  @override
  void initState() {
    super.initState();
    final name = widget.initialRecipientName;
    final phone = widget.initialRecipientPhone;
    if (name != null && phone != null) {
      final exists = _frequentContacts.any((c) => c.name == name);
      if (!exists) {
        _frequentContacts.insert(0, _SavedContact(name: name, phone: phone));
      }
      _selected = name;
      _controller.text = phone;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canContinue => _controller.text.trim().isNotEmpty || _selected != null;

  String _normalizePhone(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d+]'), '');
    return cleaned.isEmpty ? input.trim() : cleaned;
  }

  String _resolveOwnerName(String accountOrPhone) {
    final normalized = _normalizePhone(accountOrPhone);
    final directory = <String, String>{
      '243811112222': 'Marie Kabongo',
      '243823334444': 'Pierre Ilunga',
      '243895556666': 'Sarah Mutombo',
      '243977778888': 'Joseph Mbuyi',
      '00124578004521': 'Jean Malu',
      '00124578007734': 'Aline Kanku',
      '78004521': 'Jean Malu',
      '78007734': 'Aline Kanku',
    };

    final key = normalized.replaceFirst('+', '');
    final byExact = directory[key];
    if (byExact != null) return byExact;

    for (final entry in directory.entries) {
      if (key.endsWith(entry.key)) return entry.value;
    }

    // Fallback: on garde un libellé neutre si le numéro n'est pas connu.
    return ref.read(appStringsProvider).unknownHolder;
  }

  _SavedContact? _findSelectedContact() {
    if (_selected == null) return null;
    for (final contact in _frequentContacts) {
      if (contact.name == _selected) return contact;
    }
    return null;
  }

  Future<void> _openAddContactSheet() async {
    final t = Theme.of(context).textTheme;
    final s = ref.read(appStringsProvider);
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    final created = await showModalBottomSheet<_SavedContact>(
      context: context,
      isScrollControlled: true,
      backgroundColor: RawShieldColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RawShieldRadii.xl)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            RawShieldSpacing.lg,
            RawShieldSpacing.lg,
            RawShieldSpacing.lg,
            MediaQuery.of(ctx).viewInsets.bottom + RawShieldSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tfSheetNewContact, style: t.titleMedium?.copyWith(color: RawShieldColors.text)),
              const SizedBox(height: RawShieldSpacing.md),
              TextField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: s.tfSheetNameHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: RawShieldSpacing.md),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: s.tfSheetPhoneHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: RawShieldSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final phone = _normalizePhone(phoneController.text);
                    if (name.isEmpty || phone.isEmpty) return;
                    Navigator.of(ctx).pop(_SavedContact(name: name, phone: phone));
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: RawShieldColors.gold,
                    foregroundColor: RawShieldColors.background,
                  ),
                  child: Text(s.tfAdd),
                ),
              ),
            ],
          ),
        );
      },
    );

    nameController.dispose();
    phoneController.dispose();

    if (created == null || !mounted) return;
    setState(() {
      _frequentContacts.insert(0, created);
      _selected = created.name;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    return Scaffold(
      backgroundColor: RawShieldColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TransferHeader(title: s.transferSendMoney),
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
                      widthFactor: 0.2,
                      child: Container(color: RawShieldColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.sm),
                Text(s.tfWizStep1, style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: RawShieldSpacing.lg),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.lg),
              children: [
                Text(s.tfNumOrAccount, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: RawShieldSpacing.sm),
                Container(
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
                          controller: _controller,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: s.tfPhoneHintEnter,
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: RawShieldColors.text),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.xl),
                Text(s.homeFrequentContacts, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: RawShieldSpacing.md),
                SizedBox(
                  height: 96,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _ContactChip(
                        label: s.tfNewChip,
                        icon: LucideIcons.plus,
                        selected: false,
                        onTap: _openAddContactSheet,
                      ),
                      ..._frequentContacts.map((contact) {
                        final selected = _selected == contact.name;
                        return _ContactChip(
                          label: contact.name,
                          icon: null,
                          selected: selected,
                          onTap: () => setState(() {
                            _selected = contact.name;
                            _controller.clear();
                          }),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: RawShieldSpacing.xl),
                Text(s.tfRecent, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                const SizedBox(height: RawShieldSpacing.md),
                ...['Marie Kabongo', 'Pierre Ilunga'].map((name) {
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
                            color: const Color.fromRGBO(212, 175, 55, 0.20),
                            borderRadius: BorderRadius.circular(RawShieldRadii.md),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(LucideIcons.user, color: RawShieldColors.gold, size: 20),
                        ),
                        const SizedBox(width: RawShieldSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: t.bodyMedium?.copyWith(color: RawShieldColors.text)),
                              const SizedBox(height: 2),
                              Text('+243 81 111 2222', style: t.bodySmall?.copyWith(color: RawShieldColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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
                onPressed: _canContinue
                    ? () {
                        final typedPhone = _normalizePhone(_controller.text);
                        final selectedContact = _findSelectedContact();

                        final selectedName = selectedContact?.name ?? _resolveOwnerName(typedPhone);
                        final selectedPhone = selectedContact?.phone ?? typedPhone;

                        ref.read(transferDraftProvider.notifier).setRecipient(
                              name: selectedName,
                              phone: selectedPhone,
                            );
                        Navigator.of(context).pushNamed('/amount');
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: RawShieldColors.gold,
                  foregroundColor: RawShieldColors.background,
                  disabledBackgroundColor: const Color.fromRGBO(212, 175, 55, 0.25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                ),
                child: Text(s.transferContinue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(right: RawShieldSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RawShieldRadii.lg),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: RawShieldColors.surfaceElevated,
                borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                border: Border.all(color: selected ? RawShieldColors.gold : RawShieldColors.border),
              ),
              alignment: Alignment.center,
              child: icon != null
                  ? Icon(icon, color: RawShieldColors.gold, size: 24)
                  : Text(label.substring(0, 1), style: t.titleLarge?.copyWith(color: RawShieldColors.gold)),
            ),
            const SizedBox(height: RawShieldSpacing.xs),
            SizedBox(
              width: 72,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary),
              ),
            ),
            if (selected)
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: RawShieldColors.gold, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

class _SavedContact {
  const _SavedContact({
    required this.name,
    required this.phone,
  });

  final String name;
  final String phone;
}

