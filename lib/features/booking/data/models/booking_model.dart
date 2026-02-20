class BookingModel {
  final String id;
  final String userId;
  final String pitchId;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String paymentMethod;
  final String qrCodeToken;
  final String? pitchName;
  final String? pitchLocation;
  final double? pitchPrice;
  final String? userName;

  BookingModel({
    required this.id,
    required this.userId,
    required this.pitchId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.paymentMethod,
    required this.qrCodeToken,
    this.pitchName,
    this.pitchLocation,
    this.pitchPrice,
    this.userName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final pitch = json['pitchId'];
    final user = json['userId'];

    return BookingModel(
      id: json['_id'] ?? '',
      userId: pitch is Map ? '' : (json['userId'] ?? ''),
      pitchId: pitch is Map ? pitch['_id'] ?? '' : (json['pitchId'] ?? ''),
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      status: json['status'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      qrCodeToken: json['qrCodeToken'] ?? '',
      pitchName: pitch is Map ? pitch['name'] : null,
      pitchLocation: pitch is Map ? pitch['locationName'] : null,
      pitchPrice: pitch is Map ? (pitch['pricePerHour'] ?? 0).toDouble() : null,
      userName: user is Map ? user['fullName'] : null,
    );
  }
}
