import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clinic_model.dart';
import '../config/app_config.dart';

class ClinicService {
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
}
