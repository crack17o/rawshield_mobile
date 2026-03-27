import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/language_globe_button.dart';
import '../../theme/rawshield_theme.dart';
import 'transfer_recipient_screen.dart';
import 'transfer_amount_screen.dart';
import 'transfer_confirm_screen.dart';
import 'transfer_otp_screen.dart';
import 'transfer_result_screen.dart';
import 'transfer_prefill.dart';

class TransferFlow extends StatelessWidget {
  const TransferFlow({
    super.key,
    this.prefill,
  });

  final TransferPrefill? prefill;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: RawShieldColors.background,
      child: SafeArea(
        child: Navigator(
          initialRoute: '/',
          onGenerateRoute: (settings) {
            Widget screen;
            switch (settings.name) {
              case '/':
                screen = TransferRecipientScreen(
                  initialRecipientName: prefill?.recipientName,
                  initialRecipientPhone: prefill?.recipientPhone,
                );
                break;
              case '/amount':
                screen = const TransferAmountScreen();
                break;
              case '/confirm':
                screen = const TransferConfirmScreen();
                break;
              case '/otp':
                screen = const TransferOtpScreen();
                break;
              case '/result':
                screen = const TransferResultScreen();
                break;
              default:
                screen = const TransferRecipientScreen();
            }
            return MaterialPageRoute<void>(settings: settings, builder: (_) => screen);
          },
        ),
      ),
    );
  }
}

class TransferHeader extends StatelessWidget {
  const TransferHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        RawShieldSpacing.lg,
        RawShieldSpacing.xxl,
        RawShieldSpacing.lg,
        RawShieldSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: RawShieldColors.text),
          ),
          Text(title, style: t.titleLarge?.copyWith(color: RawShieldColors.text)),
          const LanguageGlobeButton(),
        ],
      ),
    );
  }
}

