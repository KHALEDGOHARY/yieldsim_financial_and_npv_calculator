import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/investment_fund.dart';
import '../models/calculation_result.dart';
import '../providers/calculation_history_provider.dart';
import '../widgets/labeled_input_field.dart';
import '../widgets/result_card.dart';
import '../widgets/growth_chart.dart';

class InvestmentFundScreen extends StatefulWidget {
  const InvestmentFundScreen({super.key});

  @override
  State<InvestmentFundScreen> createState() => _InvestmentFundScreenState();
}

class _InvestmentFundScreenState extends State<InvestmentFundScreen> {
  final _formKey = GlobalKey<FormState>();
  final _p0Ctrl = TextEditingController(text: '50000');
  final _pmtCtrl = TextEditingController(text: '500');
  final _rCtrl = TextEditingController(text: '8');
  final _nCtrl = TextEditingController(text: '12');
  final _tCtrl = TextEditingController(text: '5');
  InvestmentMode _mode = InvestmentMode.reinvest;

  CalculationResult? _result;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final result = simulateInvestmentFund(
      P0: double.parse(_p0Ctrl.text),
      PMT: double.parse(_pmtCtrl.text),
      r: double.parse(_rCtrl.text) / 100,
      n: double.parse(_nCtrl.text),
      t: double.parse(_tCtrl.text),
      mode: _mode,
    );

    setState(() => _result = result);

    final summaryValue = _mode == InvestmentMode.reinvest
        ? 'FV ≈ ${result.value('finalValue').toStringAsFixed(2)}'
        : 'رأس المال ≈ ${result.value('remainingCapital').toStringAsFixed(2)}, '
            'عوائد ≈ ${result.value('totalReturnsWithdrawn').toStringAsFixed(2)}';

    context.read<CalculationHistoryProvider>().add(
          HistoryEntry(
            calculatorName: 'صندوق استثمار',
            summary: 'P0=${_p0Ctrl.text}, PMT=${_pmtCtrl.text}, t=${_tCtrl.text} سنوات → $summaryValue',
            savedAt: DateTime.now(),
          ),
        );
  }

  @override
  void dispose() {
    _p0Ctrl.dispose();
    _pmtCtrl.dispose();
    _rCtrl.dispose();
    _nCtrl.dispose();
    _tCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صندوق استثمار')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabeledInputField(label: 'الدفعة المقدمة (P₀)', controller: _p0Ctrl),
              LabeledInputField(label: 'الدفعة الدورية (PMT شهريًا)', controller: _pmtCtrl),
              LabeledInputField(
                label: 'معدل العائد السنوي المتوقع',
                controller: _rCtrl,
                suffixText: '%',
                isPercentage: true,
              ),
              LabeledInputField(label: 'عدد الدفعات/السنة (n)', controller: _nCtrl),
              LabeledInputField(label: 'مدة الاحتفاظ (سنوات)', controller: _tCtrl),
              const SizedBox(height: 8),
              SegmentedButton<InvestmentMode>(
                segments: const [
                  ButtonSegment(
                    value: InvestmentMode.reinvest,
                    label: Text('إعادة استثمار'),
                  ),
                  ButtonSegment(
                    value: InvestmentMode.withdraw,
                    label: Text('سحب دوري'),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _calculate, child: const Text('احسب')),
              const SizedBox(height: 20),
              if (_result != null) _buildResult(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    final result = _result!;
    final spots = <FlSpot>[
      for (final row in result.series!)
        FlSpot((row['month'] as int).toDouble(), (row['balance'] as double)),
    ];

    if (_mode == InvestmentMode.reinvest) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResultCard(
            primaryLabel: 'القيمة النهائية (FV)',
            primaryValue: result.value('finalValue'),
            secondaryRows: [
              MapEntry('إجمالي المُودَع', result.value('totalContributed')),
              MapEntry('صافي النمو', result.value('totalGrowth')),
            ],
            note: result.note,
          ),
          const SizedBox(height: 16),
          GrowthChart(spots: spots, xLabel: 'الشهر', yLabel: 'الرصيد'),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResultCard(
            primaryLabel: 'رصيد رأس المال المتبقي',
            primaryValue: result.value('remainingCapital'),
            secondaryRows: [
              MapEntry('إجمالي العوائد المسحوبة', result.value('totalReturnsWithdrawn')),
            ],
            note: result.note,
          ),
          const SizedBox(height: 16),
          GrowthChart(spots: spots, xLabel: 'الشهر', yLabel: 'رأس المال'),
        ],
      );
    }
  }
}
