import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/app_localizations.dart';
import 'pages/details_page.dart';
import 'pages/selection_page.dart';
import 'services/storage_service.dart';
import 'widgets/forward_only_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SuperApp());
}

class SuperApp extends StatefulWidget {
  const SuperApp({super.key});

  @override
  State<SuperApp> createState() => _SuperAppState();
}

class _SuperAppState extends State<SuperApp> {
  Locale _locale = const Locale('en');

  Future<void> changeLanguage(String languageCode) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setString(
      'selected_language',
      languageCode,
    );

    if (!mounted) return;

    setState(() {
      _locale = Locale(languageCode);
    });
  }

  Future<void> loadSavedLanguage() async {
    final preferences =
        await SharedPreferences.getInstance();

    final savedLanguage =
        preferences.getString('selected_language');

    if (savedLanguage == null || savedLanguage.isEmpty) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _locale = Locale(savedLanguage);
    });
  }

  @override
  void initState() {
    super.initState();
    loadSavedLanguage();
  }

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

class AppStarter extends StatefulWidget {
  final ValueChanged<String> onLanguageChanged;

  const AppStarter({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<AppStarter> createState() => _AppStarterState();
}

class _AppStarterState extends State<AppStarter> {
  final StorageService storageService =
      StorageService();

  bool loading = true;
  bool completed = false;

  String language = 'en';
  String mode = 'text';
  String? problem;

  @override
  void initState() {
    super.initState();
    checkApplication();
  }

  Future<void> checkApplication() async {
    completed =
        await storageService.isOnboardingCompleted();

    if (completed) {
      final data =
          await storageService.getUserData();

      language = data['lang'] ?? 'en';
      mode = data['mode'] ?? 'text';

      final savedProblem = data['problem'] ?? '';
      problem = savedProblem.isEmpty
          ? null
          : savedProblem;

      widget.onLanguageChanged(language);
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (completed) {
      return SelectionPage(
        initialLanguage: language,
        initialMode: mode,
        initialProblem: problem ?? 'default_problem',
      );
    }

    return WelcomePage(
      onLanguageChanged: widget.onLanguageChanged,
    );
  }
}

class WelcomePage extends StatefulWidget {
  final ValueChanged<String> onLanguageChanged;

  const WelcomePage({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<WelcomePage> createState() =>
      _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    detectLocation();
  }

  Future<void> detectLocation() async {
    try {
      final enabled =
          await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        finishLoading();
        return;
      }

      var permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        finishLoading();
        return;
      }

      await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      finishLoading();
    } catch (_) {
      finishLoading();
    }
  }

  void finishLoading() {
    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings =
        AppLocalizations.of(context)!;

    return ForwardOnlyPage(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.apps,
                  size: 90,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                Text(
                  strings.welcomeTo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'SUPER APP',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LanguagePage(
                                  onLanguageChanged:
                                      widget
                                          .onLanguageChanged,
                                ),
                              ),
                            );
                          },
                    child: Text(strings.getStarted),
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

class LanguagePage extends StatefulWidget {
  final ValueChanged<String> onLanguageChanged;

  const LanguagePage({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<LanguagePage> createState() =>
      _LanguagePageState();
}

class _LanguagePageState
    extends State<LanguagePage> {
  String selectedLanguage = 'en';

  final languages = const [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिन्दी'},
    {'code': 'bn', 'name': 'বাংলা'},
    {'code': 'mr', 'name': 'मराठी'},
    {'code': 'te', 'name': 'తెలుగు'},
    {'code': 'ta', 'name': 'தமிழ்'},
    {'code': 'gu', 'name': 'ગુજરાતી'},
    {'code': 'ur', 'name': 'اردو'},
    {'code': 'kn', 'name': 'ಕನ್ನಡ'},
    {'code': 'or', 'name': 'ଓଡ଼ିଆ'},
    {'code': 'ml', 'name': 'മലയാളം'},
    {'code': 'pa', 'name': 'ਪੰਜਾਬੀ'},
    {'code': 'as', 'name': 'অসমীয়া'},
    {'code': 'ne', 'name': 'नेपाली'},
    {'code': 'sd', 'name': 'سنڌي'},
    {'code': 'kok', 'name': 'कोंकणी'},
    {'code': 'doi', 'name': 'डोगरी'},
    {'code': 'mni', 'name': 'Meitei'},
    {'code': 'brx', 'name': 'बड़ो'},
    {'code': 'ks', 'name': 'कश्मीरी'},
    {'code': 'sat', 'name': 'संथाली'},
    {'code': 'sa', 'name': 'संस्कृतम्'},
    {'code': 'mai', 'name': 'मैथिली'},
  ];

  @override
  Widget build(BuildContext context) {
    final strings =
        AppLocalizations.of(context)!;

    return ForwardOnlyPage(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  strings.selectLanguage,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: languages.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 8);
                    },
                    itemBuilder: (_, index) {
                      final item = languages[index];
                      final code = item['code']!;
                      final name = item['name']!;
                      final selected =
                          selectedLanguage == code;

                      return ListTile(
                        onTap: () async {
                          setState(() {
                            selectedLanguage = code;
                          });

                            widget
                              .onLanguageChanged(code);
                        },
                        title: Text(name),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              )
                            : null,
                        tileColor: selected
                            ? Colors.blue.withValues(
                                alpha: 0.12,
                              )
                            : Colors.grey.withValues(
                                alpha: 0.10,
                              ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsPage(
                            initialLang:
                                selectedLanguage,
                            onLanguageChanged:
                                widget
                                    .onLanguageChanged,
                          ),
                        ),
                      );
                    },
                    child: Text(strings.next),
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

class VoiceService {
  final FlutterTts tts = FlutterTts();

  static const Map<String, String> locales = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'bn': 'bn-IN',
    'mr': 'mr-IN',
    'te': 'te-IN',
    'ta': 'ta-IN',
    'gu': 'gu-IN',
    'ur': 'ur-IN',
    'kn': 'kn-IN',
    'or': 'or-IN',
    'ml': 'ml-IN',
    'pa': 'pa-IN',
    'as': 'as-IN',
    'ne': 'ne-NP',
    'sd': 'sd-IN',
    'kok': 'kok-IN',
    'doi': 'doi-IN',
    'mni': 'mni-IN',
    'brx': 'brx-IN',
    'ks': 'ks-IN',
    'sat': 'sat-IN',
    'sa': 'sa-IN',
    'mai': 'mai-IN',
  };

  Future<void> speak({
    required String text,
    required String language,
  }) async {
    if (text.trim().isEmpty) return;

    try {
      final requestedLocale =
          locales[language] ?? 'en-IN';

      final rawLanguages = await tts.getLanguages;

      final availableLanguages = rawLanguages
          .map((item) => item.toString())
          .toList();

      final exact = availableLanguages.where(
        (item) =>
            item.toLowerCase() ==
            requestedLocale.toLowerCase(),
      );

      final selectedLocale = exact.isNotEmpty
          ? exact.first
          : availableLanguages.firstWhere(
              (item) => item
                  .toLowerCase()
                  .startsWith(language.toLowerCase()),
              orElse: () => 'en-IN',
            );

      await tts.setLanguage(selectedLocale);
      await tts.setSpeechRate(0.45);
      await tts.setPitch(1.0);
      await tts.setVolume(1.0);
      await tts.stop();
      await tts.speak(text);
    } catch (_) {}
  }

  Future<void> dispose() async {
    await tts.stop();
  }
}