import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Index de l’onglet principal (0–3).
final tabIndexProvider = NotifierProvider<TabIndexNotifier, int>(TabIndexNotifier.new);

class TabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int i) {
    if (i >= 0 && i <= 3) state = i;
  }
}
