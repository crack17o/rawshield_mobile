import 'package:shared_preferences/shared_preferences.dart';

/// Préférences locales (session, sécurité).
class AppPrefs {
  AppPrefs._();

  static const signedInKey = 'signedIn';
  static const biometricEnabledKey = 'biometricEnabled';
  static const transactionPinKey = 'transactionPin';
  static const languageCodeKey = 'languageCode';
  static const pushNotificationsKey = 'pushNotificationsEnabled';

  static Future<bool> isSignedIn() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(signedInKey) ?? false;
  }

  static Future<void> setSignedIn(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(signedInKey, value);
  }

  /// Biométrie activée dans l’app (peut être coupée par l’utilisateur dans Sécurité).
  static Future<bool> isBiometricEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(biometricEnabledKey) ?? true;
  }

  static Future<void> setBiometricEnabled(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(biometricEnabledKey, value);
  }

  /// PIN transactionnel (6 chiffres). Défaut démo tant que l’utilisateur ne l’a pas modifié.
  static Future<String> getTransactionPin() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(transactionPinKey) ?? '123456';
  }

  static Future<void> setTransactionPin(String pin) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(transactionPinKey, pin);
  }

  /// Code OTP simulé pour les flux « valider par e-mail » (maquette).
  static const demoOtpCode = '123456';

  /// `fr`, `en` ou `ln` (Lingala).
  static Future<String> getLanguageCode() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(languageCodeKey) ?? 'fr';
  }

  static Future<void> setLanguageCode(String code) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(languageCodeKey, code);
  }

  static Future<bool> getPushNotificationsEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(pushNotificationsKey) ?? true;
  }

  static Future<void> setPushNotificationsEnabled(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(pushNotificationsKey, value);
  }
}
