import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// بطاقة عرض نتيجة موحّدة الشكل تُستخدم في كل شاشات الحاسبات الست.
///
/// [primaryLabel]/[primaryValue]: القيمة الأساسية بخط كبير.
/// [secondaryRows]: تفاصيل ثانوية (زوج تسمية/قيمة) تُعرض تحتها.
/// [note]: ملاحظة نصية اختيارية (مثل "مجدٍ اقتصاديًا ✓").
class ResultCard extends StatelessWidget {
  final String primaryLabel;
  final double primaryValue;
  final String currencySymbol;
  final List<MapEntry<String, double>> secondaryRows;
  final String? note;

  const ResultCard({
    super.key,
    required this.primaryLabel,
    required this.primaryValue,
    this.currencySymbol = 'د.ل',
    this.secondaryRows = const [],
    this.note,
  });

  String _format(double value) {
    final formatter = NumberFormat('#,##0.00', 'ar');
    return '${formatter.format(value)} $currencySymbol';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(primaryLabel, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              _format(primaryValue),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            if (secondaryRows.isNotEmpty) ...[
              const Divider(height: 24),
              ...secondaryRows.map(
                (row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(row.key, style: theme.textTheme.bodyMedium),
                      Text(_format(row.value), style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
            if (note != null) ...[
              const SizedBox(height: 12),
              Text(
                note!,
                style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
