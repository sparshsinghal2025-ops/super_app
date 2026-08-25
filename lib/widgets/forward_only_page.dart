import 'package:flutter/material.dart';
import 'package:super_app/generated/app_localizations.dart';
/// Wraps onboarding pages. Previously, pressing back
/// would force-navigate to HomePage. Since HomePage is
/// no longer part of the flow, back now behaves normally:
/// it pops to the previous onboarding screen (or exits
/// the app if there's nowhere left to go).
class ForwardOnlyPage extends StatelessWidget {
  final Widget child;

  const ForwardOnlyPage({
    super.key,
    required this.child,
  });

  // Open your lib/main.dart or application root configuration file:
@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Super App',
    
    // 1. Inject the root delegates right here globally:
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    
    // 2. Point to your application onboarding entry point:
    home: const DetailsPage(initialLang: 'en'), 
  );
}

}