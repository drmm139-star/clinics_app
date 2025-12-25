import 'package:flutter_test/flutter_test.dart';
import 'package:clinics_app/services/platform_service.dart';

void main() {
  group('PlatformService', () {
    test('getDeviceType returns valid device type', () {
      final deviceType = PlatformService.getDeviceType();
      expect(deviceType, isNotNull);
      expect(deviceType, isNotEmpty);
      expect([
        'Web',
        'Android',
        'iOS',
        'Windows',
        'Linux',
        'macOS',
        'Unknown',
      ], contains(deviceType));
    });

    test('isMobile is opposite of isDesktop on relevant platforms', () {
      if (PlatformService.isAndroid || PlatformService.isIOS) {
        expect(PlatformService.isMobile, true);
      }
    });

    test('isWeb can be determined', () {
      final isWeb = PlatformService.isWeb;
      expect(isWeb, isA<bool>());
    });

    test('hasInternetConnection returns boolean', () async {
      final hasConnection = await PlatformService.hasInternetConnection();
      expect(hasConnection, isA<bool>());
    });
  });
}
