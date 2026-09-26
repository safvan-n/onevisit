enum DocumentType {
  aadhaar,
  pan,
  drivingLicense,
  passport,
  addressProof,
  incomeProof,
  other,
}

enum DocumentValidationStatus {
  verified,
  partial,
  missingInfo,
}

class OCRExtractedData {
  String name;
  String dob;
  String documentNumber;
  String address;
  String gender;
  double confidenceScore;
  bool isReadable;
  bool isDetected;

  OCRExtractedData({
    required this.name,
    required this.dob,
    required this.documentNumber,
    required this.address,
    this.gender = 'Not specified',
    this.confidenceScore = 0.96,
    this.isReadable = true,
    this.isDetected = true,
  });

  bool get hasMissingInfo =>
      name.isEmpty || dob.isEmpty || documentNumber.isEmpty || address.isEmpty;

  OCRExtractedData copyWith({
    String? name,
    String? dob,
    String? documentNumber,
    String? address,
    String? gender,
    double? confidenceScore,
    bool? isReadable,
    bool? isDetected,
  }) {
    return OCRExtractedData(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      documentNumber: documentNumber ?? this.documentNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      isReadable: isReadable ?? this.isReadable,
      isDetected: isDetected ?? this.isDetected,
    );
  }
}

class CitizenDocument {
  final String id;
  final String title;
  final DocumentType type;
  final String documentNumber;
  final DateTime uploadDate;
  final DocumentValidationStatus status;
  final String fileSize;
  final OCRExtractedData extractedData;

  const CitizenDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.documentNumber,
    required this.uploadDate,
    required this.status,
    required this.fileSize,
    required this.extractedData,
  });
}
