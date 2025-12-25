import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اتصل بنا')),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'للتواصل: 01210288371\nالبريد الإلكتروني: info@bnhospital.edu.eg',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
