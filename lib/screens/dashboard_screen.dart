import 'package:flutter/material.dart';
import 'sub_hospital_screen.dart';
import 'admin_page.dart';
import '../theme/theme_tokens.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مستشفيات جامعة بني سويف'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = ThemeTokens.horizontalPadding(context);
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: ThemeTokens.verticalPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SubHospitalScreen(
                            hospitalName: 'المستشفى الرئيسي',
                          ),
                        ),
                      );
                    },
                    style: ThemeTokens.elevatedButtonStyle(context),
                    child: Text(
                      'المستشفى الرئيسي',
                      style: TextStyle(
                        fontSize: ThemeTokens.buttonFontSize(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ThemeTokens.elevatedButtonStyle(context),
                    child: Text(
                      'المركز الطبي التخصصي',
                      style: TextStyle(
                        fontSize: ThemeTokens.buttonFontSize(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ThemeTokens.elevatedButtonStyle(context),
                    child: Text(
                      'مستشفى الأورام',
                      style: TextStyle(
                        fontSize: ThemeTokens.buttonFontSize(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ThemeTokens.elevatedButtonStyle(context),
                    child: Text(
                      'مركز التأهيل لذوي الاحتياجات',
                      style: TextStyle(
                        fontSize: ThemeTokens.buttonFontSize(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminPage()),
                      );
                    },
                    style: ThemeTokens.elevatedButtonStyle(context),
                    child: Text(
                      'الإدارة',
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
