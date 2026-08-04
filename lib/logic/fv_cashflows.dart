import 'dart:math' as math;

import '../models/calculation_result.dart';
import '../models/cash_flow_entry.dart';

/// الحاسبة 5: صافي القيمة المستقبلية لسلسلة تدفقات نقدية غير متساوية.
///
/// المصدر: fincalc_spec.xlsx — شيت "5_FV تدفقات نقدية".
///
///   FV = Σ CF_t × (1 + r)^(T−t)     لكل تدفق CF_t من t=1 إلى T
CalculationResult calculateFutureValueOfCashFlows({
  required List<CashFlowEntry> cashFlows,
  required double r,
  required int T,
}) {
  if (cashFlows.isEmpty) {
    throw ArgumentError('لازم تدخل تدفق نقدي واحد على الأقل');
  }

  double fv = 0;
  final List<Map<String, dynamic>> series = [];
  for (final cf in cashFlows) {
    final double factor = math.pow(1 + r, T - cf.year).toDouble();
    final double contribution = cf.amount * factor;
    fv += contribution;
    series.add({
      'year': cf.year,
      'amount': cf.amount,
      'factor': factor,
      'contribution': contribution,
    });
  }

  return CalculationResult(values: {'fv': fv}, series: series);
}
