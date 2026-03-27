import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/routes.dart';
import '../../l10n/app_strings.dart';
import '../../l10n/language_globe_button.dart';
import '../../theme/rawshield_theme.dart';
import 'startup_gate.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  List<_OnboardingPageData> _pages(AppStrings s) => [
        _OnboardingPageData(title: s.ob1Title, subtitle: s.ob1Subtitle, icon: Icons.shield_outlined),
        _OnboardingPageData(title: s.ob2Title, subtitle: s.ob2Subtitle, icon: Icons.analytics_outlined),
        _OnboardingPageData(title: s.ob3Title, subtitle: s.ob3Subtitle, icon: Icons.lock_outline),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StartupGate.onboardingSeenKey, true);
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  void _next(List<_OnboardingPageData> pages) {
    if (_index >= pages.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final s = ref.watch(appStringsProvider);
    final pages = _pages(s);
    final isLast = _index == pages.length - 1;

    return Scaffold(
      backgroundColor: RawShieldColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                RawShieldSpacing.lg,
                RawShieldSpacing.md,
                RawShieldSpacing.lg,
                RawShieldSpacing.sm,
              ),
              child: Row(
                children: [
                  const LanguageGlobeButton(),
                  const Spacer(),
                  TextButton(
                    onPressed: _finish,
                    child: Text(s.onboardingSkip),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(RawShieldSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            color: RawShieldColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(RawShieldRadii.xl),
                            border: Border.all(color: RawShieldColors.borderGold),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(212, 175, 55, 0.22),
                                offset: Offset(0, 10),
                                blurRadius: 26,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(p.icon, size: 46, color: RawShieldColors.gold),
                        ),
                        const SizedBox(height: RawShieldSpacing.xl),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: t.headlineSmall?.copyWith(color: RawShieldColors.text),
                        ),
                        const SizedBox(height: RawShieldSpacing.sm),
                        Text(
                          p.subtitle,
                          textAlign: TextAlign.center,
                          style: t.bodyMedium?.copyWith(color: RawShieldColors.textSecondary, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                RawShieldSpacing.lg,
                RawShieldSpacing.md,
                RawShieldSpacing.lg,
                RawShieldSpacing.lg,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active ? RawShieldColors.gold : RawShieldColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: RawShieldSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _finish,
                          child: Text(s.onboardingLater),
                        ),
                      ),
                      const SizedBox(width: RawShieldSpacing.md),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _next(pages),
                          style: FilledButton.styleFrom(
                            backgroundColor: RawShieldColors.gold,
                            foregroundColor: RawShieldColors.background,
                          ),
                          child: Text(isLast ? s.onboardingStart : s.onboardingNext),
                        ),
                      ),
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

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
