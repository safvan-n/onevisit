import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../models/application_model.dart';
import '../tokens/live_queue_screen.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(application.id),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Status Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepNavy.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          application.serviceName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.teal),
                          ),
                          child: Text(
                            application.formattedStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Office: ${application.officeName}',
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Submitted: ${DateFormat('dd MMMM yyyy, hh:mm a').format(application.createdAt)}',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                    ),
                    if (application.tokenNumber != null) ...[
                      const Divider(height: 20, color: Colors.white24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Linked Token: ${application.tokenNumber}',
                            style: const TextStyle(color: AppColors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LiveQueueScreen()),
                              );
                            },
                            child: const Text(
                              'Track Live Queue →',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Application Timeline (Requirement 18: Form Started -> Docs Uploaded -> Submitted -> Verification -> Processing -> Completed)
              const Text(
                'Application Lifecycle Timeline',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: application.timeline.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stage = entry.value;
                    final isLast = index == application.timeline.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Step Circle & Line
                          Column(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: stage.isCompleted
                                      ? AppColors.emeraldGreen
                                      : stage.isCurrent
                                          ? AppColors.royalBlue
                                          : AppColors.softGrey,
                                  border: Border.all(
                                    color: stage.isCompleted
                                        ? AppColors.emeraldGreen
                                        : stage.isCurrent
                                            ? AppColors.royalBlue
                                            : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  stage.isCompleted
                                      ? Icons.check_rounded
                                      : stage.isCurrent
                                          ? Icons.radio_button_checked
                                          : Icons.circle_outlined,
                                  size: 14,
                                  color: stage.isCompleted || stage.isCurrent
                                      ? Colors.white
                                      : AppColors.textMuted,
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: stage.isCompleted ? AppColors.emeraldGreen : AppColors.border,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),

                          // Stage Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        stage.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: stage.isCompleted || stage.isCurrent
                                              ? AppColors.deepNavy
                                              : AppColors.textMuted,
                                        ),
                                      ),
                                      if (stage.isCompleted)
                                        Text(
                                          DateFormat('dd MMM, hh:mm a').format(stage.timestamp),
                                          style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    stage.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: stage.isCompleted || stage.isCurrent
                                          ? AppColors.textSecondary
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Submitted Information (Requirement 18)
              const Text(
                'Submitted Citizen Attributes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _infoRow('Applicant Name', application.applicantName),
                    const SizedBox(height: 8),
                    _infoRow('Phone Number', application.applicantPhone),
                    const SizedBox(height: 8),
                    _infoRow('Email', application.applicantEmail),
                    ...application.formData.entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: _infoRow(_formatLabel(e.key), e.value.toString()),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Uploaded Documents
              const Text(
                'Attached Official Documents',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 12),
              ...application.uploadedDocs.map((doc) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: AppColors.royalBlue, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          doc,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.deepNavy),
                        ),
                      ),
                      const Icon(Icons.verified_rounded, color: AppColors.emeraldGreen, size: 18),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
          ),
        ),
      ],
    );
  }

  String _formatLabel(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}')
        .replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m[0]!.toUpperCase());
  }
}
