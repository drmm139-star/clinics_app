import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/password_reset_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ClinicsApp());
}

class ClinicsApp extends StatelessWidget {
  const ClinicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مستشفيات جامعة بني سويف',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/password_reset': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          String? email;
          if (args is String) email = args;
          return PasswordResetScreen(initialEmail: email);
        },
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
