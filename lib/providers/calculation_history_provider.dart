import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// سجل حسابات سابقة محفوظ محليًا (المرحلة 3 في خطة التنفيذ).
///
/// كل عنصر: اسم الحاسبة، ملخص نصي قصير للمدخلات/النتيجة، وتاريخ الحفظ.
class HistoryEntry {
  final String calculatorName;
  final String summary;
  final DateTime savedAt;

  HistoryEntry({
    required this.calculatorName,
    required this.summary,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'calculatorName': calculatorName,
        'summary': summary,
        'savedAt': savedAt.toIso8601String(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        calculatorName: json['calculatorName'] as String,
        summary: json['summary'] as String,
        savedAt: DateTime.parse(json['savedAt'] as String),
      );
}

class CalculationHistoryProvider extends ChangeNotifier {
  static const _storageKey = 'fincalc_history';
  final List<HistoryEntry> _entries = [];

  List<HistoryEntry> get entries => List.unmodifiable(_entries.reversed);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;
    final List decoded = jsonDecode(raw) as List;
    _entries
      ..clear()
      ..addAll(decoded.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>)));
    notifyListeners();
  }

  Future<void> add(HistoryEntry entry) async {
    _entries.add(entry);
    if (_entries.length > 100) {
      _entries.removeAt(0); // نحتفظ بآخر 100 عملية حساب بس
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    _entries.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
