import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/compound_interest.dart';
import '../models/calculation_result.dart';
import '../providers/calculation_history_provider.dart';
import '../widgets/labeled_input_field.dart';
import '../widgets/result_card.dart';
import '../widgets/growth_chart.dart';

class CompoundInterestScreen extends StatefulWidget {
  const CompoundInterestScreen({super.key});

  @override
  State<CompoundInterestScreen> createState() => _CompoundInterestScreenState();
}

class _CompoundInterestScreenState extends State<CompoundInterestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pCtrl = TextEditingController(text: '10000');
  final _rCtrl = TextEditingController(text: '10');
  final _tCtrl = TextEditingController(text: '3');
  final _nCtrl = TextEditingController(text: '12');

  CalculationResult? _result;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final result = calculateSimpleAndCompoundInterest(
      P: double.parse(_pCtrl.text),
      r: double.parse(_rCtrl.text) / 100,
      t: double.parse(_tCtrl.text),
      n: double.parse(_nCtrl.text),
    );

    setState(() => _result = result);

    context.read<CalculationHistoryProvider>().add(
          HistoryEntry(
            calculatorName: 'الفائدة البسيطة والمركبة',
            summary: 'P=${_pCtrl.text}, r=${_rCtrl.text}%, t=${_tCtrl.text} سنوات → '
                'FV مركبة ≈ ${result.value('compoundFV').toStringAsFixed(2)}',
            savedAt: DateTime.now(),
          ),
        );
  }

  @override
  void dispose() {
    _pCtrl.dispose();
    _rCtrl.dispose();
    _tCtrl.dispose();
    _nCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الفائدة البسيطة والمركبة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabeledInputField(label: 'المبلغ الأساسي (P)', controller: _pCtrl),
              LabeledInputField(
                label: 'معدل الفائدة السنوي',
                controller: _rCtrl,
                suffixText: '%',
                isPercentage: true,
              ),
              LabeledInputField(label: 'المدة (سنوات)', controller: _tCtrl),
              LabeledInputField(
                label: 'عدد مرات الاحتساب في السنة (للمركبة)',
                controller: _nCtrl,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _calculate, child: const Text('احسب')),
              const SizedBox(height: 20),
              if (_result != null) ...[
                ResultCard(
                  primaryLabel: 'الفائدة المركبة (FV)',
                  primaryValue: _result!.value('compoundFV'),
                  secondaryRows: [
                    MapEntry('الفائدة المركبة (I)', _result!.value('compoundInterest')),
                    MapEntry('الفائدة البسيطة (FV)', _result!.value('simpleFV')),
                    MapEntry('الفائدة البسيطة (I)', _result!.value('simpleInterest')),
                  ],
                  note: 'قارن العمودين تحت عشان توضح قيمة الفائدة المركبة بصريًا.',
                ),
                const SizedBox(height: 16),
                ComparisonBarChart(
                  bars: [
                    MapEntry('بسيطة', _result!.value('simpleFV')),
                    MapEntry('مركبة', _result!.value('compoundFV')),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
