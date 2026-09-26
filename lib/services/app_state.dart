import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/token_model.dart';
import '../models/application_model.dart';
import '../models/document_model.dart';
import '../models/notification_model.dart';

enum UserRole {
  citizen,
  staff,
  admin,
}

class AppState extends ChangeNotifier {
  // Auth & Profile
  bool _isAuthenticated = true;
  bool _hasSeenOnboarding = true;
  UserRole _currentRole = UserRole.citizen;

  String _userName = 'Rahul Nair';
  String _userPhone = '+91 98471 23456';
  String _userEmail = 'rahul.nair@citizen.gov.in';
  final String _userAadhaar = 'XXXX-XXXX-9021';
  String _userAddress = 'House No. 42, Green Valley, Civil Station, Alappuzha - 688001';

  // Language & Accessibility
  AppLanguage _language = AppLanguage.english;
  bool _largeText = false;
  bool _highContrast = false;
  bool _voiceGuidance = false;

  // Active Token & Tokens
  TokenModel? _activeToken;
  List<TokenModel> _allTokens = [];

  // Applications
  List<ApplicationModel> _applications = [];

  // Documents Wallet
  List<CitizenDocument> _documents = [];

  // Notifications
  List<AppNotification> _notifications = [];

  // Staff & Admin Counters
  final List<Map<String, dynamic>> _counters = [
    {
      'id': 'C-01',
      'name': 'Counter 01',
      'service': 'Ration Card & Civil Supplies',
      'staff': 'Anjali Kumar',
      'status': 'ACTIVE',
      'currentToken': 'A-095',
      'queueCount': 6,
    },
    {
      'id': 'C-02',
      'name': 'Counter 02',
      'service': 'Revenue & Income Certificates',
      'staff': 'Suresh Menon',
      'status': 'ACTIVE',
      'currentToken': 'B-042',
      'queueCount': 8,
    },
    {
      'id': 'C-03',
      'name': 'Counter 03',
      'service': 'Voter ID & Electoral Registration',
      'staff': 'Priya Das',
      'status': 'ACTIVE',
      'currentToken': 'A-097',
      'queueCount': 5,
    },
    {
      'id': 'C-04',
      'name': 'Counter 04',
      'service': 'Pensions & Social Welfare',
      'staff': 'George Thomas',
      'status': 'IDLE',
      'currentToken': 'P-018',
      'queueCount': 2,
    },
  ];

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  UserRole get currentRole => _currentRole;
  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userEmail => _userEmail;
  String get userAadhaar => _userAadhaar;
  String get userAddress => _userAddress;

  AppLanguage get language => _language;
  bool get largeText => _largeText;
  bool get highContrast => _highContrast;
  bool get voiceGuidance => _voiceGuidance;

  TokenModel? get activeToken => _activeToken;
  List<TokenModel> get allTokens => _allTokens;
  List<ApplicationModel> get applications => _applications;
  List<CitizenDocument> get documents => _documents;
  List<AppNotification> get notifications => _notifications;
  List<Map<String, dynamic>> get counters => _counters;

  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  AppState() {
    _initializeSeedData();
  }

  void _initializeSeedData() {
    // Initial active token matching user specification
    _activeToken = TokenModel(
      id: 'TKN-2026-A102',
      tokenNumber: 'A-102',
      citizenName: _userName,
      citizenPhone: _userPhone,
      serviceName: 'Ration Card',
      officeName: 'Alappuzha Taluk Office',
      officeAddress: 'Taluk Office Complex, Collectorate Road, Alappuzha, Kerala 688001',
      bookedDate: DateTime.now(),
      expectedTime: '11:45 AM Today',
      counterNumber: 'Counter 03',
      nowServingToken: 'A-097',
      peopleAhead: 5,
      estimatedWaitMinutes: 25,
      applicationId: 'APP-2026-RC8821',
      status: TokenStatus.active,
    );

    _allTokens = [_activeToken!];

    // Seed Applications
    final now = DateTime.now();
    _applications = [
      ApplicationModel(
        id: 'APP-2026-RC8821',
        serviceName: 'Ration Card',
        officeName: 'Alappuzha Taluk Office',
        createdAt: now.subtract(const Duration(hours: 2)),
        status: ApplicationStatus.underReview,
        applicantName: _userName,
        applicantPhone: _userPhone,
        applicantEmail: _userEmail,
        tokenNumber: 'A-102',
        formData: {
          'category': 'Priority Household (PHH)',
          'familyMembers': '4',
          'annualIncome': '₹ 1,20,000',
          'residenceStatus': 'Owned',
          'district': 'Alappuzha',
          'taluk': 'Ambalappuzha',
          'village': 'Aryad South',
        },
        uploadedDocs: [
          'Aadhaar Card (Family Head)',
          'Income Certificate (Revenue Dept)',
          'Electricity Bill (KSEB)'
        ],
        timeline: ApplicationModel.createDefaultTimeline(
          status: ApplicationStatus.underReview,
          createdDate: now.subtract(const Duration(hours: 2)),
        ),
      ),
      ApplicationModel(
        id: 'APP-2026-DL4419',
        serviceName: 'Driving Licence',
        officeName: 'Regional Transport Office (RTO)',
        createdAt: now.subtract(const Duration(days: 3)),
        status: ApplicationStatus.approved,
        applicantName: _userName,
        applicantPhone: _userPhone,
        applicantEmail: _userEmail,
        tokenNumber: 'R-055',
        formData: {
          'vehicleClass': 'LMV (Light Motor Vehicle)',
          'learnerLicenceNo': 'KL04-202600129',
          'bloodGroup': 'O+ve',
        },
        uploadedDocs: ['Learner Licence', 'Medical Fitness Certificate Form 1A'],
        timeline: ApplicationModel.createDefaultTimeline(
          status: ApplicationStatus.approved,
          createdDate: now.subtract(const Duration(days: 3)),
        ),
      ),
      ApplicationModel(
        id: 'APP-2026-BC1092',
        serviceName: 'Birth Certificate',
        officeName: 'City Municipal Corporation',
        createdAt: now.subtract(const Duration(days: 12)),
        status: ApplicationStatus.completed,
        applicantName: _userName,
        applicantPhone: _userPhone,
        applicantEmail: _userEmail,
        tokenNumber: 'B-014',
        formData: {
          'childName': 'Aarav Nair',
          'dateOfBirth': '14-08-2026',
          'hospital': 'Government General Hospital, Alappuzha',
        },
        uploadedDocs: ['Hospital Birth Card', 'Parents Aadhaar ID'],
        timeline: ApplicationModel.createDefaultTimeline(
          status: ApplicationStatus.completed,
          createdDate: now.subtract(const Duration(days: 12)),
        ),
      ),
    ];

    // Seed Documents Wallet
    _documents = [
      CitizenDocument(
        id: 'DOC-01',
        title: 'Aadhaar Card',
        type: DocumentType.aadhaar,
        documentNumber: 'XXXX-XXXX-9021',
        uploadDate: now.subtract(const Duration(days: 45)),
        status: DocumentValidationStatus.verified,
        fileSize: '1.2 MB',
        extractedData: OCRExtractedData(
          name: 'Rahul Nair',
          dob: '12-05-1992',
          documentNumber: '5842-9901-9021',
          address: 'House No. 42, Green Valley, Civil Station, Alappuzha - 688001',
          gender: 'Male',
        ),
      ),
      CitizenDocument(
        id: 'DOC-02',
        title: 'PAN Card',
        type: DocumentType.pan,
        documentNumber: 'BNVPN4512K',
        uploadDate: now.subtract(const Duration(days: 40)),
        status: DocumentValidationStatus.verified,
        fileSize: '840 KB',
        extractedData: OCRExtractedData(
          name: 'Rahul Nair',
          dob: '12-05-1992',
          documentNumber: 'BNVPN4512K',
          address: 'Civil Station, Alappuzha, Kerala',
          gender: 'Male',
        ),
      ),
      CitizenDocument(
        id: 'DOC-03',
        title: 'Driving Licence',
        type: DocumentType.drivingLicense,
        documentNumber: 'KL-04-201800291',
        uploadDate: now.subtract(const Duration(days: 20)),
        status: DocumentValidationStatus.verified,
        fileSize: '1.5 MB',
        extractedData: OCRExtractedData(
          name: 'Rahul Nair',
          dob: '12-05-1992',
          documentNumber: 'KL-04-201800291',
          address: 'House No. 42, Green Valley, Alappuzha',
          gender: 'Male',
        ),
      ),
      CitizenDocument(
        id: 'DOC-04',
        title: 'KSEB Electricity Bill',
        type: DocumentType.addressProof,
        documentNumber: '11540982710',
        uploadDate: now.subtract(const Duration(days: 5)),
        status: DocumentValidationStatus.verified,
        fileSize: '650 KB',
        extractedData: OCRExtractedData(
          name: 'Rahul Nair',
          dob: 'N/A',
          documentNumber: '11540982710',
          address: 'Consumer 42, Civil Station Ward, Alappuzha',
          gender: 'N/A',
        ),
      ),
    ];

    // Seed Notifications
    _notifications = [
      AppNotification(
        id: 'NOTIF-01',
        title: 'Token A-102 Update',
        message: 'Your token A-102 is approaching. Current serving token is A-097 at Counter 03.',
        category: NotificationCategory.queue,
        timestamp: now.subtract(const Duration(minutes: 5)),
        relatedId: 'A-102',
      ),
      AppNotification(
        id: 'NOTIF-02',
        title: 'Queue Moving Fast',
        message: '5 people are ahead of you. Estimated turn time is 25 minutes.',
        category: NotificationCategory.queue,
        timestamp: now.subtract(const Duration(minutes: 15)),
        relatedId: 'A-102',
      ),
      AppNotification(
        id: 'NOTIF-03',
        title: 'Application Submitted',
        message: 'Your application APP-2026-RC8821 for Ration Card has been submitted successfully.',
        category: NotificationCategory.application,
        timestamp: now.subtract(const Duration(hours: 2)),
        relatedId: 'APP-2026-RC8821',
      ),
      AppNotification(
        id: 'NOTIF-04',
        title: 'Document Verified',
        message: 'Your Aadhaar Card has been verified via OCR and locked in your Document Vault.',
        category: NotificationCategory.system,
        timestamp: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Role switching
  void setRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  // Auth methods
  void login(String identifier, String password) {
    _isAuthenticated = true;
    notifyListeners();
  }

  void signup({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) {
    _userName = fullName;
    _userPhone = phone;
    _userEmail = email;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void completeOnboarding() {
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  // Accessibility & Language
  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleLargeText(bool val) {
    _largeText = val;
    notifyListeners();
  }

  void toggleHighContrast(bool val) {
    _highContrast = val;
    notifyListeners();
  }

  void toggleVoiceGuidance(bool val) {
    _voiceGuidance = val;
    notifyListeners();
  }

  // Token & Queue Methods
  TokenModel bookToken({
    required String serviceName,
    required String officeName,
    required String officeAddress,
    required String expectedTime,
    String? linkedAppId,
  }) {
    final randInt = 100 + Random().nextInt(50);
    final tokenCode = 'A-$randInt';
    final appId = linkedAppId ?? 'APP-${DateTime.now().year}-${1000 + Random().nextInt(8999)}';

    final newToken = TokenModel(
      id: 'TKN-${DateTime.now().millisecondsSinceEpoch}',
      tokenNumber: tokenCode,
      citizenName: _userName,
      citizenPhone: _userPhone,
      serviceName: serviceName,
      officeName: officeName,
      officeAddress: officeAddress,
      bookedDate: DateTime.now(),
      expectedTime: expectedTime,
      counterNumber: 'Counter 02',
      nowServingToken: 'A-${randInt - 4}',
      peopleAhead: 4,
      estimatedWaitMinutes: 20,
      applicationId: appId,
      status: TokenStatus.active,
    );

    _activeToken = newToken;
    _allTokens.insert(0, newToken);

    // Add notification
    _notifications.insert(
      0,
      AppNotification(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Token Booked Successfully',
        message: 'Your token $tokenCode for $serviceName is booked at $officeName.',
        category: NotificationCategory.queue,
        timestamp: DateTime.now(),
        relatedId: tokenCode,
      ),
    );

    notifyListeners();
    return newToken;
  }

  void cancelActiveToken() {
    if (_activeToken != null) {
      _activeToken!.status = TokenStatus.cancelled;
      _notifications.insert(
        0,
        AppNotification(
          id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Token Cancelled',
          message: 'Your token ${_activeToken!.tokenNumber} has been cancelled.',
          category: NotificationCategory.queue,
          timestamp: DateTime.now(),
        ),
      );
      _activeToken = null;
      notifyListeners();
    }
  }

  // SIMULATE QUEUE PROGRESSION (Can be called from citizen live queue or Staff terminal)
  void progressQueue() {
    if (_activeToken == null || _activeToken!.status != TokenStatus.active) return;

    if (_activeToken!.peopleAhead > 1) {
      _activeToken!.peopleAhead -= 1;
      _activeToken!.estimatedWaitMinutes = max(3, _activeToken!.estimatedWaitMinutes - 5);
      
      // Update now serving
      final currentNum = int.tryParse(_activeToken!.nowServingToken.replaceAll(RegExp(r'[^0-9]'), '')) ?? 97;
      _activeToken!.nowServingToken = 'A-0${currentNum + 1}';

      _notifications.insert(
        0,
        AppNotification(
          id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Queue Moving Ahead',
          message: '${_activeToken!.peopleAhead} people are ahead of you for Token ${_activeToken!.tokenNumber}. Now serving ${_activeToken!.nowServingToken}.',
          category: NotificationCategory.queue,
          timestamp: DateTime.now(),
          relatedId: _activeToken!.tokenNumber,
        ),
      );
    } else if (_activeToken!.peopleAhead == 1) {
      _activeToken!.peopleAhead = 0;
      _activeToken!.estimatedWaitMinutes = 2;
      _activeToken!.nowServingToken = 'A-101';
      _notifications.insert(
        0,
        AppNotification(
          id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Your Turn is Approaching!',
          message: 'You are next! Please proceed near ${_activeToken!.counterNumber}.',
          category: NotificationCategory.queue,
          timestamp: DateTime.now(),
          relatedId: _activeToken!.tokenNumber,
        ),
      );
    } else {
      _activeToken!.status = TokenStatus.serving;
      _activeToken!.nowServingToken = _activeToken!.tokenNumber;
      _activeToken!.peopleAhead = 0;
      _activeToken!.estimatedWaitMinutes = 0;
      _notifications.insert(
        0,
        AppNotification(
          id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
          title: 'NOW CALLING YOUR TOKEN!',
          message: 'Token ${_activeToken!.tokenNumber}, please proceed immediately to ${_activeToken!.counterNumber}.',
          category: NotificationCategory.queue,
          timestamp: DateTime.now(),
          relatedId: _activeToken!.tokenNumber,
        ),
      );
    }
    notifyListeners();
  }

  // Staff Counter Actions
  void staffCallNext(String counterId) {
    final counterIndex = _counters.indexWhere((c) => c['id'] == counterId);
    if (counterIndex != -1) {
      final currentTok = _counters[counterIndex]['currentToken'] as String;
      final numPart = int.tryParse(currentTok.replaceAll(RegExp(r'[^0-9]'), '')) ?? 97;
      final prefix = currentTok.split('-')[0];
      final nextNum = numPart + 1;
      final nextTokenStr = '$prefix-0$nextNum';
      _counters[counterIndex]['currentToken'] = nextTokenStr;
      
      // If this corresponds to active citizen token, update citizen in real time!
      if (_activeToken != null && _activeToken!.counterNumber.contains(counterId.replaceAll('C-', '0'))) {
        progressQueue();
      }
      notifyListeners();
    }
  }

  void staffCompleteToken(String counterId) {
    final counterIndex = _counters.indexWhere((c) => c['id'] == counterId);
    if (counterIndex != -1) {
      if (_activeToken != null && _activeToken!.status == TokenStatus.serving) {
        _activeToken!.status = TokenStatus.completed;
      }
      staffCallNext(counterId);
    }
  }

  // Create & Submit Application
  ApplicationModel submitApplication({
    required String serviceName,
    required String officeName,
    required Map<String, dynamic> formData,
    required List<String> documents,
  }) {
    final appId = 'APP-${DateTime.now().year}-${1000 + Random().nextInt(8999)}';
    final newApp = ApplicationModel(
      id: appId,
      serviceName: serviceName,
      officeName: officeName,
      createdAt: DateTime.now(),
      status: ApplicationStatus.submitted,
      applicantName: _userName,
      applicantPhone: _userPhone,
      applicantEmail: _userEmail,
      formData: formData,
      uploadedDocs: documents,
      timeline: ApplicationModel.createDefaultTimeline(
        status: ApplicationStatus.submitted,
        createdDate: DateTime.now(),
      ),
    );

    _applications.insert(0, newApp);

    _notifications.insert(
      0,
      AppNotification(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Application Submitted',
        message: 'Your application $appId for $serviceName was submitted to $officeName.',
        category: NotificationCategory.application,
        timestamp: DateTime.now(),
        relatedId: appId,
      ),
    );

    notifyListeners();
    return newApp;
  }

  // Documents & OCR
  void addDocument(CitizenDocument doc) {
    _documents.insert(0, doc);
    notifyListeners();
  }

  void removeDocument(String docId) {
    _documents.removeWhere((d) => d.id == docId);
    notifyListeners();
  }

  // Notification management
  void markNotificationAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Update profile
  void updateProfile({
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    if (name != null) _userName = name;
    if (phone != null) _userPhone = phone;
    if (email != null) _userEmail = email;
    if (address != null) _userAddress = address;
    notifyListeners();
  }
}
