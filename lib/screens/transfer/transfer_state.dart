import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferDraft {
  const TransferDraft({
    this.recipientName,
    this.recipientPhone,
    this.amountCdf,
    this.note,
  });

  final String? recipientName;
  final String? recipientPhone;
  final int? amountCdf;
  final String? note;

  TransferDraft copyWith({
    String? recipientName,
    String? recipientPhone,
    int? amountCdf,
    String? note,
  }) {
    return TransferDraft(
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      amountCdf: amountCdf ?? this.amountCdf,
      note: note ?? this.note,
    );
  }
}

class TransferDraftNotifier extends Notifier<TransferDraft> {
  @override
  TransferDraft build() => const TransferDraft();

  void reset() => state = const TransferDraft();

  void setRecipient({required String name, required String phone}) {
    state = state.copyWith(recipientName: name, recipientPhone: phone);
  }

  void setAmount(int amountCdf) {
    state = state.copyWith(amountCdf: amountCdf);
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
  }
}

final transferDraftProvider =
    NotifierProvider<TransferDraftNotifier, TransferDraft>(TransferDraftNotifier.new);

