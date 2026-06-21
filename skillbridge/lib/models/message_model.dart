class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'],
        conversationId: json['conversationId'],
        senderId: json['senderId'],
        text: json['text'],
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      );
}

class ConversationModel {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String relatedSkillTitle;
  String lastMessage;
  DateTime lastMessageTime;
  bool unread;

  ConversationModel({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.relatedSkillTitle,
    required this.lastMessage,
    DateTime? lastMessageTime,
    this.unread = false,
  }) : lastMessageTime = lastMessageTime ?? DateTime.now();
}
