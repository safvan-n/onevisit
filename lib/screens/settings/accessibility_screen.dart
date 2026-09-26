import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../services/app_state.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Accessibility & Language'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.accentCardGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.accessibility_new_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Universal Citizen Access',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Designed for elderly, first-time smartphone users, and regional languages.',
                            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Language Section (Requirement 22: Malayalam, English, Hindi)
              const Text(
                'Regional Language / ഭാഷ / भाषा',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 12),
              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildLanguageTile(
                      context,
                      appState,
                      title: 'English',
                      subtitle: 'Default language',
                      lang: AppLanguage.english,
                    ),
                    const Divider(height: 1),
                    _buildLanguageTile(
                      context,
                      appState,
                      title: 'മലയാളം (Malayalam)',
                      subtitle: 'കേരള സർക്കാർ സേവനങ്ങൾ',
                      lang: AppLanguage.malayalam,
                    ),
                    const Divider(height: 1),
                    _buildLanguageTile(
                      context,
                      appState,
                      title: 'हिन्दी (Hindi)',
                      subtitle: 'राष्ट्रीय नागरिक पोर्टल',
                      lang: AppLanguage.hindi,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Visual & Assistive Options (Requirement 22)
              const Text(
                'Visual & Reading Aids',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 12),
              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Large Text Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Increases font sizes across forms and tokens for easier reading', style: TextStyle(fontSize: 12)),
                      value: appState.largeText,
                      activeThumbColor: AppColors.royalBlue,
                      onChanged: (val) => appState.toggleLargeText(val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('High Contrast Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Darker outlines and borders for enhanced visibility', style: TextStyle(fontSize: 12)),
                      value: appState.highContrast,
                      activeThumbColor: AppColors.royalBlue,
                      onChanged: (val) => appState.toggleHighContrast(val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Voice Guidance (Audio Alerts)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Reads out token updates and next counter announcements', style: TextStyle(fontSize: 12)),
                      value: appState.voiceGuidance,
                      activeThumbColor: AppColors.emeraldGreen,
                      onChanged: (val) {
                        appState.toggleVoiceGuidance(val);
                        if (val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('🔊 Voice guidance activated. Audio alerts enabled.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Screen Reader / Keyboard navigation notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softGrey,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline_rounded, color: AppColors.emeraldGreen, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This application complies with Government Accessibility Guidelines (WCAG 2.1 AA).',
                        style: TextStyle(fontSize: 12, color: AppColors.deepNavy),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    AppState appState, {
    required String title,
    required String subtitle,
    required AppLanguage lang,
  }) {
    final isSelected = appState.language == lang;

    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.royalBlue)
          : const Icon(Icons.circle_outlined, color: AppColors.border),
      onTap: () {
        appState.setLanguage(lang);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language switched to $title')),
        );
      },
    );
  }
}
