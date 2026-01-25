part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatRoomReady extends ChatState {
  final int chatRoomId;
  final List<ChatMessage> messages;

  ChatRoomReady({required this.chatRoomId, required this.messages});
}

final class ChatFailure extends ChatState {
  final String message;

  ChatFailure({required this.message});
}
