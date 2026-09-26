import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> requiredDocuments;
  final String processingTime;
  final String fee;
  final String officeAvailability;
  final List<String> formSections;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
    required this.color,
    required this.requiredDocuments,
    required this.processingTime,
    required this.fee,
    required this.officeAvailability,
    this.formSections = const [
      'Personal Details',
      'Contact Details',
      'Address',
      'Service Specifics',
      'Document Upload'
    ],
  });
}

class ServiceRepository {
  static const List<String> categories = [
    'All',
    'Government',
    'Healthcare',
    'Education',
    'Police',
    'Municipality',
    'Transport',
    'Revenue',
    'Pension',
    'Certificates',
    'More'
  ];

  static final List<ServiceItem> services = [
    const ServiceItem(
      id: 'ration_card',
      name: 'Ration Card',
      category: 'Government',
      description: 'Application for new Priority/Non-Priority Ration Card, member addition, address change, and card surrender.',
      icon: Icons.food_bank_outlined,
      color: Color(0xFF00B074),
      requiredDocuments: [
        'Aadhaar Card of all family members',
        'Income Certificate',
        'Electricity / Water Bill (Residence Proof)',
        'Passport Size Photograph'
      ],
      processingTime: '7 - 14 Working Days',
      fee: '₹ 50 (Official govt fee)',
      officeAvailability: 'Taluk Supply Office, Akshaya Centers, Civil Supplies Dept',
    ),
    const ServiceItem(
      id: 'pan_card',
      name: 'PAN Card',
      category: 'Revenue',
      description: 'Issuance of new Permanent Account Number (PAN) Form 49A, corrections, and reprint of physical card.',
      icon: Icons.credit_card_outlined,
      color: Color(0xFF1E6BFF),
      requiredDocuments: [
        'Aadhaar Card / Voter ID (Identity Proof)',
        'Birth Certificate / Matriculation Marksheet (DOB Proof)',
        'Utility Bill / Bank Statement (Address Proof)',
        '2 Color Passport Photos'
      ],
      processingTime: '5 - 10 Working Days',
      fee: '₹ 107 (National dispatch fee)',
      officeAvailability: 'UTI / NSDL Tax Facilitation Centers, Sub-Registrar',
    ),
    const ServiceItem(
      id: 'voter_id',
      name: 'Voter ID Card',
      category: 'Government',
      description: 'Electoral photo identity card (EPIC) registration (Form 6), constituency shift (Form 8), and e-EPIC download.',
      icon: Icons.how_to_vote_outlined,
      color: Color(0xFF00B4B0),
      requiredDocuments: [
        'Aadhaar Card or Passport',
        'Age Proof (Birth Certificate / School Certificate)',
        'Residence Proof of current constituency',
        'Recent Color Photo'
      ],
      processingTime: '15 - 20 Working Days',
      fee: 'Free of Cost',
      officeAvailability: 'Election Commission Taluk Office, Village Office',
    ),
    const ServiceItem(
      id: 'passport',
      name: 'Passport Services',
      category: 'Government',
      description: 'Fresh passport issue, tatkaal reissue, police verification clearance, and minor passport applications.',
      icon: Icons.flight_takeoff_outlined,
      color: Color(0xFF0B2545),
      requiredDocuments: [
        'Aadhaar Card / Voter ID',
        'Birth Certificate or Educational Certificate',
        'Proof of Current Address (Passbook / Electricity bill)',
        'No Objection Certificate (for Govt employees)'
      ],
      processingTime: '3 - 7 Working Days (Tatkaal) / 15 Days (Normal)',
      fee: '₹ 1,500 (Standard 36 pages)',
      officeAvailability: 'Passport Seva Kendra (PSK), Post Office PSK',
    ),
    const ServiceItem(
      id: 'driving_license',
      name: 'Driving Licence',
      category: 'Transport',
      description: 'Learner licence test booking, permanent licence driving test, renewal, and endorsement of vehicle classes.',
      icon: Icons.drive_eta_outlined,
      color: Color(0xFF3B82F6),
      requiredDocuments: [
        'Learner Licence (LLR) Reference Number',
        'Age and Address Proof (Aadhaar/Passport)',
        'Form 1 & Form 1A (Medical Fitness Certificate)',
        'Driving School Training Certificate (Form 5)'
      ],
      processingTime: 'Same day test & 5 days dispatch',
      fee: '₹ 500 (Learner + Driving Test)',
      officeAvailability: 'Regional Transport Office (RTO), Sub-RTO',
    ),
    const ServiceItem(
      id: 'birth_cert',
      name: 'Birth Certificate',
      category: 'Certificates',
      description: 'Official registration and certified copy of birth certificate with digital seal and QR validation.',
      icon: Icons.child_friendly_outlined,
      color: Color(0xFF10B981),
      requiredDocuments: [
        'Hospital Discharge / Birth Slip',
        'Parents Aadhaar Cards & Marriage Certificate',
        'Address Proof of Parents'
      ],
      processingTime: '3 - 5 Working Days',
      fee: '₹ 20 per certified copy',
      officeAvailability: 'Municipal Corporation, Grama Panchayat, Town Health Dept',
    ),
    const ServiceItem(
      id: 'death_cert',
      name: 'Death Certificate',
      category: 'Certificates',
      description: 'Issuance of official death registry record and legal certified copies for property and claim transfers.',
      icon: Icons.assignment_late_outlined,
      color: Color(0xFF64748B),
      requiredDocuments: [
        'Hospital Death Report / Cremation receipt',
        'Deceased Aadhaar / Identity proof',
        'Applicant relationship proof'
      ],
      processingTime: '3 - 7 Working Days',
      fee: '₹ 20 per certified copy',
      officeAvailability: 'Panchayat Office, Municipality Health Wing',
    ),
    const ServiceItem(
      id: 'income_cert',
      name: 'Income Certificate',
      category: 'Revenue',
      description: 'Revenue authority assessment certificate for education fee concessions, scholarships, and welfare aid.',
      icon: Icons.receipt_long_outlined,
      color: Color(0xFFF59E0B),
      requiredDocuments: [
        'Salary Certificate / IT Return / Affidavit',
        'Land Tax receipt (if land owner)',
        'Ration Card copy',
        'Aadhaar Card'
      ],
      processingTime: '5 - 7 Working Days',
      fee: '₹ 30 (Revenue fee)',
      officeAvailability: 'Village Office, Taluk Tehsildar Office',
    ),
    const ServiceItem(
      id: 'residence_cert',
      name: 'Residence Certificate',
      category: 'Revenue',
      description: 'Official proof of residence and domicile status within the taluk/state for official admissions and jobs.',
      icon: Icons.home_work_outlined,
      color: Color(0xFF0284C7),
      requiredDocuments: [
        'Aadhaar / Voter ID',
        'Electricity bill / House tax receipt for last 3 years',
        'Ration Card'
      ],
      processingTime: '3 - 5 Working Days',
      fee: '₹ 30',
      officeAvailability: 'Village Office, Sub-Collectorate',
    ),
    const ServiceItem(
      id: 'pension',
      name: 'Social Security Pension',
      category: 'Pension',
      description: 'Old age pension, widow pension, agriculture worker pension, and disability welfare monthly aid.',
      icon: Icons.elderly_outlined,
      color: Color(0xFF8B5CF6),
      requiredDocuments: [
        'Age Proof / Medical Board Certificate',
        'Income Certificate (Below poverty line)',
        'Bank Passbook copy with IFSC code',
        'Aadhaar Card'
      ],
      processingTime: '14 - 30 Working Days',
      fee: 'Free of Cost',
      officeAvailability: 'Social Welfare Department, Block Development Office',
    ),
    const ServiceItem(
      id: 'municipality',
      name: 'Municipality Services',
      category: 'Municipality',
      description: 'Property tax payment, building permit NOC, trade license, waste management requests, and water connection.',
      icon: Icons.location_city_outlined,
      color: Color(0xFF00B074),
      requiredDocuments: [
        'Building Plan / Deed document',
        'Latest Property Tax Receipt',
        'Owner ID Proof'
      ],
      processingTime: '7 - 10 Working Days',
      fee: 'Varies by service',
      officeAvailability: 'City Corporation / Municipality Head Office',
    ),
  ];
}
