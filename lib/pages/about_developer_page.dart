import 'package:flutter/material.dart';
import 'package:super_app/generated/app_localizations.dart';

class AboutDeveloperPage extends StatelessWidget {
  final String language;

  const AboutDeveloperPage({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: Locale(language),
      child: Builder(
        builder: (context) {
          final strings =
              AppLocalizations.of(context)!;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                strings.aboutDeveloper,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/developer_photo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return Icon(
                            Icons.person,
                            size: 58,
                            color: Colors.grey.shade600,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      strings.developerName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),

                    const SizedBox(height: 28),

                    DeveloperDetailRow(
                      icon: Icons.person_outline,
                      label: strings.developerNameLabel,
                      value: strings.developerName,
                    ),

                    DeveloperDetailRow(
                      icon: Icons.cake_outlined,
                      label: strings.dateOfBirthLabel,
                      value: strings.dateOfBirth,
                    ),

                    DeveloperDetailRow(
                      icon: Icons.location_on_outlined,
                      label: strings.placeOfBirthLabel,
                      value: strings.placeOfBirth,
                    ),

                    DeveloperDetailRow(
                      icon: Icons.school_outlined,
                      label: strings.schoolingLabel,
                      value: strings.schooling,
                    ),

                    DeveloperDetailRow(
                      icon: Icons.account_balance_outlined,
                      label: strings.collegeLabel,
                      value: strings.college,
                    ),

                    DeveloperDetailRow(
                      icon: Icons.computer_outlined,
                      label: strings.branchLabel,
                      value: strings.branch,
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    const SizedBox(height: 16),

                    Text(
                      strings.developerThankYou,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DeveloperDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DeveloperDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.withValues(
            alpha: 0.22,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.blue,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}