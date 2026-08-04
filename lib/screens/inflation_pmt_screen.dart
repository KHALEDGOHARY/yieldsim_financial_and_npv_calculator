import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/inflation_pmt.dart';
import '../models/calculation_result.dart';
import '../providers/calculation_history_provider.dart';
import '../widgets/labeled_input_field.dart';
import '../widgets/result_card.dart';

class InflationPmtScreen extends StatefulWidget {
  const InflationPmtScreen({super.key});

  @override
  State<InflationPmtScreen> createState() => _InflationPmtScreenState();
}

class _InflationPmtScreenState extends State<InflationPmtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fvCtrl = TextEditingController(text: '200000');
  final _rCtrl = TextEditingController(text: '10');
  final _iCtrl = TextEditingController(text: '5');
  final _nCtrl = TextEditingController(text: '12');
  final _tCtrl = TextEditingController(text: '10');
  InflationPmtMethod _method = InflationPmtMethod.fixedRealRate;

  CalculationResult? _result;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final result = calculateInflationAdjustedPMT(
      FVtarget: double.parse(_fvCtrl.text),
      r: double.parse(_rCtrl.text) / 100,
      i: double.parse(_iCtrl.text) / 100,
      n: double.parse(_nCtrl.text),
      t: double.parse(_tCtrl.text),
      method: _method,
    );

    setState(() => _result = result);

    context.read<CalculationHistoryProvider>().add(
          HistoryEntry(
            calculatorName: 'قسط تعويض التضخم',
            summary: 'الهدف=${_fvCtrl.text}, t=${_tCtrl.text} سنوات → '
                'r_real ≈ ${(result.value('rReal') * 100).toStringAsFixed(2)}%',
            savedAt: DateTime.now(),
          ),
        );
  }

  @override
  void dispose() {
    _fvCtrl.dispose();
    _rCtrl.dispose();
    _iCtrl.dispose();
    _nCtrl.dispose();
    _tCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قسط تعويض التضخم')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabeledInputField(label: 'الهدف المستقبلي (FV target)', controller: _fvCtrl),
              LabeledInputField(
                label: 'العائد الاسمي السنوي',
                controller: _rCtrl,
                suffixText: '%',
                isPercentage: true,
              ),
              LabeledInputField(
                label: 'معدل التضخم السنوي',
                controller: _iCtrl,
                suffixText: '%',
                isPercentage: true,
              ),
              LabeledInputField(label: 'عدد الدفعات/السنة (n)', controller: _nCtrl),
              LabeledInputField(label: 'المدة (سنوات)', controller: _tCtrl),
              const SizedBox(height: 8),
              SegmentedButton<InflationPmtMethod>(
                segments: const [
                  ButtonSegment(
                    value: InflationPmtMethod.fixedRealRate,
                    label: Text('قسط ثابت'),
                  ),
                  ButtonSegment(
                    value: InflationPmtMethod.growingWithInflation,
                    label: Text('قسط متصاعد'),
                  ),
                ],
                selected: {_method},
                onSelectionChanged: (s) => setState(() => _method = s.first),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _calculate, child: const Text('احسب')),
              const SizedBox(height: 20),
              if (_result != null)
                ResultCard(
                  primaryLabel: _method == InflationPmtMethod.fixedRealRate
                      ? 'القسط الثابت المطلوب'
                      : 'قسط السنة الأولى',
                  primaryValue: _method == InflationPmtMethod.fixedRealRate
                      ? _result!.value('pmt')
                      : _result!.value('firstYearPmt'),
                  secondaryRows: [
                    MapEntry('معدل العائد الحقيقي (r_real)', _result!.value('rReal') * 100),
                  ],
                  note: _result!.note,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
