import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_app/generated/app_localizations.dart';

import '../services/storage_service.dart';
import '../widgets/forward_only_page.dart';
import 'selection_page.dart';

class DetailsPage extends StatefulWidget {
  final String initialLang;
  final ValueChanged<String>? onLanguageChanged;

  const DetailsPage({
    super.key,
    required this.initialLang,
    this.onLanguageChanged,
  });

  @override
  State<DetailsPage> createState() =>
      _DetailsPageState();
}

class _DetailsPageState
    extends State<DetailsPage> {
  final formKey = GlobalKey<FormState>();

  final StorageService storageService =
      StorageService();

  late String uiLang;
  bool isSaving = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final alternatePhoneController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    uiLang = widget.initialLang;
  }

  String? validatePhone(
    String? value, {
    required String emptyMessage,
    required String lengthMessage,
  }) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return emptyMessage;
    }

    if (phone.length != 10) {
      return lengthMessage;
    }

    return null;
  }

  Future<void> saveAndContinue() async {
    if (isSaving) return;

    final strings =
        AppLocalizations.of(context)!;

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await storageService.saveOnboarding(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        altPhone:
            alternatePhoneController.text.trim(),
        lang: uiLang,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SelectionPage(
            initialLanguage: uiLang,
            initialMode: 'default_mode',       // Replace with your variable or fallback string
            initialProblem: 'default_problem', // Replace with your variable or fallback string
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'saveOnboarding failed: $error',
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
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    alternatePhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: Locale(uiLang),
      child: Builder(
        builder: (context) {
          final strings =
              AppLocalizations.of(context)!;

          return ForwardOnlyPage(
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        Align(
                          alignment:
                              Alignment.topRight,
                          child:
                              DropdownButtonHideUnderline(
                            child:
                                DropdownButton<String>(
                              value: uiLang,
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
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }

                                setState(() {
                                  uiLang = value;
                                });

                                widget.onLanguageChanged
                                    ?.call(value);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          strings.pleaseFillDetails,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          strings.fillDetailsSubtitle,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 28),

                        TextFormField(
                          controller: nameController,
                          autofocus: true,
                          textCapitalization:
                              TextCapitalization.words,
                          textInputAction:
                              TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: strings.name,
                            prefixIcon: const Icon(
                              Icons.person_outline,
                            ),
                            border:
                                const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return strings.nameRequired;
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: phoneController,
                          keyboardType:
                              TextInputType.phone,
                          textInputAction:
                              TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                            LengthLimitingTextInputFormatter(
                              10,
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText:
                                strings.phoneNumber,
                            hintText: strings.phoneHint,
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                            ),
                            border:
                                const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            return validatePhone(
                              value,
                              emptyMessage:
                                  strings.phoneRequired,
                              lengthMessage:
                                  strings.phoneLength,
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller:
                              alternatePhoneController,
                          keyboardType:
                              TextInputType.phone,
                          textInputAction:
                              TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                            LengthLimitingTextInputFormatter(
                              10,
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText:
                                strings.alternatePhone,
                            helperText:
                                strings.alternateHelper,
                            prefixIcon: const Icon(
                              Icons.phone_android_outlined,
                            ),
                            border:
                                const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final error =
                                validatePhone(
                              value,
                              emptyMessage:
                                  strings
                                      .alternateRequired,
                              lengthMessage:
                                  strings
                                      .alternateLength,
                            );

                            if (error != null) {
                              return error;
                            }

                            final alternate =
                                value?.trim() ?? '';
                            final primary =
                                phoneController.text
                                    .trim();

                            if (alternate == primary &&
                                primary.isNotEmpty) {
                              return strings.alternateSame;
                            }

                            return null;
                          },
                          onChanged: (_) {
                            if (phoneController
                                .text
                                .isNotEmpty) {
                              formKey.currentState
                                  ?.validate();
                            }
                          },
                          onFieldSubmitted: (_) {
                            saveAndContinue();
                          },
                        ),

                        const SizedBox(height: 36),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isSaving
                                ? null
                                : saveAndContinue,
                            child: isSaving
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
                                    strings.continueText,
                                  ),
                          ),
                        ),
                      ],
                    ),
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