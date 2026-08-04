import 'package:flutter_test/flutter_test.dart';
import 'package:fincalc_app/logic/inflation_pmt.dart';

void main() {
  group('calculateInflationAdjustedPMT', () {
    // المثال المحلول: FVtarget=200,000، t=10 سنوات، r=10%، i=5%، n=12
    // r_real ≈ 4.76%، PMT ≈ 1,304.46 (تم التحقق منها في fincalc_spec.xlsx)
    test('يطابق المثال المحلول (الطريقة 1 - قسط ثابت)', () {
      final result = calculateInflationAdjustedPMT(
        fvTarget: 200000,
        r: 0.10,
        i: 0.05,
        n: 12,
        t: 10,
        method: InflationPmtMethod.fixedRealRate,
      );

      expect(result.value('rReal'), closeTo(0.0476, 0.001));
      expect(result.value('pmt'), closeTo(1304.46, 0.5));
    });

    test('الطريقة 2 - القسط يتصاعد سنويًا بمعدل التضخم', () {
      final result = calculateInflationAdjustedPMT(
        fvTarget: 200000,
        r: 0.10,
        i: 0.05,
        n: 12,
        t: 10,
        method: InflationPmtMethod.growingWithInflation,
      );

      final series = result.series!;
      expect(series.length, 10);
      // قسط السنة الثانية = قسط السنة الأولى × 1.05
      final firstYearPmt = series[0]['pmt'] as double;
      final secondYearPmt = series[1]['pmt'] as double;
      expect(secondYearPmt, closeTo(firstYearPmt * 1.05, 0.01));
    });
  });
}
