class CurrencyUtils {
  static const String usd = 'USD';
  static const String cdf = 'CDF';

  // Basé sur les taux utilisés côté web :
  // 1 EUR = 1.09 USD
  // 1 EUR = 3000 CDF
  // Donc : 1 USD = 3000 / 1.09 CDF
  static const double _usdToCdf = 3000.0 / 1.09;
  static const double _cdfToUsd = 1.09 / 3000.0;

  static int toCdfFrom(String currency, int amount) {
    if (currency == usd) return (amount * _usdToCdf).round();
    return amount; // CDF
  }

  static double fromCdfTo(String currency, int amountCdf) {
    if (currency == usd) return amountCdf * _cdfToUsd;
    return amountCdf.toDouble(); // CDF
  }
}

