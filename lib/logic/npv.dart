import 'dart:math' as math;

import '../models/calculation_result.dart';
import '../models/cash_flow_entry.dart';

/// الحاسبة 6: صافي القيمة الحالية (NPV).
///
/// المصدر: fincalc_spec.xlsx — شيت "6_NPV".
///
///   NPV = [ Σ CF_t / (1 + r)^t ] − الاستثمار المبدئي     لكل تدفق t=1 إلى T
///
/// قاعدة القرار: NPV موجب → مجدٍ اقتصاديًا عند معدل الخصم المستخدم.
///                NPV سالب → غير مجدٍ.
CalculationResult calculateNPV({
  required double initialInvestment,
  required List<CashFlowEntry> cashFlows,
  required double r,
}) {
  if (cashFlows.isEmpty) {
    throw ArgumentError('لازم تدخل تدفق نقدي واحد على الأقل');
  }

  double pvTotal = 0;
  final List<Map<String, dynamic>> series = [];
  for (final cf in cashFlows) {
    final double discountFactor = math.pow(1 + r, cf.year).toDouble();
    final double pv = cf.amount / discountFactor;
    pvTotal += pv;
    series.add({'year': cf.year, 'amount': cf.amount, 'pv': pv});
  }

  final double npv = pvTotal - initialInvestment;

  return CalculationResult(
    values: {
      'pvTotal': pvTotal,
      'npv': npv,
    },
    series: series,
    note: npv > 0 ? 'مجدٍ اقتصاديًا ✓' : 'غير مجدٍ ✗',
  );
}
