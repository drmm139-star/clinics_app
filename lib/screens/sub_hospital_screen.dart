import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'clinics_home_page.dart';
import 'about_hospital_page.dart';
import 'contact_us_page.dart';
import 'add_patient_page.dart';

class SubHospitalScreen extends StatelessWidget {
  final String hospitalName;

  const SubHospitalScreen({super.key, required this.hospitalName});

  @override
  Widget build(BuildContext context) {
    Future<void> openMap(BuildContext context) async {
      const lat = 29.0800117;
      const lng = 31.1060567;
      final messenger = ScaffoldMessenger.of(context);
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        messenger.showSnackBar(
          const SnackBar(content: Text('تعذر فتح الخريطة')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(hospitalName), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPatientPage()),
                );
              },
              child: const Text('الأقسام الداخلية'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClinicsHomePage()),
                );
              },
              child: const Text('العيادات الخارجية'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutHospitalPage()),
                );
              },
              child: const Text('عن مستشفيات جامعة بني سويف'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactUsPage()),
                );
              },
              child: const Text('اتصل بنا'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => openMap(context),
              child: const Text('الموقع على الخريطة'),
            ),
          ],
        ),
      ),
    );
  }
}
