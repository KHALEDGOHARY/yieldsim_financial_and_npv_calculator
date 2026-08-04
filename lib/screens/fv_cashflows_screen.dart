import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/fv_cashflows.dart';
import '../models/cash_flow_entry.dart';
import '../providers/calculation_history_provider.dart';
import '../widgets/cash_flow_table_input.dart';
import '../widgets/labeled_input_field.dart';
import '../widgets/result_card.dart';

class FvCashflowsScreen extends StatefulWidget {
  const FvCashflowsScreen({super.key});

  @override
  State<FvCashflowsScreen> createState() => _FvCashflowsScreenState();
}

class _FvCashflowsScreenState extends State<FvCashflowsScreen> {
  final _rCtrl = TextEditingController(text: '7');
  final _tCtrl = TextEditingController(text: '3');
  List<CashFlowEntry> _entries = const [
    CashFlowEntry(year: 1, amount: 5000),
    CashFlowEntry(year: 2, amount: 8000),
    CashFlowEntry(year: 3, amount: 6000),
  ];

  double? _fv;

  void _calculate() {
    final r = double.tryParse(_rCtrl.text);
    final T = int.tryParse(_tCtrl.text);
    if (r == null || T == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تأكد من إدخال معدل الخصم والسنة المستهدفة')));
      return;
    }

    final result = calculateFutureValueOfCashFlows(cashFlows: _entries, r: r / 100, T: T);
    setState(() => _fv = result.value('fv'));

    context.read<CalculationHistoryProvider>().add(
          HistoryEntry(
            calculatorName: 'صافي القيمة المستقبلية لتدفقات نقدية',
            summary: '${_entries.length} تدفقات، هدف سنة $T → FV ≈ ${_fv!.toStringAsFixed(2)}',
            savedAt: DateTime.now(),
          ),
        );
  }

  @override
  void dispose() {
    _rCtrl.dispose();
    _tCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صافي القيمة المستقبلية')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('جدول التدفقات النقدية', style: TextStyle(fontWeight: FontWeight.bold)),
            CashFlowTableInput(
              initialEntries: _entries,
              onChanged: (entries) => _entries = entries,
            ),
            const SizedBox(height: 8),
            LabeledInputField(
              label: 'معدل الخصم/العائد السنوي',
              controller: _rCtrl,
              suffixText: '%',
              isPercentage: true,
            ),
            LabeledInputField(label: 'السنة المستهدفة (T)', controller: _tCtrl),
            const SizedBox(height: 16),
            FilledButton(onPressed: _calculate, child: const Text('احسب')),
            const SizedBox(height: 20),
            if (_fv != null)
              ResultCard(primaryLabel: 'صافي القيمة المستقبلية (FV)', primaryValue: _fv!),
          ],
        ),
      ),
    );
  }
}
