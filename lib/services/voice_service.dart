// lib/services/voice_service.dart

import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final FlutterTts flutterTts = FlutterTts();

  static const Map<String, String> languageLocales = {
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
    required String languageCode,
  }) async {
    if (text.trim().isEmpty) return;

    try {
      final requestedLocale =
          languageLocales[languageCode] ?? 'en-IN';

      final availableLanguages =
          await flutterTts.getLanguages;

      final languages = availableLanguages
          .map((language) => language.toString())
          .toList();

      final exactMatch = languages.where(
        (language) =>
            language.toLowerCase() ==
            requestedLocale.toLowerCase(),
      );

      String selectedLocale;

      if (exactMatch.isNotEmpty) {
        selectedLocale = exactMatch.first;
      } else {
        selectedLocale = languages.firstWhere(
          (language) => language
              .toLowerCase()
              .startsWith(languageCode.toLowerCase()),
          orElse: () => 'en-IN',
        );
      }

      await flutterTts.setLanguage(selectedLocale);
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(1.0);

      await flutterTts.stop();
      await flutterTts.speak(text);
    } catch (_) {
      // Voice fallback is intentionally silent if TTS is unavailable.
    }
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> dispose() async {
    await flutterTts.stop();
  }
}