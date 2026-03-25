import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/routes.dart';
import '../../auth/biometric_auth.dart';
import '../../theme/rawshield_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _biometric = BiometricAuth();
  bool _showPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(AppRoutes.tabs);
  }

  Future<void> _biometricLogin() async {
    final ok = await _biometric.authenticate();
    if (!mounted) return;
    if (ok) context.go(AppRoutes.tabs);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RawShieldSpacing.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & Brand
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: RawShieldColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(RawShieldRadii.xl),
                        border: Border.all(color: RawShieldColors.borderGold),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(212, 175, 55, 0.30),
                            offset: Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/brand/minimum_logo.png',
                        width: 54,
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: RawShieldSpacing.md),
                    Text('RAWShield AI', style: t.headlineMedium?.copyWith(color: RawShieldColors.gold)),
                    const SizedBox(height: RawShieldSpacing.xs),
                    Text("Votre banque, protégée par l'IA", style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: RawShieldSpacing.xl),

                // Login Form
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(RawShieldSpacing.lg),
                  decoration: BoxDecoration(
                    color: RawShieldColors.surface,
                    borderRadius: BorderRadius.circular(RawShieldRadii.lg),
                    border: Border.all(color: RawShieldColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Connexion', style: t.titleLarge?.copyWith(color: RawShieldColors.text)),
                      const SizedBox(height: RawShieldSpacing.xs),
                      Text('Accédez à votre compte sécurisé', style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary)),
                      const SizedBox(height: RawShieldSpacing.lg),

                      Text('EMAIL OU TÉLÉPHONE', style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
                      const SizedBox(height: RawShieldSpacing.xs),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'ex: jean.mutombo@email.cd'),
                      ),
                      const SizedBox(height: RawShieldSpacing.md),

                      Text('MOT DE PASSE', style: t.labelSmall?.copyWith(color: RawShieldColors.textSecondary)),
                      const SizedBox(height: RawShieldSpacing.xs),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                            icon: Icon(_showPassword ? LucideIcons.eyeOff : LucideIcons.eye, color: RawShieldColors.textSecondary),
                          ),
                        ),
                      ),
                      const SizedBox(height: RawShieldSpacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Mot de passe oublié ?', style: t.bodySmall?.copyWith(color: RawShieldColors.gold)),
                        ),
                      ),
                      const SizedBox(height: RawShieldSpacing.sm),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _login,
                          style: FilledButton.styleFrom(
                            backgroundColor: RawShieldColors.gold,
                            foregroundColor: RawShieldColors.background,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_isLoading ? 'Connexion...' : 'Se connecter', style: const TextStyle(fontWeight: FontWeight.w600)),
                              if (!_isLoading) ...[
                                const SizedBox(width: 10),
                                const Icon(LucideIcons.chevronRight, size: 20),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: RawShieldSpacing.md),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: _biometricLogin,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: RawShieldColors.borderGold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RawShieldRadii.md)),
                            foregroundColor: RawShieldColors.gold,
                          ),
                          icon: const Icon(LucideIcons.fingerprint, size: 22),
                          label: const Text('Connexion biométrique'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: RawShieldSpacing.lg),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 0,
                  children: [
                    Text(
                      "Vous n'avez pas de compte ?",
                      style: t.bodySmall?.copyWith(color: RawShieldColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
                      child: Text('Créer un compte', style: t.bodySmall?.copyWith(color: RawShieldColors.gold)),
                    ),
                  ],
                ),
                const SizedBox(height: RawShieldSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: RawShieldSpacing.sm, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(212, 175, 55, 0.20),
                    borderRadius: BorderRadius.circular(RawShieldRadii.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.shield, size: 14, color: RawShieldColors.goldLight),
                      const SizedBox(width: 6),
                      Text('Protégé par RAWShield AI', style: t.labelSmall?.copyWith(color: RawShieldColors.goldLight)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

