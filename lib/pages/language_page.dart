import 'package:flutter/material.dart';

import 'details_page.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLang = 'en';

  final List<Map<String, String>> languages = const [
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

  String get title {
    if (selectedLang == 'hi') {
      return 'अपनी भाषा चुनें';
    }

    return 'Select your language';
  }

  String get subtitle {
    if (selectedLang == 'hi') {
      return 'आप आगे इस भाषा में जानकारी भरेंगे';
    }

    return 'You will fill details in this language';
  }

  String get continueText {
    if (selectedLang == 'hi') {
      return 'आगे बढ़ें';
    }

    return 'Continue';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: languages.length,
                  separatorBuilder: (_, __) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (_, index) {
                    final language = languages[index];
                    final code = language['code']!;
                    final name = language['name']!;
                    final selected = selectedLang == code;

                    return ListTile(
                      onTap: () {
                        setState(() {
                          selectedLang = code;
                        });
                      },
                      title: Text(name),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                            )
                          : null,
                      tileColor: selected
                          ? Colors.blue.withValues(alpha: 0.12)
                          : Colors.grey.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsPage(
                          initialLang: selectedLang,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    continueText,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
