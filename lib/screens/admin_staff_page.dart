import 'package:flutter/material.dart';
import '../theme/theme_tokens.dart';

class AdminStaffPage extends StatefulWidget {
  const AdminStaffPage({super.key});

  @override
  State<AdminStaffPage> createState() => _AdminStaffPageState();
}

class _AdminStaffPageState extends State<AdminStaffPage> {
  final List<Map<String, String>> _staff = [
    {'name': 'د. أحمد علي', 'role': 'مدير المستشفى'},
    {'name': 'محمد', 'role': 'مدير شؤون الموظفين'},
  ];

  void _addStaff(String name, String role) {
    setState(() {
      _staff.add({'name': name, 'role': role});
    });
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة موظف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'الاسم'),
            ),
            TextField(
              controller: roleCtrl,
              decoration: const InputDecoration(labelText: 'الوظيفة'),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ThemeTokens.textButtonStyle(context),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: TextStyle(fontSize: ThemeTokens.buttonFontSize(context)),
            ),
          ),
          ElevatedButton(
            style: ThemeTokens.elevatedButtonStyle(context),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                _addStaff(nameCtrl.text.trim(), roleCtrl.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'إضافة',
              style: TextStyle(fontSize: ThemeTokens.buttonFontSize(context)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = ThemeTokens.isWide(context);
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الموظفين')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: _staff.length,
            separatorBuilder: (context, _) => const Divider(),
            itemBuilder: (context, i) {
              final s = _staff[i];
              return ListTile(
                leading: CircleAvatar(
                  radius: isWide ? 22 : null,
                  backgroundColor: isWide
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                  child: Text(s['name']![0]),
                ),
                title: Text(
                  s['name']!,
                  style: TextStyle(fontSize: isWide ? 18 : 16),
                ),
                subtitle: Text(
                  s['role'] ?? '',
                  style: TextStyle(fontSize: isWide ? 16 : 14),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() => _staff.removeAt(i));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: isWide
          ? FloatingActionButton.extended(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add),
              label: const Text('إضافة موظف'),
            )
          : FloatingActionButton(
              onPressed: _showAddDialog,
              tooltip: 'إضافة موظف',
              child: const Icon(Icons.add),
            ),
    );
  }
}
