import 'package:flutter/material.dart';

import 'compound_interest_screen.dart';
import 'investment_fund_screen.dart';
import 'inflation_pmt_screen.dart';
import 'present_value_screen.dart';
import 'fv_cashflows_screen.dart';
import 'npv_screen.dart';
import 'history_screen.dart';

class _CalculatorItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;

  const _CalculatorItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<_CalculatorItem> _items = [
    _CalculatorItem(
      title: 'الفائدة البسيطة والمركبة',
      subtitle: 'قارن بين الفائدتين واحسب القيمة المستقبلية',
      icon: Icons.percent,
      builder: (_) => const CompoundInterestScreen(),
    ),
    _CalculatorItem(
      title: 'صندوق استثمار',
      subtitle: 'دفعة مقدمة + دفعات دورية، إعادة استثمار أو سحب',
      icon: Icons.savings,
      builder: (_) => const InvestmentFundScreen(),
    ),
    _CalculatorItem(
      title: 'قسط تعويض التضخم',
      subtitle: 'احسب القسط اللازم للوصول لهدف يقاوم التضخم',
      icon: Icons.trending_up,
      builder: (_) => const InflationPmtScreen(),
    ),
    _CalculatorItem(
      title: 'القيمة الحالية (PV)',
      subtitle: 'لمبلغ واحد مستقبلي أو لسلسلة دفعات',
      icon: Icons.request_quote,
      builder: (_) => const PresentValueScreen(),
    ),
    _CalculatorItem(
      title: 'صافي القيمة المستقبلية',
      subtitle: 'لتدفقات نقدية غير متساوية عبر السنين',
      icon: Icons.timeline,
      builder: (_) => const FvCashflowsScreen(),
    ),
    _CalculatorItem(
      title: 'صافي القيمة الحالية (NPV)',
      subtitle: 'تقييم جدوى مشروع أو استثمار',
      icon: Icons.assessment,
      builder: (_) => const NpvScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة مالية متطورة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'سجل الحسابات',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: Icon(item.icon),
              ),
              title: Text(item.title, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: item.builder),
              ),
            ),
          );
        },
      ),
    );
  }
}
