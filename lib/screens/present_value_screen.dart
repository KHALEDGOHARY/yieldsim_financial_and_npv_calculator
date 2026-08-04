import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/present_value.dart';
import '../providers/calculation_history_provider.dart';
import '../widgets/labeled_input_field.dart';
import '../widgets/result_card.dart';

enum _PvMode { single, annuity }

class PresentValueScreen extends StatefulWidget {
  const PresentValueScreen({super.key});

  @override
  State<PresentValueScreen> createState() => _PresentValueScreenState();
}

class _PresentValueScreenState extends State<PresentValueScreen> {
  final _formKey = GlobalKey<FormState>();
  _PvMode _mode = _PvMode.single;

  final _fvCtrl = TextEditingController(text: '50000');
  final _rSingleCtrl = TextEditingController(text: '8');
  final _tSingleCtrl = TextEditingController(text: '5');

  final _pmtCtrl = TextEditingController(text: '1000');
  final _rAnnuityCtrl = TextEditingController(text: '6');
  final _nAnnuityCtrl = TextEditingController(text: '12');
  final _tAnnuityCtrl = TextEditingController(text: '5');

  double? _pv;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final result = _mode == _PvMode.single
        ? calculatePresentValue(
            fv: double.parse(_fvCtrl.text),
            r: double.parse(_rSingleCtrl.text) / 100,
            t: double.parse(_tSingleCtrl.text),
          )
        : calculatePresentValueAnnuity(
            pmt: double.parse(_pmtCtrl.text),
            r: double.parse(_rAnnuityCtrl.text) / 100,
            n: double.parse(_nAnnuityCtrl.text),
            t: double.parse(_tAnnuityCtrl.text),
          );

    setState(() => _pv = result.value('pv'));

    context.read<CalculationHistoryProvider>().add(
          HistoryEntry(
            calculatorName: 'القيمة الحالية (PV)',
            summary: '${_mode == _PvMode.single ? "مبلغ واحد" : "سلسلة دفعات"} → '
                'PV ≈ ${_pv!.toStringAsFixed(2)}',
            savedAt: DateTime.now(),
          ),
        );
  }

  @override
  void dispose() {
    _fvCtrl.dispose();
    _rSingleCtrl.dispose();
    _tSingleCtrl.dispose();
    _pmtCtrl.dispose();
    _rAnnuityCtrl.dispose();
    _nAnnuityCtrl.dispose();
    _tAnnuityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القيمة الحالية (PV)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<_PvMode>(
                segments: const [
                  ButtonSegment(value: _PvMode.single, label: Text('مبلغ واحد')),
                  ButtonSegment(value: _PvMode.annuity, label: Text('سلسلة دفعات')),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() {
                  _mode = s.first;
                  _pv = null;
                }),
              ),
              const SizedBox(height: 12),
              if (_mode == _PvMode.single) ...[
                LabeledInputField(label: 'مبلغ مستقبلي (FV)', controller: _fvCtrl),
                LabeledInputField(
                  label: 'معدل الخصم السنوي',
                  controller: _rSingleCtrl,
                  suffixText: '%',
                  isPercentage: true,
                ),
                LabeledInputField(label: 'المدة (سنوات)', controller: _tSingleCtrl),
              ] else ...[
                LabeledInputField(label: 'الدفعة الدورية (PMT)', controller: _pmtCtrl),
                LabeledInputField(
                  label: 'معدل الخصم السنوي',
                  controller: _rAnnuityCtrl,
                  suffixText: '%',
                  isPercentage: true,
                ),
                LabeledInputField(label: 'عدد الدفعات/السنة (n)', controller: _nAnnuityCtrl),
                LabeledInputField(label: 'المدة (سنوات)', controller: _tAnnuityCtrl),
              ],
              const SizedBox(height: 16),
              FilledButton(onPressed: _calculate, child: const Text('احسب')),
              const SizedBox(height: 20),
              if (_pv != null)
                ResultCard(primaryLabel: 'القيمة الحالية (PV)', primaryValue: _pv!),
            ],
          ),
        ),
      ),
    );
  }
}
