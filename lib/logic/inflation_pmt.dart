import 'dart:math' as math;

import '../models/calculation_result.dart';

enum InflationPmtMethod { fixedRealRate, growingWithInflation }

/// الحاسبة 3: القسط الشهري اللازم لتعويض التضخم.
///
/// المصدر: fincalc_spec.xlsx — شيت "3_قسط تعويض تضخم".
///
/// معادلة فيشر:  r_real = (1 + r) / (1 + i) − 1
///
/// الطريقة 1 (قسط ثابت بمعدل حقيقي):
///   PMT = fvTarget × (r_real/n) / [ (1 + r_real/n)^(n×t) − 1 ]
///
/// الطريقة 2 (قسط متصاعد يزيد سنويًا مع التضخم):
///   PMT_سنة k = PMT_السنة الأولى × (1 + i)^(k−1)
///   (PMT_السنة الأولى مُحسوب بنفس معادلة الطريقة 1 كنقطة بداية).
CalculationResult calculateInflationAdjustedPMT({
  required double fvTarget,
  required double r,
  required double i,
  required double n,
  required double t,
  required InflationPmtMethod method,
}) {
  if (fvTarget < 0) throw ArgumentError('الهدف المستقبلي لا يمكن أن يكون سالبًا');
  if (n <= 0) throw ArgumentError('n لازم يكون أكبر من صفر');

  final double rReal = (1 + r) / (1 + i) - 1;
  final double growthFactor = math.pow(1 + rReal / n, n * t).toDouble();
  final double basePmt = fvTarget * (rReal / n) / (growthFactor - 1);

  if (method == InflationPmtMethod.fixedRealRate) {
    return CalculationResult(
      values: {'rReal': rReal, 'pmt': basePmt},
      note: 'قسط ثابت طوال المدة، محسوب بمعدل العائد الحقيقي بعد خصم التضخم.',
    );
  } else {
    final int years = t.round();
    final List<Map<String, dynamic>> series = [];
    for (int k = 1; k <= years; k++) {
      final double pmtYearK = basePmt * math.pow(1 + i, k - 1).toDouble();
      series.add({'year': k, 'pmt': pmtYearK});
    }
    return CalculationResult(
      values: {'rReal': rReal, 'firstYearPmt': basePmt},
      series: series,
      note: 'قسط متصاعد يكبر كل سنة بمعدل التضخم عشان تفضل قيمته الحقيقية ثابتة.',
    );
  }
}
