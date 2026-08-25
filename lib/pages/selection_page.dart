import 'package:flutter/material.dart';
import 'package:super_app/generated/app_localizations.dart';

import '../services/storage_service.dart';
import '../widgets/forward_only_page.dart';
import 'about_developer_page.dart';
import 'problem_selection_page.dart';
import 'voice_page.dart';

class SelectionPage extends StatefulWidget {
  final String initialLanguage;
  final String initialMode;
  final String? initialProblem;
  final ValueChanged<String>? onLanguageChanged;

  const SelectionPage({
    super.key,
    required this.initialLanguage,
    this.initialMode = 'text',
    this.initialProblem,
    this.onLanguageChanged,
  });

  @override
  State<SelectionPage> createState() =>
      _SelectionPageState();
}

class _SelectionPageState
    extends State<SelectionPage> {
  late String selectedLanguage;

  late String selectedMode;

  bool saving = false;

  final StorageService storageService =
      StorageService();

  @override
  void initState() {
    super.initState();

    selectedLanguage = widget.initialLanguage;
    selectedMode = widget.initialMode;
  }

  AppLocalizations get strings {
    return AppLocalizations.of(context)!;
  }

  Future<void> continueToNextPage() async {
    if (saving) return;

    setState(() {
      saving = true;
    });

    try {
      await storageService.saveInteractionMode(
        selectedMode,
      );

      if (!mounted) return;

      if (selectedMode == 'voice') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VoicePage(
              language: selectedLanguage,
            ),
          ),
        );

        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProblemSelectionPage(
            initialLanguage: selectedLanguage,
            interactionMode: selectedMode,
            initialProblem: widget.initialProblem,
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'saveInteractionMode failed: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.saveFailed),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  void changeLanguage(String value) {
    setState(() {
      selectedLanguage = value;
    });

    widget.onLanguageChanged?.call(value);
  }

  void openAboutDeveloper() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AboutDeveloperPage(
          language: selectedLanguage,
        ),
      ),
    );
  }

  Widget modeTile({
    required String mode,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedMode == mode;

    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      child: ListTile(
        onTap: saving
            ? null
            : () {
                setState(() {
                  selectedMode = mode;
                });
              },
        leading: Icon(icon),
        title: Text(title),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Colors.blue,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        tileColor: isSelected
            ? Colors.blue.withValues(alpha: 0.12)
            : Colors.grey.withValues(alpha: 0.10),
      ),
    );
  }

  Widget languageDropdown() {
    return Align(
      alignment: Alignment.topRight,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          items: const [
            DropdownMenuItem(
              value: 'en',
              child: Text('EN'),
            ),
            DropdownMenuItem(
              value: 'hi',
              child: Text('हिन्दी'),
            ),
            DropdownMenuItem(
              value: 'bn',
              child: Text('বাংলা'),
            ),
            DropdownMenuItem(
              value: 'mr',
              child: Text('मराठी'),
            ),
            DropdownMenuItem(
              value: 'te',
              child: Text('తెలుగు'),
            ),
            DropdownMenuItem(
              value: 'ta',
              child: Text('தமிழ்'),
            ),
            DropdownMenuItem(
              value: 'gu',
              child: Text('ગુજરાતી'),
            ),
            DropdownMenuItem(
              value: 'ur',
              child: Text('اردو'),
            ),
            DropdownMenuItem(
              value: 'kn',
              child: Text('ಕನ್ನಡ'),
            ),
            DropdownMenuItem(
              value: 'or',
              child: Text('ଓଡ଼ିଆ'),
            ),
            DropdownMenuItem(
              value: 'ml',
              child: Text('മലയാളം'),
            ),
            DropdownMenuItem(
              value: 'pa',
              child: Text('ਪੰਜਾਬੀ'),
            ),
            DropdownMenuItem(
              value: 'as',
              child: Text('অসমীয়া'),
            ),
            DropdownMenuItem(
              value: 'ne',
              child: Text('नेपाली'),
            ),
            DropdownMenuItem(
              value: 'sd',
              child: Text('سنڌي'),
            ),
            DropdownMenuItem(
              value: 'kok',
              child: Text('कोंकणी'),
            ),
            DropdownMenuItem(
              value: 'doi',
              child: Text('डोगरी'),
            ),
            DropdownMenuItem(
              value: 'mni',
              child: Text('Meitei'),
            ),
            DropdownMenuItem(
              value: 'brx',
              child: Text('बड़ो'),
            ),
            DropdownMenuItem(
              value: 'ks',
              child: Text('कश्मीरी'),
            ),
            DropdownMenuItem(
              value: 'sat',
              child: Text('संथाली'),
            ),
            DropdownMenuItem(
              value: 'sa',
              child: Text('संस्कृतम्'),
            ),
            DropdownMenuItem(
              value: 'mai',
              child: Text('मैथिली'),
            ),
          ],
          onChanged: saving
              ? null
              : (value) {
                  if (value == null) return;
                  changeLanguage(value);
                },
        ),
      ),
    );
  }

  Widget aboutDeveloperBox() {
    return Semantics(
      button: true,
      label: strings.aboutDeveloper,
      child: InkWell(
        onTap: saving ? null : openAboutDeveloper,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.withValues(
                alpha: 0.30,
              ),
            ),
          ),
          child: Text(
            strings.aboutDeveloper,
            style: const TextStyle(
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: Locale(selectedLanguage),
      child: Builder(
        builder: (context) {
          final localizedStrings =
              AppLocalizations.of(context)!;

          return ForwardOnlyPage(
            child: Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          languageDropdown(),

                          const SizedBox(height: 24),

                          Text(
                            localizedStrings
                                .continueInQuestion,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 28),

                          modeTile(
                            mode: 'text',
                            icon: Icons.text_fields,
                            title: localizedStrings
                                .textMode,
                          ),

                          const SizedBox(height: 14),

                          modeTile(
                            mode: 'voice',
                            icon: Icons.mic,
                            title: localizedStrings
                                .voiceMode,
                          ),

                          const Spacer(),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: saving
                                  ? null
                                  : continueToNextPage,
                              child: saving
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      localizedStrings
                                          .continueText,
                                    ),
                            ),
                          ),

                          const SizedBox(height: 48),
                        ],
                      ),
                    ),

                    Positioned(
                      left: 20,
                      bottom: 12,
                      child: aboutDeveloperBox(),
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