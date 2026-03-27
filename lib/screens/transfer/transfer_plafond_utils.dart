import '../../utils/currency_utils.dart';

class TransferPlafondUtils {
  const TransferPlafondUtils._();

  // Simulation : plafonds "du compte du user" (en CDF).
  // (Les valeurs sont arbitraires mais cohérentes pour tester l'UI.)
  static int userPlafondCdf({required String debitCurrency}) {
    if (debitCurrency == CurrencyUtils.usd) {
      // plafond USD = 100 -> en CDF via conversion
      final plafondUsd = 100;
      return CurrencyUtils.toCdfFrom(CurrencyUtils.usd, plafondUsd);
    }
    // plafond CDF = 200000
    return 200000;
  }

  static String userPlafondLabel({required String debitCurrency}) {
    final plafondCdf = userPlafondCdf(debitCurrency: debitCurrency);
    if (debitCurrency == CurrencyUtils.usd) {
      final plafondUsd = CurrencyUtils.fromCdfTo(CurrencyUtils.usd, plafondCdf);
      return '${plafondUsd.toStringAsFixed(2)} ${CurrencyUtils.usd}';
    }
    return '$plafondCdf ${CurrencyUtils.cdf}';
  }
}

