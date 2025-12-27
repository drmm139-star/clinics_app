/// Environment configuration for the app
// Shared script endpoint used by Google Apps Script backends.
// Update this value to the project's actual endpoint if needed.
const String apiUrl =
    'https://script.google.com/macros/s/AKfycbyCfgCWOO_hX342KGTsCYChfiLuxqj2kQwh1s56hNahzxrQJh8KEiQVp2Q18LxaOyyt/exec';

class AppConfig {
  // Debug mode
  static const bool debugMode = true;

  // API configuration
  // Read API base URL from --dart-define (compile-time) or default to localhost
  // Usage: flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
  // Shared script endpoint used by Google Apps Script backends.
  // Update this value to the project's actual endpoint if needed.
  static const String apiUrl =
      'https://script.google.com/macros/s/AKfycbyCfgCWOO_hX342KGTsCYChfiLuxqj2kQwh1s56hNahzxrQJh8KEiQVp2Q18LxaOyyt/exec';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Firebase configuration
  static const bool enableFirebaseLogging = debugMode;

  // UI configuration
  static const bool enableAnimations = true;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // App name
  static const String appName = 'مستشفيات جامعة بني سويف';
  static const String appShortName = 'UniHosp';

  // Version
  static const String appVersion = '1.0.0';

  /// Check if running on production
  static bool isProduction() {
    return !debugMode;
  }

  /// Check if running on development
  static bool isDevelopment() {
    return debugMode;
  }
}
