import 'package:flutter/material.dart';

class Breakpoints {
  static const double tablet = 600.0;
  static const double desktop = 1000.0;
}

class ThemeTokens {
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.tablet;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.desktop;
  static bool isWide(BuildContext context) => isDesktop(context);

  static double horizontalPadding(BuildContext context) =>
      isWide(context) ? 48.0 : (isTablet(context) ? 32.0 : 20.0);
  static double verticalPadding(BuildContext context) =>
      isWide(context) ? 32.0 : (isTablet(context) ? 24.0 : 20.0);

  static double buttonFontSize(BuildContext context) =>
      isWide(context) ? 20.0 : (isTablet(context) ? 18.0 : 16.0);
  static double clinicButtonFontSize(BuildContext context) =>
      isWide(context) ? 18.0 : (isTablet(context) ? 17.0 : 16.0);
  static double labelFontSize(BuildContext context) =>
      isWide(context) ? 19.0 : (isTablet(context) ? 18.0 : 17.0);
  static double valueFontSize(BuildContext context) =>
      isWide(context) ? 18.0 : (isTablet(context) ? 17.0 : 16.0);

  static double cardElevation(BuildContext context) =>
      isWide(context) ? 4.0 : 1.0;

  static ButtonStyle elevatedButtonStyle(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: isWide(context) ? 6.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isWide(context) ? 14.0 : 6.0),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isWide(context) ? 18.0 : 12.0,
          horizontal: 16.0,
        ),
        textStyle: TextStyle(fontSize: buttonFontSize(context)),
      );

  static ButtonStyle textButtonStyle(BuildContext context) =>
      TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        textStyle: TextStyle(fontSize: buttonFontSize(context)),
      );

  // Use this for clinic list buttons
  static ButtonStyle clinicButtonStyle(BuildContext context) =>
      ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isWide(context) ? 10 : 8),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isWide(context) ? 16 : 12,
          horizontal: 12,
        ),
        textStyle: TextStyle(
          fontSize: clinicButtonFontSize(context),
          fontWeight: FontWeight.w700,
        ),
      );
}
