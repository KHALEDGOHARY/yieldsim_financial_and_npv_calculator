import 'package:flutter_test/flutter_test.dart';
import 'package:fincalc_app/logic/compound_interest.dart';

void main() {
  group('calculateSimpleAndCompoundInterest', () {
    // المثال المحلول في الشيت: P=10,000، r=10%، t=3 سنوات، n=12 (شهري)
    test('يطابق المثال المحلول في fincalc_spec.xlsx', () {
      final result = calculateSimpleAndCompoundInterest(
        P: 10000,
        r: 0.10,
        t: 3,
        n: 12,
      );

      expect(result.value('simpleInterest'), closeTo(3000, 0.01));
      expect(result.value('simpleFV'), closeTo(13000, 0.01));
      expect(result.value('compoundFV'), closeTo(13481.82, 0.5));
      expect(result.value('compoundInterest'), closeTo(3481.82, 0.5));
    });

    test('يرفض P سالبة', () {
      expect(
        () => calculateSimpleAndCompoundInterest(P: -100, r: 0.1, t: 1, n: 12),
        throwsArgumentError,
      );
    });

    test('يرفض n = صفر', () {
      expect(
        () => calculateSimpleAndCompoundInterest(P: 1000, r: 0.1, t: 1, n: 0),
        throwsArgumentError,
      );
    });
  });
}
