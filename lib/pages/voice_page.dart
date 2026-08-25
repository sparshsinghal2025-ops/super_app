import 'package:flutter/material.dart';
import 'package:super_app/generated/app_localizations.dart';

import '../services/voice_service.dart';
import '../widgets/forward_only_page.dart';
import 'problem_selection_page.dart';

class VoicePage extends StatefulWidget {
  final String language;

  const VoicePage({
    super.key,
    required this.language,
  });

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  final VoiceService voiceService = VoiceService();

  bool speaking = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      speakWelcomeMessage();
    });
  }

  Future<void> speakWelcomeMessage() async {
    if (speaking) return;

    final localizedStrings = AppLocalizations.of(context);

    if (localizedStrings == null) return;

    setState(() {
      speaking = true;
    });

    try {
      await voiceService.speak(
        text: localizedStrings.voiceWelcomeMessage,
        languageCode: widget.language,
      );
    } finally {
      if (mounted) {
        setState(() {
          speaking = false;
        });
      }
    }
  }

  void continueToProblemPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ProblemSelectionPage(
          initialLanguage: widget.language,
          interactionMode: 'voice',
        ),
      ),
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
      locale: Locale(widget.language),
      child: Builder(
        builder: (localizedContext) {
          final strings = AppLocalizations.of(localizedContext)!;

          return ForwardOnlyPage(
            child: Scaffold(
              appBar: AppBar(
                title: Text(strings.voiceMode),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.mic,
                        size: 92,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 26),
                      Text(
                        strings.voiceTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        strings.voiceDescription,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (speaking)
                        const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: speaking ? null : speakWelcomeMessage,
                          icon: const Icon(
                            Icons.volume_up,
                          ),
                          label: Text(
                            strings.speakAgain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: continueToProblemPage,
                          child: Text(
                            strings.continueText,
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
