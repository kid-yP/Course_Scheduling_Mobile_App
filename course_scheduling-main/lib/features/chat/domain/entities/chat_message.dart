class ChatMessage {
  final int id;
  final int chatRoomId; // References chat_rooms(id)
  final String senderId; // References profiles(id)
  final String messageText;
  final DateTime createdAt;
  final String? senderName;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.messageText,
    required this.createdAt,
    this.senderName,
  });
}
