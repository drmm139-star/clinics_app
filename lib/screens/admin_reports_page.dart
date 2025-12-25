import 'package:flutter/material.dart';
import '../theme/theme_tokens.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقارير الإدارة')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 600 ? 48.0 : 16.0;
            final isWide = constraints.maxWidth > 800;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: ThemeTokens.cardElevation(context),
                    child: ListTile(
                      title: Text(
                        'تقرير الحضور',
                        style: TextStyle(fontSize: isWide ? 18 : 16),
                      ),
                      subtitle: Text(
                        'ملخص حضور الموظفين خلال الشهر',
                        style: TextStyle(fontSize: isWide ? 16 : 14),
                      ),
                      trailing: ElevatedButton(
                        style: ThemeTokens.elevatedButtonStyle(context),
                        onPressed: () {},
                        child: Text(
                          'توليد',
                          style: TextStyle(fontSize: isWide ? 16 : 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: ThemeTokens.cardElevation(context),
                    child: ListTile(
                      title: Text(
                        'تقرير الأداء',
                        style: TextStyle(fontSize: isWide ? 18 : 16),
                      ),
                      subtitle: Text(
                        'تقارير أداء الأطباء والطاقم',
                        style: TextStyle(fontSize: isWide ? 16 : 14),
                      ),
                      trailing: ElevatedButton(
                        style: ThemeTokens.elevatedButtonStyle(context),
                        onPressed: () {},
                        child: Text(
                          'عرض',
                          style: TextStyle(fontSize: isWide ? 16 : 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: ThemeTokens.cardElevation(context),
                    child: ListTile(
                      title: Text(
                        'تقرير الشكاوى',
                        style: TextStyle(fontSize: isWide ? 18 : 16),
                      ),
                      subtitle: Text(
                        'ملخص الشكاوى والمتابعة',
                        style: TextStyle(fontSize: isWide ? 16 : 14),
                      ),
                      trailing: ElevatedButton(
                        style: ThemeTokens.elevatedButtonStyle(context),
                        onPressed: () {},
                        child: Text(
                          'عرض',
                          style: TextStyle(fontSize: isWide ? 16 : 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ThemeTokens.elevatedButtonStyle(context),
                    onPressed: () {},
                    child: Text(
                      'تصدير كل التقارير',
                      style: TextStyle(fontSize: isWide ? 16 : 14),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
