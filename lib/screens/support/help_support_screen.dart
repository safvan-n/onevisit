import 'package:flutter/material.dart';
import '../../core/theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'q': 'How does OneVisit digital token booking work?',
      'a': 'You select your desired service and preferred office center, pick an available slot, and receive a digital token code (e.g. A-102). You can monitor queue movement live from home and walk in only when your turn approaches.',
    },
    {
      'q': 'What if I arrive late after my token is called?',
      'a': 'Staff counters hold called tokens for 15 minutes before skipping. If you miss your window, simply report to the desk staff and they will reactivate your token in the queue without needing a fresh application.',
    },
    {
      'q': 'How does the OCR scanner extract my details?',
      'a': 'Our integrated Google ML Kit OCR scans uploaded images or camera captures of official cards (Aadhaar, PAN, DL) and extracts your name, DOB, ID number, and address with over 98% accuracy.',
    },
    {
      'q': 'Can I apply for government services for my family members?',
      'a': 'Yes. In the Guided Form Step 1, you can specify family member details and attach their documents from your Document Vault.',
    },
  ];

  final List<Map<String, String>> _chatMessages = [
    {
      'sender': 'bot',
      'text': 'Namaskaram! I am your OneVisit Citizen Virtual Assistant. How can I assist your visit today?'
    },
  ];
  final TextEditingController _chatController = TextEditingController();

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add({'sender': 'user', 'text': text});
      _chatController.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      String reply = 'Thank you for contacting OneVisit. ';
      final lower = text.toLowerCase();
      if (lower.contains('token') || lower.contains('queue')) {
        reply += 'You can track active tokens in the "My Tokens" tab with live counter updates and arrival time alerts.';
      } else if (lower.contains('ration') || lower.contains('card')) {
        reply += 'Ration Card applications are handled at your local Taluk Supply Office. Required docs: Aadhaar, Income Certificate & Electricity bill.';
      } else if (lower.contains('ocr') || lower.contains('document')) {
        reply += 'You can auto-extract your name and address using the OCR scanner from the Document Vault.';
      } else {
        reply += 'Our officers are available at 1800-425-1000 from 09:00 AM to 05:30 PM on all working days.';
      }

      setState(() {
        _chatMessages.add({'sender': 'bot', 'text': reply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Channels Row (Requirement 21: Call Helpdesk, Report a Problem, Contact)
              Row(
                children: [
                  Expanded(
                    child: _buildContactTile(
                      icon: Icons.call_outlined,
                      title: 'Call Helpdesk',
                      subtitle: '1800-425-1000',
                      color: AppColors.emeraldGreen,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling Citizen Toll-Free Helpdesk 1800-425-1000...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactTile(
                      icon: Icons.report_problem_outlined,
                      title: 'Report Problem',
                      subtitle: 'Direct Feedback',
                      color: AppColors.royalBlue,
                      onTap: () {
                        _showReportProblemDialog();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Interactive Chatbot Section (Requirement 21: Chat Support)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(color: AppColors.deepNavy.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.smart_toy_outlined, color: AppColors.teal, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'OneVisit Live AI Assistant',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: AppColors.deepNavy),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _chatMessages.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final msg = _chatMessages[index];
                          final isBot = msg['sender'] == 'bot';
                          return Align(
                            alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                              decoration: BoxDecoration(
                                color: isBot ? AppColors.softGrey : AppColors.royalBlue,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                msg['text']!,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: isBot ? AppColors.deepNavy : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            decoration: const InputDecoration(
                              hintText: 'Ask a question about queues, forms...',
                              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send_rounded, color: AppColors.royalBlue),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Frequently Asked Questions (Accordion)
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 12),
              ..._faqs.map((faq) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      faq['q']!,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.deepNavy),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faq['a']!,
                          style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.deepNavy)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  void _showReportProblemDialog() {
    final reportController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report an Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Describe any problem with counter service or forms:', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: reportController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Enter your grievance or bug description...'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.emeraldGreen,
                  content: Text('Grievance ticket created: TKT-2026-9901. Officer assigned.'),
                ),
              );
            },
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }
}
