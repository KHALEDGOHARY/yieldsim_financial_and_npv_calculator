import 'package:flutter_test/flutter_test.dart';
import 'package:fincalc_app/logic/npv.dart';
import 'package:fincalc_app/models/cash_flow_entry.dart';

void main() {
  group('calculateNPV', () {
    // المثال المحلول: استثمار مبدئي 100,000، تدفقات 30k/40k/45k/35k
    // على 4 سنين، r=12% → NPV متوقعة ≈ +12,946.71
    test('يطابق المثال المحلول', () {
      final result = calculateNPV(
        initialInvestment: 100000,
        cashFlows: const [
          CashFlowEntry(year: 1, amount: 30000),
          CashFlowEntry(year: 2, amount: 40000),
          CashFlowEntry(year: 3, amount: 45000),
          CashFlowEntry(year: 4, amount: 35000),
        ],
        r: 0.12,
      );

      expect(result.value('pvTotal'), closeTo(112946.71, 0.5));
      expect(result.value('npv'), closeTo(12946.71, 0.5));
      expect(result.note, contains('مجدٍ'));
    });

    test('NPV سالب لما التكلفة أعلى من القيمة الحالية للتدفقات', () {
      final result = calculateNPV(
        initialInvestment: 500000,
        cashFlows: const [
          CashFlowEntry(year: 1, amount: 30000),
          CashFlowEntry(year: 2, amount: 40000),
        ],
        r: 0.12,
      );
      expect(result.value('npv'), lessThan(0));
    });
  });
}
