enum TransferRiskLevel {
  low,
  medium,
  high,
  veryHigh,
}

class TransferRiskUtils {
  const TransferRiskUtils._();

  /// Score de risque déterministe basé sur le montant (simulation).
  /// Plages voulues par l'UI:
  /// - 0-30 : faible
  /// - 30-70 : moyen
  /// - 70-90 : élevé
  /// - 90-100 : très élevé
  static int computeRiskScore({required int? amountCdf}) {
    final amt = amountCdf ?? 0;
    // Calibration: pour 90k => 30, 210k => 70, 270k => 90
    final score = (amt / 3000.0).round();
    return score.clamp(0, 100);
  }

  static TransferRiskLevel getRiskLevel(int riskScore) {
    if (riskScore <= 30) return TransferRiskLevel.low;
    if (riskScore <= 70) return TransferRiskLevel.medium;
    if (riskScore <= 90) return TransferRiskLevel.high;
    return TransferRiskLevel.veryHigh;
  }
}

