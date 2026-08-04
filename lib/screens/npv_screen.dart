import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/npv.dart';
import '../models/cash_flow_entry.dart';
import '../providers/calculation_history_provider.dart';
import '../widgets/cash_flow_table_input.dart';
import '../widgets/labeled_input_field.dart';
import '../widgets/result_card.dart';

class NpvScreen extends StatefulWidget {
  const NpvScreen({super.key});

  @override
  State<NpvScreen> createState() => _NpvScreenState();
}

class _NpvScreenState extends State<NpvScreen> {
  final _initialCtrl = TextEditingController(text: '100000');
  final _rCtrl = TextEditingController(text: '12');
  List<CashFlowEntry> _entries = const [
    CashFlowEntry(year: 1, amount: 30000),
    CashFlowEntry(year: 2, amount: 40000),
    CashFlowEntry(year: 3, amount: 45000),
    CashFlowEntry(year: 4, amount: 35000),
  ];

  double? _npv;
  String? _note;

  void _calculate() {
    final initial = double.tryParse(_initialCtrl.text);
    final r = double.tryParse(_rCtrl.text);
    if (initial == null || r == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تأكد من إدخال الاستثمار المبدئي ومعدل الخصم')));
      return;
    }

    final result = calculateNPV(
      initialInvestment: initial,
      cashFlows: _entries,
      r: r / 100,
    );
    setState(() {
      _npv = result.value('npv');
      _note = result.note;
    });

    context.read<CalculationHistoryProvider>().add(
          HistoryEntry(
            calculatorName: 'صافي القيمة الحالية (NPV)',
            summary: 'استثمار=${_initialCtrl.text}, r=${_rCtrl.text}% → NPV ≈ ${_npv!.toStringAsFixed(2)}',
            savedAt: DateTime.now(),
          ),
        );
  }

  @override
  void dispose() {
    _initialCtrl.dispose();
    _rCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صافي القيمة الحالية (NPV)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LabeledInputField(label: 'الاستثمار المبدئي', controller: _initialCtrl),
            LabeledInputField(
              label: 'معدل الخصم',
              controller: _rCtrl,
              suffixText: '%',
              isPercentage: true,
            ),
            const SizedBox(height: 8),
            const Text('جدول التدفقات النقدية المتوقعة', style: TextStyle(fontWeight: FontWeight.bold)),
            CashFlowTableInput(
              initialEntries: _entries,
              onChanged: (entries) => _entries = entries,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _calculate, child: const Text('احسب')),
            const SizedBox(height: 20),
            if (_npv != null)
              ResultCard(
                primaryLabel: 'صافي القيمة الحالية (NPV)',
                primaryValue: _npv!,
                note: _note,
              ),
          ],
        ),
      ),
    );
  }
}
