import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fincalc_app/app.dart';
import 'package:fincalc_app/providers/calculation_history_provider.dart';

void main() {
  testWidgets('التطبيق يفتح على الشاشة الرئيسية بدون أخطاء', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CalculationHistoryProvider(),
        child: const FinCalcApp(),
      ),
    );
    await tester.pumpAndSettle();

    // نتحقق بس من عناصر مضمون ظهورها بدون أي سكرول: عنوان الشاشة،
    // وأول حاسبتين في القائمة. ده كافٍ كـ smoke test يتأكد إن التطبيق
    // بيبني شجرة الواجهة صح من غير أخطاء، من غير ما نعتمد على سلوك
    // السكرول اللي بيختلف حسب حجم شاشة بيئة الاختبار.
    expect(find.text('حاسبة مالية متطورة'), findsOneWidget);
    expect(find.text('الفائدة البسيطة والمركبة'), findsOneWidget);
    expect(find.text('صندوق استثمار'), findsOneWidget);
  });
}
