import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../config/app_config.dart';
import '../services/recaptcha_stub.dart'
    if (dart.library.html) '../services/recaptcha_web.dart'
    as recaptcha;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() => _loading = true);

    try {
      // Get reCAPTCHA token on web (no-op on other platforms)
      String? recaptchaToken = await recaptcha.getRecaptchaToken('signup');

      // If we got a reCAPTCHA token, verify it on the server first with retries
      if (recaptchaToken != null) {
        final verified = await _verifyRecaptchaWithRetries(recaptchaToken);
        if (!verified) {
          // _verifyRecaptchaWithRetries shows dialogs as needed
          if (!mounted) return;
          setState(() => _loading = false);
          return;
        }
      }

      // Create user (pass token for logging/analytics on server side if desired)
      await AuthService.signUp(email, password, recaptchaToken: recaptchaToken);

      // Send verification email to the signed-in user
      await AuthService.sendEmailVerificationToCurrentUser();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال رابط التحقق إلى $email')),
      );

      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _verifyRecaptchaWithRetries(String token) async {
    const int maxAttempts = 3;
    int attempt = 0;
    int delayMs = 500;

    while (true) {
      attempt += 1;
      try {
        final serverUrl = AppConfig.apiBaseUrl;
        final uri = Uri.parse('$serverUrl/verify');
        final resp = await http
            .post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'event': {
                  'token': token,
                  'expectedAction': 'signup',
                  'siteKey': '6Lfv-zIsAAAAALTYYbPKlaV0K8m_RAighMf8WehK',
                },
              }),
            )
            .timeout(const Duration(seconds: 10));

        if (resp.statusCode != 200) {
          // Treat 5xx as transient, others as hard failures
          if (resp.statusCode >= 500 && attempt < maxAttempts) {
            await Future.delayed(Duration(milliseconds: delayMs));
            delayMs *= 2;
            continue;
          }
          // Non-retriable
          await _showVerificationFailedDialog(
            'فشل في التحقق من الخادم (رمز: ${resp.statusCode})',
          );
          return false;
        }

        final Map<String, dynamic> body = jsonDecode(resp.body);
        final passed = body['passed'] == true || body['success'] == true;
        if (passed) return true;

        // Verification returned but did not pass (e.g., low score)
        final reasons = (body['reasons'] is List)
            ? (body['reasons'] as List).join(', ')
            : '';
        await _showVerificationFailedDialog(
          'فشل التحقق من reCAPTCHA. ${reasons.isNotEmpty ? reasons : 'الدرجة منخفضة'}',
        );
        return false;
      } catch (e) {
        // Treat network/timeout as transient. Avoid importing `dart:io`
        // (which breaks web builds) by checking the exception text for
        // common socket/lookup failure messages.
        final errStr = e.toString();
        final isTransient =
            e is http.ClientException ||
            e is TimeoutException ||
            errStr.contains('SocketException') ||
            errStr.contains('Failed host lookup');

        if (isTransient && attempt < maxAttempts) {
          await Future.delayed(Duration(milliseconds: delayMs));
          delayMs *= 2;
          continue;
        }

        // Ask user to retry or cancel
        final retry = await _showRetryDialog(
          'خطأ في الاتصال بالخادم. هل تريد إعادة المحاولة؟',
        );
        if (retry) {
          attempt = 0;
          delayMs = 500;
          continue;
        }
        return false;
      }
    }
  }

  Future<bool> _showRetryDialog(String message) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  Future<void> _showVerificationFailedDialog(String message) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('فشل التحقق'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'الاسم'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'من فضلك أدخل الاسم' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'من فضلك أدخل البريد الإلكتروني'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'من فضلك أدخل كلمة المرور'
                      : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text('إنشاء حساب'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لديك حساب؟'),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text('تسجيل الدخول'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Image.asset('assets/logo.png', height: 150, width: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
