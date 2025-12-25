import 'dart:convert';
import 'package:http/http.dart' as http;

class WhatsAppService {
  /// Send WhatsApp message via the server `/send-whatsapp` endpoint.
  /// Uses compile-time defines `SENDSMS_USER` and `SENDSMS_PASS` for Basic auth when set.
  static Future<void> sendWhatsApp(
    String baseUrl,
    String phone,
    String message,
  ) async {
    final user = const String.fromEnvironment('SENDSMS_USER', defaultValue: '');
    final pass = const String.fromEnvironment('SENDSMS_PASS', defaultValue: '');
    final uri = Uri.parse('$baseUrl/send-whatsapp');
    final headers = {'Content-Type': 'application/json'};
    if (user.isNotEmpty && pass.isNotEmpty) {
      final auth = base64.encode(utf8.encode('$user:$pass'));
      headers['Authorization'] = 'Basic $auth';
    }

    final client = http.Client();
    try {
      final resp = await client
          .post(
            uri,
            headers: headers,
            body: jsonEncode({'phone': phone, 'message': message}),
          )
          .timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) {
        throw Exception('WhatsApp server error: ${resp.statusCode}');
      }
    } finally {
      client.close();
    }
  }
}
