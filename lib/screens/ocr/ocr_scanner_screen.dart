import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/document_model.dart';

class OCRScannerScreen extends StatefulWidget {
  final DocumentType defaultDocType;
  final Function(OCRExtractedData)? onConfirm;

  const OCRScannerScreen({
    super.key,
    this.defaultDocType = DocumentType.aadhaar,
    this.onConfirm,
  });

  @override
  State<OCRScannerScreen> createState() => _OCRScannerScreenState();
}

class _OCRScannerScreenState extends State<OCRScannerScreen> {
  bool _isScanning = false;
  bool _isScanned = false;
  String _uploadSource = 'Camera';

  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _docNumberController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dobController = TextEditingController();
    _docNumberController = TextEditingController();
    _addressController = TextEditingController();
    _genderController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _docNumberController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _simulateScan(String source) {
    setState(() {
      _uploadSource = source;
      _isScanning = true;
      _isScanned = false;
      _isEditing = false;
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      // Pre-fill realistic extracted data based on sample citizen
      if (widget.defaultDocType == DocumentType.aadhaar) {
        _nameController.text = 'Rahul Nair';
        _dobController.text = '12/05/1992';
        _docNumberController.text = '5842 9901 9021';
        _addressController.text = 'House No. 42, Green Valley, Civil Station, Alappuzha - 688001';
        _genderController.text = 'Male';
      } else if (widget.defaultDocType == DocumentType.pan) {
        _nameController.text = 'Rahul Nair';
        _dobController.text = '12/05/1992';
        _docNumberController.text = 'BNVPN4512K';
        _addressController.text = 'Civil Station Ward, Alappuzha, Kerala';
        _genderController.text = 'Male';
      } else {
        _nameController.text = 'Rahul Nair';
        _dobController.text = '12/05/1992';
        _docNumberController.text = 'KL-04-201800291';
        _addressController.text = 'House No. 42, Green Valley, Alappuzha';
        _genderController.text = 'Male';
      }

      setState(() {
        _isScanning = false;
        _isScanned = true;
      });
    });
  }

  void _handleConfirm() {
    final extracted = OCRExtractedData(
      name: _nameController.text.trim(),
      dob: _dobController.text.trim(),
      documentNumber: _docNumberController.text.trim(),
      address: _addressController.text.trim(),
      gender: _genderController.text.trim(),
      confidenceScore: 0.98,
      isReadable: true,
      isDetected: true,
    );

    if (widget.onConfirm != null) {
      widget.onConfirm!(extracted);
    }

    Navigator.of(context).pop(extracted);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMissing = _nameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _docNumberController.text.isEmpty ||
        _addressController.text.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('OCR Document Scanner'),
        actions: [
          if (_isScanned)
            IconButton(
              icon: Icon(_isEditing ? Icons.check_rounded : Icons.edit_note_rounded),
              onPressed: () {
                setState(() => _isEditing = !_isEditing);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card with Scan Method Selection
              if (!_isScanned && !_isScanning) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.royalBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.document_scanner_rounded, size: 48, color: AppColors.royalBlue),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Upload & Auto-Extract Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose an upload source to automatically detect your name, DOB, address, and ID number via OCR.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 24),

                      // Upload Options: Camera, Gallery, PDF (Requirement 8)
                      Row(
                        children: [
                          Expanded(
                            child: _buildUploadOption(
                              icon: Icons.camera_alt_rounded,
                              label: 'Camera',
                              onTap: () => _simulateScan('Camera'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildUploadOption(
                              icon: Icons.photo_library_rounded,
                              label: 'Gallery',
                              onTap: () => _simulateScan('Gallery'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildUploadOption(
                              icon: Icons.picture_as_pdf_rounded,
                              label: 'Upload PDF',
                              onTap: () => _simulateScan('PDF Document'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              // Scanning State
              if (_isScanning) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                              backgroundColor: AppColors.teal.withOpacity(0.15),
                            ),
                          ),
                          const Icon(Icons.document_scanner_rounded, size: 40, color: AppColors.royalBlue),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Scanning from $_uploadSource...',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Google ML Kit OCR is recognizing character patterns and extracting official citizen attributes...',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],

              // Extracted Information & Validation Status
              if (_isScanned) ...[
                // Simulated Document Thumbnail Preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F2B4D), Color(0xFF144D72)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.badge_rounded, color: AppColors.cyanAccent, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Document Captured via $_uploadSource',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Confidence: 98.4% • High Quality Scan',
                              style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.emeraldGreen),
                        ),
                        child: const Text('OCR OK', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Validation Badges (Requirement 8)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Validation Status',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildValidationBadge('✓ Information detected', true),
                          const SizedBox(width: 8),
                          _buildValidationBadge('✓ Document readable', true),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildValidationBadge(
                        hasMissing ? '⚠ Missing information detected' : '✓ No missing information',
                        !hasMissing,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Extracted Fields Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Extracted Information',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() => _isEditing = !_isEditing);
                            },
                            icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined, size: 16),
                            label: Text(_isEditing ? 'Save edits' : 'Edit'),
                          ),
                        ],
                      ),
                      const Divider(height: 18),

                      _buildFieldRow('Full Name', _nameController, Icons.person_outline_rounded),
                      const SizedBox(height: 14),
                      _buildFieldRow('Date of Birth', _dobController, Icons.cake_outlined),
                      const SizedBox(height: 14),
                      _buildFieldRow('Document / ID Number', _docNumberController, Icons.fingerprint_rounded),
                      const SizedBox(height: 14),
                      _buildFieldRow('Address', _addressController, Icons.home_outlined, maxLines: 2),
                      const SizedBox(height: 14),
                      _buildFieldRow('Gender', _genderController, Icons.wc_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Actions: Edit, Confirm, Retake, Delete (Requirement 8)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _simulateScan(_uploadSource);
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Retake'),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isScanned = false;
                            _nameController.clear();
                            _dobController.clear();
                            _docNumberController.clear();
                            _addressController.clear();
                          });
                        },
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 18),
                        label: const Text('Delete', style: TextStyle(color: AppColors.danger)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.danger),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _handleConfirm,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Confirm & Use Extracted Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emeraldGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.royalBlue, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationBadge(String label, bool isOk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOk ? AppColors.emeraldGreen.withOpacity(0.12) : AppColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOk ? AppColors.emeraldGreen.withOpacity(0.3) : AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isOk ? AppColors.emeraldGreen : const Color(0xFFB45309),
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.royalBlue),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 6),
        _isEditing
            ? TextFormField(
                controller: controller,
                maxLines: maxLines,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.softGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  controller.text.isEmpty ? 'Not detected' : controller.text,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: controller.text.isEmpty ? AppColors.textMuted : AppColors.deepNavy,
                  ),
                ),
              ),
      ],
    );
  }
}
