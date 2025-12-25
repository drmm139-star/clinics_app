import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _loading = true);

    try {
      // Real Firebase sign-in
      final cred = await AuthService.signIn(email, password);

      final user = cred.user;
      if (user != null && !user.emailVerified) {
        // If email not verified, ask to resend verification
        if (!mounted) return;
        // showDialog only after ensuring mounted
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            title: const Text('البريد لم يتم التفعيل'),
            content: const Text(
              'يجب تفعيل البريد الإلكتروني قبل تسجيل الدخول. هل تريد إعادة إرسال رابط التفعيل؟',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  try {
                    await AuthService.sendEmailVerificationToCurrentUser();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إرسال رابط التحقق للمستخدم'),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Text('إعادة إرسال'),
              ),
              TextButton(
                onPressed: () {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text('إغلاق'),
              ),
            ],
          ),
        );
        return;
      }

      // Success: navigate to dashboard
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      // Show login failed dialog with reset option
      _showLoginFailedDialog(context, email, message: e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showLoginFailedDialog(
    BuildContext ctx,
    String email, {
    String? message,
  }) {
    showDialog<void>(
      context: ctx,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('فشل تسجيل الدخول'),
          content: Text(
            message ?? 'بيانات الدخول غير صحيحة. هل نسيت كلمة المرور؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Open full password reset page with pre-filled email
                Navigator.pushNamed(ctx, '/password_reset', arguments: email);
              },
              child: const Text('نسيت كلمة المرور'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'أهلا وسهلا بك فى\nمستشفيات جامعة بني سويف',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Image.asset('assets/logo.png', height: 200, width: 200),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
                      : const Text('تسجيل الدخول', textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ليس لديك حساب؟'),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text('إنشاء حساب'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
