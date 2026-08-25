import 'package:flutter/material.dart';
import 'package:super_app/generated/app_localizations.dart';

import '../services/storage_service.dart';
import '../services/voice_service.dart';
import '../widgets/forward_only_page.dart';

class ProblemSelectionPage extends StatefulWidget {
  final String initialLanguage;
  final String interactionMode;
  final String? initialProblem;

  const ProblemSelectionPage({
    super.key,
    required this.initialLanguage,
    required this.interactionMode,
    this.initialProblem,
  });

  @override
  State<ProblemSelectionPage> createState() =>
      _ProblemSelectionPageState();
}

class _ProblemSelectionPageState
    extends State<ProblemSelectionPage> {
  late String selectedLanguage;

  String? selectedProblem;
  bool saving = false;
  bool justSaved = false;

  final StorageService storageService =
      StorageService();

  final VoiceService voiceService =
      VoiceService();

  final List<Map<String, String>> problems = const [
    {
      'code': 'walkability',
      'titleKey': 'problemWalkability',
    },
    {
      'code': 'waste',
      'titleKey': 'problemWaste',
    },
    {
      'code': 'traffic',
      'titleKey': 'problemTraffic',
    },
    {
      'code': 'air',
      'titleKey': 'problemAir',
    },
    {
      'code': 'healthcare',
      'titleKey': 'problemHealthcare',
    },
    {
      'code': 'water',
      'titleKey': 'problemWater',
    },
    {
      'code': 'emergency',
      'titleKey': 'problemEmergency',
    },
  ];

  bool get isVoiceMode {
    return widget.interactionMode == 'voice';
  }

  @override
  void initState() {
    super.initState();

    selectedLanguage = widget.initialLanguage;

    if (widget.initialProblem != null &&
        widget.initialProblem!.isNotEmpty) {
      selectedProblem = widget.initialProblem;
      justSaved = true;
    }

    if (isVoiceMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        speakProblemScreen();
      });
    }
  }

  AppLocalizations get strings {
    return AppLocalizations.of(context)!;
  }

  String problemTitle(String titleKey) {
    switch (titleKey) {
      case 'problemWalkability':
        return strings.problemWalkability;
      case 'problemWaste':
        return strings.problemWaste;
      case 'problemTraffic':
        return strings.problemTraffic;
      case 'problemAir':
        return strings.problemAir;
      case 'problemHealthcare':
        return strings.problemHealthcare;
      case 'problemWater':
        return strings.problemWater;
      case 'problemEmergency':
        return strings.problemEmergency;
      default:
        return titleKey;
    }
  }

  Future<void> speakProblemScreen() async {
    final speechParts = <String>[
      strings.chooseProblem,
      strings.chooseProblemSubtitle,
    ];

    for (final problem in problems) {
      speechParts.add(
        problemTitle(problem['titleKey']!),
      );
    }

    await voiceService.speak(
      text: speechParts.join('. '),
      languageCode: selectedLanguage,
    );
  }

  Future<void> selectProblem(
    String code,
    String title,
  ) async {
    setState(() {
      selectedProblem = code;
      justSaved = false;
    });

    if (isVoiceMode) {
      await voiceService.speak(
        text: title,
        languageCode: selectedLanguage,
      );
    }
  }

  Future<void> saveSelection() async {
    if (saving) return;

    if (selectedProblem == null) {
      final message = strings.selectProblemError;

      if (isVoiceMode) {
        await voiceService.speak(
          text: message,
          languageCode: selectedLanguage,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await storageService.saveSelectedProblem(
        selectedProblem!,
      );

      final savedMessage = strings.saved;

      if (isVoiceMode) {
        await voiceService.speak(
          text: savedMessage,
          languageCode: selectedLanguage,
        );
      }

      if (!mounted) return;

      setState(() {
        justSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(savedMessage),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'saveSelectedProblem failed: $error',
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

  Widget problemTile(
    Map<String, String> problem,
  ) {
    final code = problem['code']!;
    final titleKey = problem['titleKey']!;
    final title = problemTitle(titleKey);
    final isSelected = selectedProblem == code;

    return ListTile(
      onTap: saving
          ? null
          : () => selectProblem(code, title),
      title: Text(title),
      leading: const Icon(
        Icons.circle_outlined,
      ),
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
    );
  }

  @override
  void dispose() {
    voiceService.dispose();
    super.dispose();
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        localizedStrings.chooseProblem,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        localizedStrings
                            .chooseProblemSubtitle,
                        textAlign: TextAlign.center,
                      ),

                      if (justSaved) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: Text(
                            localizedStrings.saved,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      Expanded(
                        child: ListView.separated(
                          itemCount: problems.length,
                          separatorBuilder: (_, __) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemBuilder: (_, index) {
                            return problemTile(
                              problems[index],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: saving
                              ? null
                              : saveSelection,
                          child: saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}