/// كائن نتيجة موحّد تعيده كل دوال الحساب في lib/logic/.
///
/// [values] يحمل المخرجات الرقمية الأساسية، مفتاح كل قيمة هو تسمية عربية
/// قصيرة تُستخدم مباشرة كعنوان في ResultCard (مثال: "الفائدة" أو "FV").
///
/// [series] اختياري: صفوف جدول تراكمي (شهري/سنوي) تُستخدم لعرض جدول تفصيلي
/// أو لتغذية GrowthChart. كل صف هو Map بمفاتيح حرة (label, balance, ...).
class CalculationResult {
  final Map<String, double> values;
  final List<Map<String, dynamic>>? series;
  final String? note;

  const CalculationResult({
    required this.values,
    this.series,
    this.note,
  });

  double value(String key) => values[key] ?? 0;
}
