import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../models/document_model.dart';
import '../../services/app_state.dart';
import '../ocr/ocr_scanner_screen.dart';

class DocumentsWalletScreen extends StatelessWidget {
  const DocumentsWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final documents = appState.documents;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Documents Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Add & Scan Document',
            onPressed: () => _showAddDocModal(context, appState),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security Header
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
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
                      child: const Icon(Icons.security_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Government Encrypted Locker',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'All documents are pre-verified for single-click form auto-fill.',
                            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stored Credentials (${documents.length})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddDocModal(context, appState),
                    icon: const Icon(Icons.camera_alt_outlined, size: 16),
                    label: const Text('Scan New'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Documents List (Requirement 20: Preview, upload date, status, delete)
              ...documents.map((doc) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepNavy.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.softGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.badge_rounded, color: AppColors.royalBlue, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      doc.title,
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.deepNavy,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.emeraldGreen.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        '✓ Verified',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.emeraldGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Number: ${doc.documentNumber}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Uploaded: ${DateFormat('dd MMM yyyy').format(doc.uploadDate)} • ${doc.fileSize}',
                                  style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      // Actions: Preview & Delete
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              _showDocumentPreview(context, doc);
                            },
                            icon: const Icon(Icons.visibility_outlined, size: 16),
                            label: const Text('View OCR Data'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              appState.removeDocument(doc.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${doc.title} removed from vault.')),
                              );
                            },
                            icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.danger),
                            label: const Text('Delete', style: TextStyle(color: AppColors.danger)),
                          ),
                        ],
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

  void _showAddDocModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Document to Locker', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.deepNavy)),
              const SizedBox(height: 6),
              const Text('Use automated OCR scanner to verify attributes', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.credit_card_rounded, color: AppColors.royalBlue),
                title: const Text('Scan Aadhaar Card'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _startScan(context, appState, DocumentType.aadhaar, 'Aadhaar Card');
                },
              ),
              ListTile(
                leading: const Icon(Icons.badge_outlined, color: AppColors.teal),
                title: const Text('Scan PAN Card'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _startScan(context, appState, DocumentType.pan, 'PAN Card');
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_eta_outlined, color: AppColors.emeraldGreen),
                title: const Text('Scan Driving Licence'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _startScan(context, appState, DocumentType.drivingLicense, 'Driving Licence');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startScan(BuildContext context, AppState appState, DocumentType type, String title) async {
    final result = await Navigator.of(context).push<OCRExtractedData>(
      MaterialPageRoute(
        builder: (_) => OCRScannerScreen(defaultDocType: type),
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      final newDoc = CitizenDocument(
        id: 'DOC-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        type: type,
        documentNumber: result.documentNumber,
        uploadDate: DateTime.now(),
        status: DocumentValidationStatus.verified,
        fileSize: '1.1 MB',
        extractedData: result,
      );
      appState.addDocument(newDoc);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.emeraldGreen,
          content: Text('✓ $title successfully verified and added to vault!'),
        ),
      );
    }
  }

  void _showDocumentPreview(BuildContext context, CitizenDocument doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(doc.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _previewField('Cardholder Name', doc.extractedData.name),
            _previewField('Document Number', doc.extractedData.documentNumber),
            _previewField('Date of Birth', doc.extractedData.dob),
            _previewField('Address', doc.extractedData.address),
            _previewField('Gender', doc.extractedData.gender),
            _previewField('OCR Confidence', '${(doc.extractedData.confidenceScore * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _previewField(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          Text(val.isEmpty ? 'N/A' : val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
        ],
      ),
    );
  }
}
