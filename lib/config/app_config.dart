/// Environment configuration for the app
class AppConfig {
  // Debug mode
  static const bool debugMode = true;

  /// API configuration
  /// Use --dart-define=API_BASE_URL=`<url>` to override at compile time
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'https://script.google.com/macros/s/AKfycbwrebl_jdue1dUGTDk46o-nqyFn3aO5_CvtQz1ytuNIzGkWYcQfBist8z6TTbOmV_nf/exec',
  );

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
  static bool isProduction() => !debugMode;

  /// Check if running on development
  static bool isDevelopment() => debugMode;
}
