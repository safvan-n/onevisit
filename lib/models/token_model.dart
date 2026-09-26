enum TokenStatus {
  active,
  serving,
  completed,
  cancelled,
}

class TokenModel {
  final String id;
  final String tokenNumber;
  final String citizenName;
  final String citizenPhone;
  final String serviceName;
  final String officeName;
  final String officeAddress;
  final DateTime bookedDate;
  final String expectedTime;
  final String counterNumber;
  String nowServingToken;
  TokenStatus status;
  int peopleAhead;
  int estimatedWaitMinutes;
  final String applicationId;

  TokenModel({
    required this.id,
    required this.tokenNumber,
    required this.citizenName,
    required this.citizenPhone,
    required this.serviceName,
    required this.officeName,
    required this.officeAddress,
    required this.bookedDate,
    required this.expectedTime,
    this.counterNumber = 'Counter 03',
    this.nowServingToken = 'A-097',
    this.status = TokenStatus.active,
    this.peopleAhead = 5,
    this.estimatedWaitMinutes = 25,
    required this.applicationId,
  });

  String get qrPayload =>
      'ONEVISIT:TKN=$tokenNumber;APP=$applicationId;SRV=$serviceName;OFF=$officeName;CIT=$citizenName;STATUS=${status.name}';

  TokenModel copyWith({
    String? id,
    String? tokenNumber,
    String? citizenName,
    String? citizenPhone,
    String? serviceName,
    String? officeName,
    String? officeAddress,
    DateTime? bookedDate,
    String? expectedTime,
    String? counterNumber,
    String? nowServingToken,
    TokenStatus? status,
    int? peopleAhead,
    int? estimatedWaitMinutes,
    String? applicationId,
  }) {
    return TokenModel(
      id: id ?? this.id,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      citizenName: citizenName ?? this.citizenName,
      citizenPhone: citizenPhone ?? this.citizenPhone,
      serviceName: serviceName ?? this.serviceName,
      officeName: officeName ?? this.officeName,
      officeAddress: officeAddress ?? this.officeAddress,
      bookedDate: bookedDate ?? this.bookedDate,
      expectedTime: expectedTime ?? this.expectedTime,
      counterNumber: counterNumber ?? this.counterNumber,
      nowServingToken: nowServingToken ?? this.nowServingToken,
      status: status ?? this.status,
      peopleAhead: peopleAhead ?? this.peopleAhead,
      estimatedWaitMinutes: estimatedWaitMinutes ?? this.estimatedWaitMinutes,
      applicationId: applicationId ?? this.applicationId,
    );
  }
}
