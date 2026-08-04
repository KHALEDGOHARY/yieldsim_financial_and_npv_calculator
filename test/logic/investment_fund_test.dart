import 'package:flutter_test/flutter_test.dart';
import 'package:fincalc_app/logic/investment_fund.dart';

void main() {
  group('simulateInvestmentFund - وضع إعادة الاستثمار', () {
    // المثال المحلول: P0=50,000، PMT=500، r=8%، n=12، t=5 سنوات
    // FV متوقعة ≈ 111,230.71 (تم التحقق منها في fincalc_spec.xlsx)
    test('يطابق المثال المحلول (وضع إعادة الاستثمار)', () {
      final result = simulateInvestmentFund(
        P0: 50000,
        PMT: 500,
        r: 0.08,
        n: 12,
        t: 5,
        mode: InvestmentMode.reinvest,
      );

      expect(result.value('finalValue'), closeTo(111230.71, 1));
    });

    test('المحاكاة الشهرية تطابق المعادلة المغلقة (closed-form)', () {
      final result = simulateInvestmentFund(
        P0: 50000,
        PMT: 500,
        r: 0.08,
        n: 12,
        t: 5,
        mode: InvestmentMode.reinvest,
      );
      final closedForm = investmentFundClosedFormCheck(
        P0: 50000,
        PMT: 500,
        r: 0.08,
        n: 12,
        t: 5,
      );

      expect(result.value('finalValue'), closeTo(closedForm, 0.01));
    });

    test('عدد الصفوف في الجدول = عدد الأشهر + شهر البداية (0)', () {
      final result = simulateInvestmentFund(
        P0: 10000,
        PMT: 100,
        r: 0.06,
        n: 12,
        t: 2,
        mode: InvestmentMode.reinvest,
      );
      expect(result.series!.length, 25); // شهر 0 إلى شهر 24
    });
  });

  group('simulateInvestmentFund - وضع السحب الدوري', () {
    test('رأس المال يتراكم بالدفعات فقط، والعوائد تُسحب منفصلة', () {
      final result = simulateInvestmentFund(
        P0: 50000,
        PMT: 500,
        r: 0.08,
        n: 12,
        t: 5,
        mode: InvestmentMode.withdraw,
      );

      // رأس المال المتبقي = P0 + مجموع الدفعات فقط (بدون أي فوائد مضافة)
      expect(result.value('remainingCapital'), closeTo(50000 + 500 * 60, 0.01));
      expect(result.value('totalReturnsWithdrawn'), greaterThan(0));
    });
  });
}
