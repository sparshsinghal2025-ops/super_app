import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'language_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool checkingLocation = true;
  bool locationPermissionGranted = false;

  // The regional strings currently on screen (English + the detected
  // local language). Defaults to Hindi until/unless we resolve a state.
  _LocalStrings localStrings = _translations['hi']!;

  @override
  void initState() {
    super.initState();
    requestLocationAndDetectLanguage();
  }

  Future<void> requestLocationAndDetectLanguage() async {
    try {
      final locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!locationEnabled) {
        finishLocationCheck();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        locationPermissionGranted = true;

        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
          ),
        );

        final languageCode = await _resolveLanguageFromState(
          position.latitude,
          position.longitude,
        );

        if (languageCode != null && _translations.containsKey(languageCode)) {
          if (mounted) {
            setState(() {
              localStrings = _translations[languageCode]!;
            });
          }
        }
      }

      finishLocationCheck();
    } catch (error) {
      debugPrint('Location/language detection error: $error');
      finishLocationCheck();
    }
  }

  /// Reverse-geocodes coordinates to an Indian state/UT, then maps that
  /// state to the language it's most commonly associated with.
  Future<String?> _resolveLanguageFromState(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      final state = placemarks.first.administrativeArea?.trim();
      if (state == null || state.isEmpty) return null;

      return _stateToLanguage[state] ??
          _stateToLanguage[_normalize(state)];
    } catch (error) {
      debugPrint('Reverse geocoding error: $error');
      return null;
    }
  }

  String _normalize(String state) => state.trim();

  void finishLocationCheck() {
    if (!mounted) return;
    setState(() {
      checkingLocation = false;
    });
  }

  void openLanguagePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LanguagePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "Welcome To" / regional translation
                const Text(
                  'Welcome To',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localStrings.welcome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Super App's icon.
                _AppAvatar(
                  assetPath: 'assets/images/app_icon.png',
                  fallbackIcon: Icons.apps,
                  size: 120,
                  backgroundColor: Colors.blue.shade50,
                  borderColor: Colors.blue.shade200,
                  iconColor: Colors.blue,
                ),
                const SizedBox(height: 18),

                const Text(
                  'SUPER APP',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),

                // "Developed by" / regional translation
                const Text(
                  'Developed by',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  localStrings.developedBy,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                // Developer's photo.
                _AppAvatar(
                  assetPath: 'assets/images/developer_photo.png',
                  fallbackIcon: Icons.person,
                  size: 90,
                  backgroundColor: Colors.grey.shade200,
                  borderColor: Colors.grey.shade400,
                  iconColor: Colors.grey,
                ),
                const SizedBox(height: 12),

                const Text(
                  'Sparsh Singhal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 48),

                if (checkingLocation)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),

                // "Get Started" / regional translation
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: checkingLocation ? null : openLanguagePage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          localStrings.getStarted,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A circular avatar that shows an image asset if present, otherwise
/// falls back to a placeholder icon.
class _AppAvatar extends StatelessWidget {
  const _AppAvatar({
    required this.assetPath,
    required this.fallbackIcon,
    required this.size,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });

  final String assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          fallbackIcon,
          size: size * 0.48,
          color: iconColor,
        ),
      ),
    );
  }
}

/// The three translatable UI strings for a single language.
class _LocalStrings {
  const _LocalStrings({
    required this.welcome,
    required this.developedBy,
    required this.getStarted,
  });

  final String welcome;
  final String developedBy;
  final String getStarted;
}

/// Translations for "Welcome To" / "Developed by" / "Get Started" in the
/// major languages spoken across India. Extend this map to add more
/// languages or refine wording with a native speaker.
const Map<String, _LocalStrings> _translations = {
  'hi': _LocalStrings( // Hindi
    welcome: 'स्वागत है',
    developedBy: 'द्वारा विकसित',
    getStarted: 'शुरू करें',
  ),
  'bn': _LocalStrings( // Bengali
    welcome: 'স্বাগতম',
    developedBy: 'দ্বারা তৈরি',
    getStarted: 'শুরু করুন',
  ),
  'te': _LocalStrings( // Telugu
    welcome: 'స్వాగతం',
    developedBy: 'రూపొందించినవారు',
    getStarted: 'ప్రారంభించండి',
  ),
  'mr': _LocalStrings( // Marathi
    welcome: 'स्वागत आहे',
    developedBy: 'द्वारे विकसित',
    getStarted: 'सुरु करा',
  ),
  'ta': _LocalStrings( // Tamil
    welcome: 'வரவேற்கிறோம்',
    developedBy: 'உருவாக்கியவர்',
    getStarted: 'தொடங்கு',
  ),
  'ur': _LocalStrings( // Urdu
    welcome: 'خوش آمدید',
    developedBy: 'کی طرف سے تیار کردہ',
    getStarted: 'شروع کریں',
  ),
  'gu': _LocalStrings( // Gujarati
    welcome: 'સ્વાગત છે',
    developedBy: 'દ્વારા વિકસિત',
    getStarted: 'શરૂ કરો',
  ),
  'kn': _LocalStrings( // Kannada
    welcome: 'ಸ್ವಾಗತ',
    developedBy: 'ಅಭಿವೃದ್ಧಿಪಡಿಸಿದವರು',
    getStarted: 'ಪ್ರಾರಂಭಿಸಿ',
  ),
  'or': _LocalStrings( // Odia
    welcome: 'ସ୍ୱାଗତ',
    developedBy: 'ଦ୍ୱାରା ବିକଶିତ',
    getStarted: 'ଆରମ୍ଭ କରନ୍ତୁ',
  ),
  'ml': _LocalStrings( // Malayalam
    welcome: 'സ്വാഗതം',
    developedBy: 'വികസിപ്പിച്ചത്',
    getStarted: 'ആരംഭിക്കുക',
  ),
  'pa': _LocalStrings( // Punjabi
    welcome: 'ਜੀ ਆਇਆਂ ਨੂੰ',
    developedBy: 'ਦੁਆਰਾ ਵਿਕਸਿਤ',
    getStarted: 'ਸ਼ੁਰੂ ਕਰੋ',
  ),
  'as': _LocalStrings( // Assamese
    welcome: 'স্বাগতম',
    developedBy: 'দ্বাৰা বিকশিত',
    getStarted: 'আৰম্ভ কৰক',
  ),
  'ne': _LocalStrings( // Nepali (Sikkim)
    welcome: 'स्वागत छ',
    developedBy: 'द्वारा विकसित',
    getStarted: 'सुरु गर्नुहोस्',
  ),
};

/// Maps each Indian state/UT (as returned by reverse geocoding's
/// `administrativeArea`) to the language code most associated with it.
/// States not listed, or not in `_translations`, fall back to Hindi.
const Map<String, String> _stateToLanguage = {
  'Andhra Pradesh': 'te',
  'Telangana': 'te',
  'Tamil Nadu': 'ta',
  'Puducherry': 'ta',
  'Karnataka': 'kn',
  'Kerala': 'ml',
  'Lakshadweep': 'ml',
  'Maharashtra': 'mr',
  'Goa': 'mr',
  'Gujarat': 'gu',
  'Dadra and Nagar Haveli and Daman and Diu': 'gu',
  'West Bengal': 'bn',
  'Tripura': 'bn',
  'Odisha': 'or',
  'Punjab': 'pa',
  'Chandigarh': 'pa',
  'Assam': 'as',
  'Sikkim': 'ne',
  'Jammu and Kashmir': 'ur',
  'Ladakh': 'ur',
  'Bihar': 'hi',
  'Uttar Pradesh': 'hi',
  'Madhya Pradesh': 'hi',
  'Rajasthan': 'hi',
  'Haryana': 'hi',
  'Uttarakhand': 'hi',
  'Himachal Pradesh': 'hi',
  'Jharkhand': 'hi',
  'Chhattisgarh': 'hi',
  'Delhi': 'hi',
  'NCT of Delhi': 'hi',
  'Andaman and Nicobar Islands': 'hi',
};