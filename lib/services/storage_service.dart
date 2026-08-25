import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyName = 'user_name';
  static const String keyPhone = 'user_phone';
  static const String keyAltPhone = 'user_alt_phone';
  static const String keyLang = 'ui_lang';
  static const String keyCompleted = 'onboarding_completed';
  static const String keyMode = 'interaction_mode';
  static const String keyProblem = 'selected_problem';

  static const String defaultLang = 'en';
  static const String defaultMode = 'text';

  static const Set<String> supportedLanguages = {
    'en',
    'hi',
    'bn',
    'mr',
    'te',
    'ta',
    'gu',
    'ur',
    'kn',
    'or',
    'ml',
    'pa',
    'as',
    'ne',
    'sd',
    'kok',
    'doi',
    'mni',
    'brx',
    'ks',
    'sat',
    'sa',
    'mai',
  };

  static const Set<String> supportedModes = {
    'text',
    'voice',
  };

  static const Set<String> supportedProblems = {
    'walkability',
    'waste',
    'traffic',
    'air',
    'healthcare',
    'water',
    'emergency',
  };

  String cleanLanguage(String language) {
    if (supportedLanguages.contains(language)) {
      return language;
    }

    return defaultLang;
  }

  String cleanMode(String mode) {
    if (supportedModes.contains(mode)) {
      return mode;
    }

    return defaultMode;
  }

  String cleanProblem(String problem) {
    if (supportedProblems.contains(problem)) {
      return problem;
    }

    return '';
  }

  Future<void> saveOnboarding({
    required String name,
    required String phone,
    required String altPhone,
    String? lang,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      keyName,
      name.trim(),
    );

    await preferences.setString(
      keyPhone,
      phone.trim(),
    );

    await preferences.setString(
      keyAltPhone,
      altPhone.trim(),
    );

    if (lang != null) {
      await preferences.setString(
        keyLang,
        cleanLanguage(lang),
      );
    }

    await preferences.setBool(
      keyCompleted,
      true,
    );
  }

  Future<bool> isOnboardingCompleted() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getBool(keyCompleted) ?? false;
  }

  Future<Map<String, String>> getOnboardingData() async {
    final preferences = await SharedPreferences.getInstance();

    final savedProblem = preferences.getString(keyProblem) ?? '';

    return {
      'name': preferences.getString(keyName) ?? '',
      'phone': preferences.getString(keyPhone) ?? '',
      'altPhone': preferences.getString(keyAltPhone) ?? '',
      'lang': cleanLanguage(
        preferences.getString(keyLang) ?? defaultLang,
      ),
      'interactionMode': cleanMode(
        preferences.getString(keyMode) ?? defaultMode,
      ),
      'selectedProblem': cleanProblem(savedProblem),
    };
  }

  Future<void> saveLanguage(String language) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      keyLang,
      cleanLanguage(language),
    );
  }

  Future<String> getLanguage() async {
    final preferences = await SharedPreferences.getInstance();

    return cleanLanguage(
      preferences.getString(keyLang) ?? defaultLang,
    );
  }

  Future<void> saveInteractionMode(String mode) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      keyMode,
      cleanMode(mode),
    );
  }

  Future<String> getInteractionMode() async {
    final preferences = await SharedPreferences.getInstance();

    return cleanMode(
      preferences.getString(keyMode) ?? defaultMode,
    );
  }

  Future<void> saveSelectedProblem(
    String problem,
  ) async {
    final cleanedProblem = cleanProblem(problem);

    if (cleanedProblem.isEmpty) {
      throw ArgumentError(
        'Unsupported problem: $problem',
      );
    }

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      keyProblem,
      cleanedProblem,
    );
  }

  Future<String?> getSelectedProblem() async {
    final preferences = await SharedPreferences.getInstance();

    final problem = preferences.getString(keyProblem);

    if (problem == null || !supportedProblems.contains(problem)) {
      return null;
    }

    return problem;
  }

  Future<void> clearOnboarding() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(keyName);
    await preferences.remove(keyPhone);
    await preferences.remove(keyAltPhone);
    await preferences.remove(keyCompleted);
    await preferences.remove(keyMode);
    await preferences.remove(keyProblem);
  }

  Future<void> clearAll() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.clear();
  }

  Future<Map<String, String>> getUserData() async {
    final preferences = await SharedPreferences.getInstance();
    return {
      'name': preferences.getString('user_name') ?? '',
      'phone': preferences.getString('user_phone') ?? '',
      'altPhone': preferences.getString('user_alt_phone') ?? '',
      'lang': preferences.getString('user_lang') ?? 'en',
    };
  }
}
