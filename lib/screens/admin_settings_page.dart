import 'package:flutter/material.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _notifications = true;
  bool _maintenanceMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الإدارة')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListView(
            padding: const EdgeInsets.only(top: 8),
            children: [
              SwitchListTile(
                title: Text(
                  'تنبيهات النظام',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 800 ? 16 : 14,
                  ),
                ),
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
              SwitchListTile(
                title: Text(
                  'وضع الصيانة',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 800 ? 16 : 14,
                  ),
                ),
                value: _maintenanceMode,
                onChanged: (v) => setState(() => _maintenanceMode = v),
              ),
              ListTile(
                title: const Text('تحديث إعدادات النظام'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('حفظ'),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('تغيير كلمة المرور'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('تحديث'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
