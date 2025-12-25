import 'package:flutter/material.dart';
import '../models/clinic_model.dart';
import '../theme/theme_tokens.dart';

class ClinicDetailsPage extends StatelessWidget {
  final Clinic clinic;

  const ClinicDetailsPage({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    Widget detailRow(
      String label,
      String value, {
      IconData? icon,
      bool showDivider = true,
    }) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null)
                          Icon(
                            icon,
                            size: ThemeTokens.isWide(context) ? 20 : 18,
                          ),
                        if (icon != null) const SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: ThemeTokens.labelFontSize(context),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: ThemeTokens.valueFontSize(context),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showDivider) const Divider(height: 1),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(clinic.name), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            detailRow(
                              'أيام العمل:',
                              clinic.days.join(' - '),
                              icon: Icons.calendar_today,
                            ),
                            detailRow(
                              'المواعيد:',
                              '${clinic.timeFrom} إلى ${clinic.timeTo}',
                              icon: Icons.schedule,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            detailRow(
                              'الموقع:',
                              clinic.location,
                              icon: Icons.location_on,
                            ),
                            if (clinic.phone.isNotEmpty)
                              detailRow(
                                'التواصل:',
                                clinic.phone,
                                icon: Icons.phone,
                                showDivider: false,
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    detailRow(
                      'أيام العمل:',
                      clinic.days.join(' - '),
                      icon: Icons.calendar_today,
                    ),
                    detailRow(
                      'المواعيد:',
                      '${clinic.timeFrom} إلى ${clinic.timeTo}',
                      icon: Icons.schedule,
                    ),
                    detailRow(
                      'الموقع:',
                      clinic.location,
                      icon: Icons.location_on,
                    ),
                    if (clinic.phone.isNotEmpty) ...[
                      detailRow(
                        'التواصل:',
                        clinic.phone,
                        icon: Icons.phone,
                        showDivider: false,
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
