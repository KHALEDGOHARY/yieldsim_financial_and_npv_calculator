import 'package:flutter/material.dart';

import '../models/cash_flow_entry.dart';

/// جدول إدخال تدفقات نقدية مشترك بين حاسبتي "FV تدفقات نقدية" و"NPV".
/// يقدر المستخدم يضيف/يمسح صف (سنة + مبلغ).
class CashFlowTableInput extends StatefulWidget {
  final List<CashFlowEntry> initialEntries;
  final ValueChanged<List<CashFlowEntry>> onChanged;

  const CashFlowTableInput({
    super.key,
    this.initialEntries = const [],
    required this.onChanged,
  });

  @override
  State<CashFlowTableInput> createState() => _CashFlowTableInputState();
}

class _CashFlowTableInputState extends State<CashFlowTableInput> {
  late List<CashFlowEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = List.of(widget.initialEntries);
    if (_entries.isEmpty) {
      _entries.add(const CashFlowEntry(year: 1, amount: 0));
    }
  }

  void _emit() => widget.onChanged(List.unmodifiable(_entries));

  void _addRow() {
    setState(() {
      final nextYear = _entries.isEmpty ? 1 : _entries.last.year + 1;
      _entries.add(CashFlowEntry(year: nextYear, amount: 0));
    });
    _emit();
  }

  void _removeRow(int index) {
    setState(() => _entries.removeAt(index));
    _emit();
  }

  void _updateRow(int index, {int? year, double? amount}) {
    setState(() {
      _entries[index] = _entries[index].copyWith(year: year, amount: amount);
    });
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < _entries.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: _entries[i].year.toString(),
                    decoration: const InputDecoration(labelText: 'السنة'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _updateRow(i, year: int.tryParse(v) ?? _entries[i].year),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: _entries[i].amount == 0 ? '' : _entries[i].amount.toString(),
                    decoration: const InputDecoration(labelText: 'المبلغ (CF)'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) =>
                        _updateRow(i, amount: double.tryParse(v) ?? _entries[i].amount),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _entries.length > 1 ? () => _removeRow(i) : null,
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addRow,
            icon: const Icon(Icons.add),
            label: const Text('إضافة سنة'),
          ),
        ),
      ],
    );
  }
}
