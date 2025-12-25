// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

/// Uses a postMessage-based handshake to receive the token from the page JS.
Future<String?> getRecaptchaToken(String action) async {
  try {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final completer = Completer<String?>();

    late StreamSubscription sub;
    sub = html.window.onMessage.listen((event) {
      final data = event.data;
      if (data is Map && data['type'] == 'recaptcha' && data['id'] == id) {
        sub.cancel();
        completer.complete(data['token'] as String?);
      }
    });

    // Call the page helper which will postMessage back when token ready.
    try {
      js.context.callMethod('getRecaptchaTokenFor', [action, id]);
    } catch (e) {
      sub.cancel();
      return null;
    }

    // Timeout after 10s
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        try {
          sub.cancel();
        } catch (_) {}
        return null;
      },
    );
  } catch (e) {
    return null;
  }
}
