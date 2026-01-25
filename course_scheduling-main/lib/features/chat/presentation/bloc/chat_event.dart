part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class EnterChatRoom extends ChatEvent {
  final int courseId;
  final int sectionId;

  EnterChatRoom({required this.courseId, required this.sectionId});
}

class SendMessage extends ChatEvent {
  final int chatRoomId;
  final String messageText;
  final String senderId;

  SendMessage({
    required this.chatRoomId,
    required this.messageText,
    required this.senderId,
  });
}

class UpdateMessages extends ChatEvent {
  final List<ChatMessage> messages;
  UpdateMessages(this.messages);
}
