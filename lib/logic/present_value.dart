import 'dart:math' as math;

import '../models/calculation_result.dart';

/// الحاسبة 4: القيمة الحالية (Present Value).
///
/// المصدر: fincalc_spec.xlsx — شيت "4_القيمة الحالية PV".
///
/// لمبلغ واحد مستقبلي:            PV = fv / (1 + r)^t
CalculationResult calculatePresentValue({
  required double fv,
  required double r,
  required double t,
}) {
  if (t < 0) throw ArgumentError('المدة لا يمكن أن تكون سالبة');
  final double pv = fv / math.pow(1 + r, t).toDouble();
  return CalculationResult(values: {'pv': pv});
}

/// لسلسلة دفعات متساوية دورية (Annuity):
///   PV = pmt × [ 1 − (1 + r/n)^(−n×t) ] / (r/n)
CalculationResult calculatePresentValueAnnuity({
  required double pmt,
  required double r,
  required double n,
  required double t,
}) {
  if (n <= 0) throw ArgumentError('n لازم يكون أكبر من صفر');
  final double ratePerPeriod = r / n;
  final double pv = pmt *
      (1 - math.pow(1 + ratePerPeriod, -n * t).toDouble()) /
      ratePerPeriod;
  return CalculationResult(values: {'pv': pv});
}
