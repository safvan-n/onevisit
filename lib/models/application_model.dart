enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  approved,
  rejected,
  completed,
}

class ApplicationTimelineStage {
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;
  final bool isCurrent;

  const ApplicationTimelineStage({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

class ApplicationModel {
  final String id;
  final String serviceName;
  final String officeName;
  final DateTime createdAt;
  ApplicationStatus status;
  final String applicantName;
  final String applicantPhone;
  final String applicantEmail;
  final Map<String, dynamic> formData;
  final List<String> uploadedDocs;
  String? tokenNumber;
  List<ApplicationTimelineStage> timeline;

  ApplicationModel({
    required this.id,
    required this.serviceName,
    required this.officeName,
    required this.createdAt,
    this.status = ApplicationStatus.submitted,
    required this.applicantName,
    required this.applicantPhone,
    required this.applicantEmail,
    required this.formData,
    required this.uploadedDocs,
    this.tokenNumber,
    required this.timeline,
  });

  String get formattedStatus {
    switch (status) {
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.completed:
        return 'Completed';
    }
  }

  static List<ApplicationTimelineStage> createDefaultTimeline({
    required ApplicationStatus status,
    required DateTime createdDate,
  }) {
    return [
      ApplicationTimelineStage(
        title: 'Form Started',
        description: 'Citizen initiated digital guided form',
        timestamp: createdDate.subtract(const Duration(minutes: 15)),
        isCompleted: true,
      ),
      ApplicationTimelineStage(
        title: 'Documents Uploaded',
        description: 'OCR validated identity and address proofs attached',
        timestamp: createdDate.subtract(const Duration(minutes: 5)),
        isCompleted: true,
      ),
      ApplicationTimelineStage(
        title: 'Application Submitted',
        description: 'Sent to official revenue/service database',
        timestamp: createdDate,
        isCompleted: true,
        isCurrent: status == ApplicationStatus.submitted,
      ),
      ApplicationTimelineStage(
        title: 'Desk Verification',
        description: 'Office official verifies records via QR pass',
        timestamp: createdDate.add(const Duration(days: 1)),
        isCompleted: status == ApplicationStatus.underReview ||
            status == ApplicationStatus.approved ||
            status == ApplicationStatus.completed,
        isCurrent: status == ApplicationStatus.underReview,
      ),
      ApplicationTimelineStage(
        title: 'Processing & Approval',
        description: 'Competent officer review and sign-off',
        timestamp: createdDate.add(const Duration(days: 3)),
        isCompleted: status == ApplicationStatus.approved ||
            status == ApplicationStatus.completed,
        isCurrent: status == ApplicationStatus.approved,
      ),
      ApplicationTimelineStage(
        title: 'Service Completed',
        description: 'Certificate/card issued & ready for collection or digital download',
        timestamp: createdDate.add(const Duration(days: 5)),
        isCompleted: status == ApplicationStatus.completed,
        isCurrent: status == ApplicationStatus.completed,
      ),
    ];
  }
}
