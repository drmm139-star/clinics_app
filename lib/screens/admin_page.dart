import 'package:flutter/material.dart';
import 'admin_staff_page.dart';
import 'admin_reports_page.dart';
import 'admin_settings_page.dart';
import '../theme/theme_tokens.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإدارة'), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = ThemeTokens.horizontalPadding(context);
            final isWide = ThemeTokens.isWide(context);
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: ThemeTokens.verticalPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'صفحة الإدارة — هنا يمكنك إدارة الموظفين، الاطلاع على التقارير، وتعديل إعدادات النظام.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isWide ? 18 : 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ThemeTokens.elevatedButtonStyle(context),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminStaffPage(),
                        ),
                      );
                    },
                    child: Text(
                      'إدارة الموظفين',
                      style: TextStyle(
                        fontSize: ThemeTokens.buttonFontSize(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ThemeTokens.elevatedButtonStyle(context),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminReportsPage(),
                        ),
                      );
                    },
                    child: Text(
                      'التقارير',
                      style: TextStyle(
                        fontSize: ThemeTokens.buttonFontSize(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ThemeTokens.elevatedButtonStyle(context),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminSettingsPage(),
                        ),
                      );
                    },
                    child: Text(
                      'إعدادات النظام',
                      style: TextStyle(
                        fontSize: ThemeTokens.buttonFontSize(context),
                      ),
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
