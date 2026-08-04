import 'package:flutter_test/flutter_test.dart';
import 'package:fincalc_app/logic/present_value.dart';

void main() {
  group('calculatePresentValue', () {
    // المثال المحلول: FV=50,000 بعد 5 سنين، r=8% → PV ≈ 34,029
    test('يطابق المثال المحلول (مبلغ واحد)', () {
      final result = calculatePresentValue(fv: 50000, r: 0.08, t: 5);
      expect(result.value('pv'), closeTo(34029, 1));
    });
  });

  group('calculatePresentValueAnnuity', () {
    test('يحسب قيمة سلسلة دفعات متساوية بدون أخطاء', () {
      final result = calculatePresentValueAnnuity(
        pmt: 1000,
        r: 0.06,
        n: 12,
        t: 5,
      );
      expect(result.value('pv'), greaterThan(0));
    });
  });
}
