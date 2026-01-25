import 'package:course_scheduling/features/chat/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.chatRoomId,
    required super.senderId,
    required super.messageText,
    required super.createdAt,
    super.senderName,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as int,
      chatRoomId: json['chat_room_id'] as int,
      senderId: json['sender_id'] as String,
      messageText: json['message_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      senderName: json['profiles'] != null ? (json['profiles'] as Map<String, dynamic>)['username'] as String? : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message_text': messageText,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
