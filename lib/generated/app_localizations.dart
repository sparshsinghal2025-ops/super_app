import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_brx.dart';
import 'app_localizations_doi.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_kok.dart';
import 'app_localizations_ks.dart';
import 'app_localizations_mai.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mni.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_sa.dart';
import 'app_localizations_sat.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('as'),
    Locale('bn'),
    Locale('brx'),
    Locale('doi'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('kok'),
    Locale('ks'),
    Locale('mai'),
    Locale('ml'),
    Locale('mni'),
    Locale('mr'),
    Locale('ne'),
    Locale('or'),
    Locale('pa'),
    Locale('sa'),
    Locale('sat'),
    Locale('sd'),
    Locale('ta'),
    Locale('te'),
    Locale('ur')
  ];

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome To'**
  String get welcomeTo;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your language'**
  String get selectLanguage;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @pleaseFillDetails.
  ///
  /// In en, this message translates to:
  /// **'Please fill in your details'**
  String get pleaseFillDetails;

  /// No description provided for @fillDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details'**
  String get fillDetailsSubtitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @alternatePhone.
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone Number'**
  String get alternatePhone;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @continueInQuestion.
  ///
  /// In en, this message translates to:
  /// **'Would you like to continue in:'**
  String get continueInQuestion;

  /// No description provided for @textMode.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get textMode;

  /// No description provided for @voiceMode.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voiceMode;

  /// No description provided for @aboutDeveloper.
  ///
  /// In en, this message translates to:
  /// **'About The Developer'**
  String get aboutDeveloper;

  /// No description provided for @chooseProblem.
  ///
  /// In en, this message translates to:
  /// **'Which problem would you like help with?'**
  String get chooseProblem;

  /// No description provided for @chooseProblemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select one problem to continue'**
  String get chooseProblemSubtitle;

  /// No description provided for @problemWalkability.
  ///
  /// In en, this message translates to:
  /// **'Walkability and blocked footpaths'**
  String get problemWalkability;

  /// No description provided for @problemWaste.
  ///
  /// In en, this message translates to:
  /// **'Waste management and disposal'**
  String get problemWaste;

  /// No description provided for @problemTraffic.
  ///
  /// In en, this message translates to:
  /// **'Traffic congestion and commuting'**
  String get problemTraffic;

  /// No description provided for @problemAir.
  ///
  /// In en, this message translates to:
  /// **'Air pollution and exposure'**
  String get problemAir;

  /// No description provided for @problemHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare access and cost transparency'**
  String get problemHealthcare;

  /// No description provided for @problemWater.
  ///
  /// In en, this message translates to:
  /// **'Water scarcity and quality'**
  String get problemWater;

  /// No description provided for @problemEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency help and personal safety'**
  String get problemEmergency;

  /// No description provided for @selectProblemError.
  ///
  /// In en, this message translates to:
  /// **'Please select a problem before continuing.'**
  String get selectProblemError;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Your selection has been saved.'**
  String get saved;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get phoneRequired;

  /// No description provided for @phoneLength.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits'**
  String get phoneLength;

  /// No description provided for @alternateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter alternate phone number'**
  String get alternateRequired;

  /// No description provided for @alternateLength.
  ///
  /// In en, this message translates to:
  /// **'Alternate number must be 10 digits'**
  String get alternateLength;

  /// No description provided for @alternateSame.
  ///
  /// In en, this message translates to:
  /// **'Alternate number must be different from your phone number'**
  String get alternateSame;

  /// No description provided for @alternateHelper.
  ///
  /// In en, this message translates to:
  /// **'of your friend or family member'**
  String get alternateHelper;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'10 digit number'**
  String get phoneHint;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save. Please try again.'**
  String get saveFailed;

  /// No description provided for @developerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Developer Name'**
  String get developerNameLabel;

  /// No description provided for @developerName.
  ///
  /// In en, this message translates to:
  /// **'Sparsh Singhal'**
  String get developerName;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'17 April 2007'**
  String get dateOfBirth;

  /// No description provided for @placeOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Place of Birth'**
  String get placeOfBirthLabel;

  /// No description provided for @placeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Ghaziabad, Uttar Pradesh'**
  String get placeOfBirth;

  /// No description provided for @schoolingLabel.
  ///
  /// In en, this message translates to:
  /// **'Schooling'**
  String get schoolingLabel;

  /// No description provided for @schooling.
  ///
  /// In en, this message translates to:
  /// **'K.D.B. Public School'**
  String get schooling;

  /// No description provided for @collegeLabel.
  ///
  /// In en, this message translates to:
  /// **'College'**
  String get collegeLabel;

  /// No description provided for @college.
  ///
  /// In en, this message translates to:
  /// **'Delhi Technological University'**
  String get college;

  /// No description provided for @branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchLabel;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Information Technology'**
  String get branch;

  /// No description provided for @developerThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using Super App.'**
  String get developerThankYou;

  /// No description provided for @voiceWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to voice mode. You can now use the app with voice.'**
  String get voiceWelcomeMessage;

  /// No description provided for @voiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice mode is active'**
  String get voiceTitle;

  /// No description provided for @voiceDescription.
  ///
  /// In en, this message translates to:
  /// **'The app will now use voice in your selected language.'**
  String get voiceDescription;

  /// No description provided for @speakAgain.
  ///
  /// In en, this message translates to:
  /// **'Speak Again'**
  String get speakAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'as',
        'bn',
        'brx',
        'doi',
        'en',
        'gu',
        'hi',
        'kn',
        'kok',
        'ks',
        'mai',
        'ml',
        'mni',
        'mr',
        'ne',
        'or',
        'pa',
        'sa',
        'sat',
        'sd',
        'ta',
        'te',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'brx':
      return AppLocalizationsBrx();
    case 'doi':
      return AppLocalizationsDoi();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'kok':
      return AppLocalizationsKok();
    case 'ks':
      return AppLocalizationsKs();
    case 'mai':
      return AppLocalizationsMai();
    case 'ml':
      return AppLocalizationsMl();
    case 'mni':
      return AppLocalizationsMni();
    case 'mr':
      return AppLocalizationsMr();
    case 'ne':
      return AppLocalizationsNe();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'sa':
      return AppLocalizationsSa();
    case 'sat':
      return AppLocalizationsSat();
    case 'sd':
      return AppLocalizationsSd();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
