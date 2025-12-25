import 'package:flutter/material.dart';

class AboutHospitalPage extends StatelessWidget {
  const AboutHospitalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عن المستشفيات')),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'مستشفيات جامعة بني سويف تقدم خدمات طبية شاملة لجميع المواطنين. '
          'يمكنك تعديل هذا النص لوضع التفاصيل الفعلية عن كل مستشفى.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
