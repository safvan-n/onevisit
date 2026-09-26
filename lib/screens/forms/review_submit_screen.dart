import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/service_model.dart';
import '../../services/app_state.dart';
import '../offices/office_selection_screen.dart';

class ReviewSubmitScreen extends StatefulWidget {
  final ServiceItem service;
  final Map<String, dynamic> formData;
  final List<String> uploadedDocs;
  final Function(int) onEditSection;

  const ReviewSubmitScreen({
    super.key,
    required this.service,
    required this.formData,
    required this.uploadedDocs,
    required this.onEditSection,
  });

  @override
  State<ReviewSubmitScreen> createState() => _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState extends State<ReviewSubmitScreen> {
  bool _confirmed = false;
  bool _isSubmitting = false;

  void _handleSubmit() {
    if (!_confirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Please confirm that the information provided is correct.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);
      
      // Submit application to central state
      final newApp = appState.submitApplication(
        serviceName: widget.service.name,
        officeName: widget.formData['preferredOffice'] ?? 'Alappuzha Taluk Office',
        formData: widget.formData,
        documents: widget.uploadedDocs,
      );

      setState(() => _isSubmitting = false);

      // Transition to Office Selection & Token Booking flow (Requirement 10 & 11)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OfficeSelectionScreen(
            service: widget.service,
            linkedApplication: newApp,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review & Submit'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.fact_check_rounded, color: Colors.white, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Application Verification',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Applying for: ${widget.service.name}',
                                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 1: Personal Information
                    _buildSummaryCard(
                      title: 'Personal Information',
                      stepIndex: 0,
                      items: {
                        'Full Name': widget.formData['fullName'] ?? 'Rahul Nair',
                        'Date of Birth': widget.formData['dob'] ?? '12/05/1992',
                        'Gender': widget.formData['gender'] ?? 'Male',
                        'Marital Status': widget.formData['maritalStatus'] ?? 'Married',
                        'Father / Guardian': widget.formData['guardianName'] ?? 'K. Raman Nair',
                      },
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Contact Information
                    _buildSummaryCard(
                      title: 'Contact Information',
                      stepIndex: 1,
                      items: {
                        'Mobile Number': widget.formData['phone'] ?? '+91 98471 23456',
                        'Email Address': widget.formData['email'] ?? 'rahul.nair@citizen.gov.in',
                        'Alternative Phone': widget.formData['altPhone'] ?? '94471 89012',
                      },
                    ),
                    const SizedBox(height: 16),

                    // Section 3: Address
                    _buildSummaryCard(
                      title: 'Address Details',
                      stepIndex: 2,
                      items: {
                        'Street & House': widget.formData['street'] ?? 'House No. 42, Green Valley',
                        'Taluk': widget.formData['taluk'] ?? 'Ambalappuzha',
                        'District': widget.formData['district'] ?? 'Alappuzha',
                        'State': widget.formData['state'] ?? 'Kerala',
                        'PIN Code': widget.formData['pincode'] ?? '688001',
                      },
                    ),
                    const SizedBox(height: 16),

                    // Section 4: Service Information
                    _buildSummaryCard(
                      title: 'Service-Specific Information',
                      stepIndex: 3,
                      items: {
                        'Application Category': widget.formData['subCategory'] ?? 'Priority Household (PHH)',
                        'Family Members Count': widget.formData['familyCount'] ?? '4',
                        'Annual Family Income': widget.formData['annualIncome'] ?? '₹ 1,20,000',
                        'Current Ration Shop / Depot': widget.formData['rationDepot'] ?? 'Depot No. 14, Civil Station',
                      },
                    ),
                    const SizedBox(height: 16),

                    // Section 5: Documents
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Uploaded Documents',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
                              ),
                              TextButton.icon(
                                onPressed: () => widget.onEditSection(4),
                                icon: const Icon(Icons.edit_outlined, size: 15),
                                label: const Text('Edit', style: TextStyle(fontSize: 13)),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          if (widget.uploadedDocs.isEmpty)
                            const Text('No documents attached', style: TextStyle(color: AppColors.danger, fontSize: 13))
                          else
                            ...widget.uploadedDocs.map((doc) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.verified_rounded, color: AppColors.emeraldGreen, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        doc,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.emeraldGreen.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('Verified', style: TextStyle(fontSize: 10, color: AppColors.emeraldGreen, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirmation Checkbox (Requirement 10)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.softGrey,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _confirmed,
                            activeColor: AppColors.royalBlue,
                            onChanged: (val) => setState(() => _confirmed = val ?? false),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: const Text(
                                'I confirm that the information provided is correct and genuine to the best of my knowledge.',
                                style: TextStyle(fontSize: 13, color: AppColors.deepNavy, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Submit Button Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.royalBlue,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Submit Application & Book Token',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int stepIndex,
    required Map<String, String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
              ),
              TextButton.icon(
                onPressed: () => widget.onEditSection(stepIndex),
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: const Text('Edit', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          const Divider(height: 16),
          ...items.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(
                      e.key,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
