/// عنصر واحد في جدول التدفقات النقدية (سنة + مبلغ).
/// يُستخدم في حاسبتي "FV لتدفقات نقدية" و"NPV" عبر CashFlowTableInput.
class CashFlowEntry {
  final int year;
  final double amount;

  const CashFlowEntry({required this.year, required this.amount});

  CashFlowEntry copyWith({int? year, double? amount}) {
    return CashFlowEntry(
      year: year ?? this.year,
      amount: amount ?? this.amount,
    );
  }
}
