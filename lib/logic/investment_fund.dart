import 'dart:math' as math;

import '../models/calculation_result.dart';

enum InvestmentMode { reinvest, withdraw }

/// الحاسبة 2: صندوق استثمار (دفعة مقدمة + دفعات دورية).
///
/// المصدر: fincalc_spec.xlsx — شيت "2_صندوق استثمار".
///
/// موصى به هندسيًا (وده اللي بننفذه هنا): محاكاة شهر-بشهر بحلقة تكرارية،
/// مش معادلة مغلقة واحدة، عشان يسهل لاحقًا إضافة تعديلات (وقف دفعات مؤقتًا..).
///
/// وضع (أ) reinvest — إعادة استثمار العوائد:
///   Balance₀ = p0
///   Balance_k = Balance_(k-1) × (1 + r/n) + pmt   لكل شهر k من 1 إلى n×t
///
/// وضع (ب) withdraw — سحب العوائد دوريًا بدون إعادة استثمار:
///   Return_k  = Balance_(k-1) × (r/n)     (يُسحب فورًا، لا يُضاف لرأس المال)
///   Balance_k = Balance_(k-1) + pmt
CalculationResult simulateInvestmentFund({
  required double p0,
  required double pmt,
  required double r,
  required double n,
  required double t,
  required InvestmentMode mode,
}) {
  if (p0 < 0) throw ArgumentError('الدفعة المقدمة لا يمكن أن تكون سالبة');
  if (n <= 0) throw ArgumentError('n لازم يكون أكبر من صفر');
  if (t < 0) throw ArgumentError('المدة لا يمكن أن تكون سالبة');

  final int months = (n * t).round();
  final List<Map<String, dynamic>> series = [];

  if (mode == InvestmentMode.reinvest) {
    double balance = p0;
    series.add({'month': 0, 'balance': balance});
    for (int k = 1; k <= months; k++) {
      balance = balance * (1 + r / n) + pmt;
      series.add({'month': k, 'balance': balance});
    }

    return CalculationResult(
      values: {
        'finalValue': balance,
        'totalContributed': p0 + pmt * months,
        'totalGrowth': balance - (p0 + pmt * months),
      },
      series: series,
      note: 'وضع إعادة الاستثمار: القيمة النهائية = رصيد آخر شهر.',
    );
  } else {
    double balance = p0;
    double totalReturns = 0;
    series.add({'month': 0, 'balance': balance, 'return': 0.0});
    for (int k = 1; k <= months; k++) {
      final double periodReturn = balance * (r / n);
      totalReturns += periodReturn;
      balance = balance + pmt;
      series.add({'month': k, 'balance': balance, 'return': periodReturn});
    }

    return CalculationResult(
      values: {
        'remainingCapital': balance,
        'totalReturnsWithdrawn': totalReturns,
        // في وضع السحب، القيمة النهائية "حاجتين" مش رقم واحد — بنجمعهم هنا
        // فقط للعرض الإجمالي، لكن الشاشة لازم تعرضهم منفصلين لبعض كمان.
        'combinedTotal': balance + totalReturns,
      },
      series: series,
      note: 'وضع السحب الدوري: القيمة النهائية = رصيد رأس المال المتبقي + إجمالي العوائد المسحوبة (منفصلان).',
    );
  }
}

/// معادلة مغلقة (closed-form) — تُستخدم فقط للتحقق الداخلي (unit tests)،
/// وليست مصدر النتيجة المعروضة للمستخدم في وضع إعادة الاستثمار.
double investmentFundClosedFormCheck({
  required double p0,
  required double pmt,
  required double r,
  required double n,
  required double t,
}) {
  final double growthFactor = math.pow(1 + r / n, n * t).toDouble();
  final double fvFromP0 = p0 * growthFactor;
  final double fvFromPMT = pmt * ((growthFactor - 1) / (r / n));
  return fvFromP0 + fvFromPMT;
}
