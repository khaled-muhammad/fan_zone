class MessageModel {
  final String id;
  final String teamId;
  final String senderId;
  final String? senderName;
  final String message;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.teamId,
    required this.senderId,
    this.senderName,
    required this.message,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final sender = json['senderId'];
    return MessageModel(
      id: json['_id'] ?? '',
      teamId: json['teamId'] ?? '',
      senderId: sender is Map ? sender['_id'] ?? '' : (sender ?? ''),
      senderName: sender is Map ? sender['fullName'] : null,
      message: json['message'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
