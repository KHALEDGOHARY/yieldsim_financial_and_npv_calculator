import 'package:flutter_test/flutter_test.dart';
import 'package:fincalc_app/logic/fv_cashflows.dart';
import 'package:fincalc_app/models/cash_flow_entry.dart';

void main() {
  group('calculateFutureValueOfCashFlows', () {
    // المثال المحلول: 5,000(سنة1)، 8,000(سنة2)، 6,000(سنة3)، r=7%، T=3
    // FV متوقعة ≈ 20,284.5 (تم التحقق منها في fincalc_spec.xlsx)
    test('يطابق المثال المحلول', () {
      final result = calculateFutureValueOfCashFlows(
        cashFlows: const [
          CashFlowEntry(year: 1, amount: 5000),
          CashFlowEntry(year: 2, amount: 8000),
          CashFlowEntry(year: 3, amount: 6000),
        ],
        r: 0.07,
        T: 3,
      );

      expect(result.value('fv'), closeTo(20284.5, 0.5));
    });

    test('يرفض قائمة تدفقات فاضية', () {
      expect(
        () => calculateFutureValueOfCashFlows(cashFlows: const [], r: 0.07, T: 3),
        throwsArgumentError,
      );
    });
  });
}
