import 'dart:math' as math;

import '../models/calculation_result.dart';

/// الحاسبة 1: الفائدة البسيطة والمركبة.
///
/// المصدر: fincalc_spec.xlsx — شيت "1_فائدة بسيطة ومركبة".
///
/// [P] المبلغ الأساسي، [r] معدل الفائدة السنوي كنسبة عشرية (10% = 0.10)،
/// [t] المدة بالسنوات، [n] عدد مرات احتساب الفائدة في السنة (للمركبة فقط).
///
/// المعادلات (حرفيًا من الشيت):
///   بسيطة:  I = P × r × t              FV = P × (1 + r × t)
///   مركبة:  FV = P × (1 + r/n)^(n×t)   I = FV − P
CalculationResult calculateSimpleAndCompoundInterest({
  required double P,
  required double r,
  required double t,
  required double n,
}) {
  if (P < 0) throw ArgumentError('المبلغ الأساسي لا يمكن أن يكون سالبًا');
  if (t < 0) throw ArgumentError('المدة لا يمكن أن تكون سالبة');
  if (n <= 0) throw ArgumentError('عدد مرات الاحتساب في السنة لازم يكون أكبر من صفر');

  final double simpleInterest = P * r * t;
  final double simpleFV = P * (1 + r * t);

  final double compoundFV = P * math.pow(1 + r / n, n * t).toDouble();
  final double compoundInterest = compoundFV - P;

  return CalculationResult(
    values: {
      'simpleInterest': simpleInterest,
      'simpleFV': simpleFV,
      'compoundFV': compoundFV,
      'compoundInterest': compoundInterest,
    },
    series: [
      {'label': 'بسيطة', 'fv': simpleFV, 'interest': simpleInterest},
      {'label': 'مركبة', 'fv': compoundFV, 'interest': compoundInterest},
    ],
  );
}
