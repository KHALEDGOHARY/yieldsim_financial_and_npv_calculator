import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/calculation_history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<CalculationHistoryProvider>();
    final dateFormat = DateFormat('yyyy/MM/dd - hh:mm a', 'ar');

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحسابات'),
        actions: [
          if (history.entries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'مسح السجل',
              onPressed: () => context.read<CalculationHistoryProvider>().clear(),
            ),
        ],
      ),
      body: history.entries.isEmpty
          ? const Center(child: Text('لا يوجد حسابات محفوظة بعد'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.entries.length,
              itemBuilder: (context, index) {
                final entry = history.entries[index];
                return Card(
                  child: ListTile(
                    title: Text(entry.calculatorName),
                    subtitle: Text(entry.summary),
                    trailing: Text(
                      dateFormat.format(entry.savedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
