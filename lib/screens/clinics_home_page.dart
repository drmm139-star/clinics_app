import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/clinic_model.dart';
import 'clinic_details_page.dart';
import '../theme/theme_tokens.dart';
import '../config/app_config.dart';

class ClinicsHomePage extends StatefulWidget {
  const ClinicsHomePage({super.key});

  @override
  State<ClinicsHomePage> createState() => _ClinicsHomePageState();
}

class _ClinicsHomePageState extends State<ClinicsHomePage> {
  late Future<List<Clinic>> clinicsFuture;
  List<Clinic> displayedClinics = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    clinicsFuture = fetchClinics();
    clinicsFuture.then((data) {
      setState(() {
        displayedClinics = data;
      });
    });
  }

  Future<List<Clinic>> fetchClinics() async {
    final url = '${AppConfig.apiBaseUrl}?action=clinics';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> jsonList;

      if (decoded is Map<String, dynamic> && decoded.containsKey('value')) {
        jsonList = decoded['value'];
      } else if (decoded is List) {
        jsonList = decoded;
      } else {
        throw Exception('Unexpected response format from clinics API');
      }

      return jsonList
          .map((e) => Clinic.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('فشل في تحميل بيانات العيادات');
    }
  }

  void updateSearch(String query, List<Clinic> allClinics) {
    final filtered = allClinics.where((clinic) {
      return clinic.name.contains(query);
    }).toList();

    setState(() {
      searchQuery = query;
      displayedClinics = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('العيادات الخارجية'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Clinic>>(
          future: clinicsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('لا توجد عيادات مسجلة'));
            }

            final clinics = snapshot.data!;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = ThemeTokens.isWide(context);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'ابحث عن عيادة',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) => updateSearch(value, clinics),
                      ),
                    ),
                    Expanded(
                      child: isWide
                          ? GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 4,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: displayedClinics.length,
                              itemBuilder: (context, index) {
                                final clinic = displayedClinics[index];
                                return ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ClinicDetailsPage(clinic: clinic),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    clinic.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: isWide ? 18 : 16,
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              itemCount: displayedClinics.length,
                              itemBuilder: (context, index) {
                                final clinic = displayedClinics[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ClinicDetailsPage(
                                              clinic: clinic,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        clinic.name,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
