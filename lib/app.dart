import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class FinCalcApp extends StatelessWidget {
  const FinCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حاسبة مالية متطورة',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomeScreen(),
    );
  }
}
