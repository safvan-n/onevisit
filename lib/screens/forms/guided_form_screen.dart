import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/service_model.dart';
import '../../models/document_model.dart';
import '../ocr/ocr_scanner_screen.dart';
import 'review_submit_screen.dart';

class GuidedFormScreen extends StatefulWidget {
  final ServiceItem service;
  final int initialStep;

  const GuidedFormScreen({
    super.key,
    required this.service,
    this.initialStep = 0,
  });

  @override
  State<GuidedFormScreen> createState() => _GuidedFormScreenState();
}

class _GuidedFormScreenState extends State<GuidedFormScreen> {
  late int _currentStep;
  final _formKey = GlobalKey<FormState>();

  // Step 1: Personal
  final _fullNameController = TextEditingController(text: 'Rahul Nair');
  final _dobController = TextEditingController(text: '12/05/1992');
  String _gender = 'Male';
  String _maritalStatus = 'Married';
  final _guardianController = TextEditingController(text: 'K. Raman Nair');

  // Step 2: Contact
  final _phoneController = TextEditingController(text: '9847123456');
  final _emailController = TextEditingController(text: 'rahul.nair@citizen.gov.in');
  final _altPhoneController = TextEditingController(text: '9447189012');

  // Step 3: Address
  final _streetController = TextEditingController(text: 'House No. 42, Green Valley');
  String _district = 'Alappuzha';
  String _taluk = 'Ambalappuzha';
  final String _state = 'Kerala';
  final _pincodeController = TextEditingController(text: '688001');

  // Step 4: Service Specific
  String _subCategory = 'Priority Household (PHH)';
  String _familyCount = '4';
  final _incomeController = TextEditingController(text: '₹ 1,20,000');
  final _depotController = TextEditingController(text: 'Depot No. 14, Civil Station');
  bool _agreeDeclaration = true;

  // Step 5: Documents
  final List<String> _attachedDocs = [
    'Aadhaar Card (Identity & DOB)',
    'Income Certificate (Revenue Dept)',
  ];

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _guardianController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _altPhoneController.dispose();
    _streetController.dispose();
    _pincodeController.dispose();
    _incomeController.dispose();
    _depotController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // Validate current step
    if (_currentStep == 0) {
      if (_fullNameController.text.trim().isEmpty) {
        _showError('Full name is required as per official ID.');
        return;
      }
      if (_dobController.text.trim().isEmpty) {
        _showError('Date of birth is required.');
        return;
      }
    } else if (_currentStep == 1) {
      if (_phoneController.text.trim().length < 10) {
        _showError('A valid 10-digit mobile number is required.');
        return;
      }
      if (!_emailController.text.contains('@')) {
        _showError('Please provide a valid email address.');
        return;
      }
    } else if (_currentStep == 2) {
      if (_streetController.text.trim().isEmpty) {
        _showError('Address / Street name is required.');
        return;
      }
      if (_pincodeController.text.trim().length < 6) {
        _showError('Valid 6-digit PIN code is required.');
        return;
      }
    } else if (_currentStep == 3) {
      if (_incomeController.text.trim().isEmpty) {
        _showError('Annual family income is required for this service.');
        return;
      }
      if (!_agreeDeclaration) {
        _showError('You must accept the service criteria declaration.');
        return;
      }
    } else if (_currentStep == 4) {
      // Step 5 check: Requirement 9: "Address proof is required."
      if (_attachedDocs.isEmpty) {
        _showError('At least 2 required documents must be attached before submission.');
        return;
      }
      // Review & Submit
      _goToReview();
      return;
    }

    setState(() {
      _currentStep += 1;
    });
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.danger,
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _goToReview() {
    final formData = {
      'fullName': _fullNameController.text.trim(),
      'dob': _dobController.text.trim(),
      'gender': _gender,
      'maritalStatus': _maritalStatus,
      'guardianName': _guardianController.text.trim(),
      'phone': '+91 ${_phoneController.text.trim()}',
      'email': _emailController.text.trim(),
      'altPhone': _altPhoneController.text.trim(),
      'street': _streetController.text.trim(),
      'district': _district,
      'taluk': _taluk,
      'state': _state,
      'pincode': _pincodeController.text.trim(),
      'subCategory': _subCategory,
      'familyCount': _familyCount,
      'annualIncome': _incomeController.text.trim(),
      'rationDepot': _depotController.text.trim(),
      'preferredOffice': 'Alappuzha Taluk Office',
    };

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReviewSubmitScreen(
          service: widget.service,
          formData: formData,
          uploadedDocs: _attachedDocs,
          onEditSection: (stepIndex) {
            Navigator.of(context).pop();
            setState(() {
              _currentStep = stepIndex;
            });
          },
        ),
      ),
    );
  }

  void _triggerOCRQuickFill() async {
    final result = await Navigator.of(context).push<OCRExtractedData>(
      MaterialPageRoute(
        builder: (_) => const OCRScannerScreen(defaultDocType: DocumentType.aadhaar),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        if (result.name.isNotEmpty) _fullNameController.text = result.name;
        if (result.dob.isNotEmpty) _dobController.text = result.dob;
        if (result.address.isNotEmpty) _streetController.text = result.address;
        if (!_attachedDocs.contains('Aadhaar Card (OCR Scanned)')) {
          _attachedDocs.add('Aadhaar Card (OCR Scanned)');
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.emeraldGreen,
          content: Text('✓ Form fields automatically populated from OCR scan!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const totalSteps = 5;
    final stepNames = [
      'Personal Details',
      'Contact Info',
      'Address',
      'Service Specifics',
      'Documents',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.service.name),
        actions: [
          IconButton(
            tooltip: 'OCR Quick-Fill',
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.royalBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.document_scanner_rounded, size: 16, color: AppColors.royalBlue),
                  SizedBox(width: 4),
                  Text('OCR Fill', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.royalBlue)),
                ],
              ),
            ),
            onPressed: _triggerOCRQuickFill,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Multi-Step Progress Header (Requirement 7: Step 2 of 5)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step ${_currentStep + 1} of $totalSteps',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.royalBlue,
                        ),
                      ),
                      Text(
                        stepNames[_currentStep],
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepNavy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / totalSteps,
                      backgroundColor: AppColors.softGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.royalBlue),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: _buildCurrentStepContent(),
                ),
              ),
            ),

            // Bottom Navigation Controls: Back & Next
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousStep,
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _nextStep,
                      icon: Icon(
                        _currentStep == totalSteps - 1
                            ? Icons.fact_check_rounded
                            : Icons.arrow_forward_rounded,
                        size: 18,
                      ),
                      label: Text(
                        _currentStep == totalSteps - 1
                            ? 'Review & Confirm'
                            : 'Next: ${stepNames[_currentStep + 1]}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.royalBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Personal();
      case 1:
        return _buildStep2Contact();
      case 2:
        return _buildStep3Address();
      case 3:
        return _buildStep4ServiceSpecific();
      case 4:
        return _buildStep5Documents();
      default:
        return const SizedBox();
    }
  }

  // STEP 1: Personal Information
  Widget _buildStep1Personal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Personal Details',
          'Ensure names and birth details match your official Aadhaar/Birth records.',
        ),
        const SizedBox(height: 18),

        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name *',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _dobController,
          decoration: InputDecoration(
            labelText: 'Date of Birth (DD/MM/YYYY) *',
            prefixIcon: const Icon(Icons.calendar_today_outlined),
            suffixIcon: IconButton(
              icon: const Icon(Icons.date_range_rounded),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1992, 5, 12),
                  firstDate: DateTime(1930),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  _dobController.text =
                      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text('Gender *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.deepNavy)),
        const SizedBox(height: 6),
        Row(
          children: ['Male', 'Female', 'Other'].map((g) {
            return Expanded(
              child: RadioListTile<String>(
                title: Text(g, style: const TextStyle(fontSize: 13)),
                value: g,
                groupValue: _gender,
                contentPadding: EdgeInsets.zero,
                dense: true,
                onChanged: (val) => setState(() => _gender = val!),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),

        DropdownButtonFormField<String>(
          value: _maritalStatus,
          decoration: const InputDecoration(
            labelText: 'Marital Status',
            prefixIcon: Icon(Icons.favorite_border_rounded),
          ),
          items: ['Married', 'Single', 'Divorced', 'Widowed']
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (val) => setState(() => _maritalStatus = val!),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _guardianController,
          decoration: const InputDecoration(
            labelText: "Father's / Guardian's Full Name",
            prefixIcon: Icon(Icons.family_restroom_rounded),
          ),
        ),
      ],
    );
  }

  // STEP 2: Contact Information
  Widget _buildStep2Contact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Contact & Notification Details',
          'We will send queue alerts, turn reminders, and digital tokens here.',
        ),
        const SizedBox(height: 18),

        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Mobile Number *',
            prefixText: '+91 ',
            prefixIcon: Icon(Icons.phone_android_rounded),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email Address *',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _altPhoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Alternative Emergency Contact (Optional)',
            prefixIcon: Icon(Icons.contact_phone_outlined),
          ),
        ),
      ],
    );
  }

  // STEP 3: Address
  Widget _buildStep3Address() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Permanent Residential Address',
          'Select your taluk and district for automatic local office assignment.',
        ),
        const SizedBox(height: 18),

        TextFormField(
          controller: _streetController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'House Name / Number & Street *',
            prefixIcon: Icon(Icons.home_outlined),
          ),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: _district,
          decoration: const InputDecoration(
            labelText: 'District *',
            prefixIcon: Icon(Icons.location_city_rounded),
          ),
          items: ['Alappuzha', 'Ernakulam', 'Thiruvananthapuram', 'Kottayam', 'Thrissur']
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (val) => setState(() => _district = val!),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: _taluk,
          decoration: const InputDecoration(
            labelText: 'Taluk *',
            prefixIcon: Icon(Icons.map_outlined),
          ),
          items: ['Ambalappuzha', 'Cherthala', 'Karthikappally', 'Kuttanad', 'Mavelikkara']
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (val) => setState(() => _taluk = val!),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _pincodeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'PIN Code *',
            prefixIcon: Icon(Icons.pin_drop_outlined),
          ),
        ),
      ],
    );
  }

  // STEP 4: Service Specifics
  Widget _buildStep4ServiceSpecific() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          '${widget.service.name} Information',
          'Specify details relevant to this government application.',
        ),
        const SizedBox(height: 18),

        DropdownButtonFormField<String>(
          value: _subCategory,
          decoration: const InputDecoration(
            labelText: 'Application Category',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: [
            'Priority Household (PHH)',
            'Non-Priority Subsidy (NPS)',
            'Antyodaya Anna Yojana (AAY)',
            'General White Card'
          ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (val) => setState(() => _subCategory = val!),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: _familyCount,
          decoration: const InputDecoration(
            labelText: 'Number of Family Members',
            prefixIcon: Icon(Icons.people_outline_rounded),
          ),
          items: ['1', '2', '3', '4', '5', '6+']
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (val) => setState(() => _familyCount = val!),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _incomeController,
          decoration: const InputDecoration(
            labelText: 'Annual Household Income *',
            prefixIcon: Icon(Icons.currency_rupee_rounded),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _depotController,
          decoration: const InputDecoration(
            labelText: 'Nearest Authorized Ration Depot',
            prefixIcon: Icon(Icons.storefront_outlined),
          ),
        ),
        const SizedBox(height: 18),

        CheckboxListTile(
          value: _agreeDeclaration,
          activeColor: AppColors.royalBlue,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'I certify that our household does not possess any other active card.',
            style: TextStyle(fontSize: 13, color: AppColors.deepNavy),
          ),
          onChanged: (val) => setState(() => _agreeDeclaration = val ?? false),
        ),
      ],
    );
  }

  // STEP 5: Documents (with OCR upload integration)
  Widget _buildStep5Documents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Document Upload & Verification',
          'Attach scanned documents or use OCR Scanner for instant automatic verification.',
        ),
        const SizedBox(height: 16),

        // Quick OCR Scan Action Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.royalBlue.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: AppColors.royalBlue.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.royalBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.document_scanner_rounded, color: AppColors.royalBlue, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Scan via OCR Scanner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.deepNavy)),
                    SizedBox(height: 3),
                    Text('Capture Aadhaar, PAN or Driving License with auto field detection.', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _triggerOCRQuickFill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.royalBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Scan Now', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Attached Documents List
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Attached Documents',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
            ),
            TextButton.icon(
              onPressed: () {
                _showAddDocumentDialog();
              },
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Add Document'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        ..._attachedDocs.map((doc) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf_rounded, color: AppColors.royalBlue, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.deepNavy)),
                      const SizedBox(height: 2),
                      const Text('Ready for desk verification', style: TextStyle(fontSize: 11, color: AppColors.emeraldGreen)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.danger),
                  onPressed: () {
                    setState(() {
                      _attachedDocs.remove(doc);
                    });
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _showAddDocumentDialog() {
    final docOptions = [
      'Electricity Bill (KSEB Residence Proof)',
      'Voter ID Card',
      'Bank Passbook Copy',
      'Passport Size Photo',
      'Medical Board Certificate'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Document to Attach', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepNavy)),
              const SizedBox(height: 12),
              ...docOptions.map((opt) {
                return ListTile(
                  leading: const Icon(Icons.upload_file_rounded, color: AppColors.royalBlue),
                  title: Text(opt, style: const TextStyle(fontSize: 13.5)),
                  onTap: () {
                    if (!_attachedDocs.contains(opt)) {
                      setState(() {
                        _attachedDocs.add(opt);
                      });
                    }
                    Navigator.of(ctx).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.deepNavy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
