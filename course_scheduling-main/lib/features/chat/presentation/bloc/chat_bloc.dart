import 'dart:async';

import 'package:course_scheduling/features/chat/domain/entities/chat_message.dart';
import 'package:course_scheduling/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatInitial()) {
    on<EnterChatRoom>(_onEnterChatRoom);
    on<SendMessage>(_onSendMessage);
    on<UpdateMessages>(_onUpdateMessages);
  }

  Future<void> _onEnterChatRoom(
    EnterChatRoom event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await _chatRepository.getChatRoomId(
      courseId: event.courseId,
      sectionId: event.sectionId,
    );

    result.fold(
      (failure) => emit(ChatFailure(message: failure.message)),
      (chatRoomId) {
        // Subscribe to messages
        _messagesSubscription?.cancel();
        _messagesSubscription = _chatRepository
            .getMessages(chatRoomId: chatRoomId)
            .listen((messages) {
          add(UpdateMessages(messages));
        });
        // We don't emit ChatLoaded yet, we wait for the first stream event or emit empty initially
        // But to keep UI responsive, we can emit ChatLoaded with empty list or wait.
        // Let's emit ChatLoaded with empty messages and let stream update it.
        // Actually best to just wait for stream, or emit ChatRoomReady(chatRoomId)
        emit(ChatRoomReady(chatRoomId: chatRoomId, messages: []));
      },
    );
  }

  // Cache for user names
  final Map<String, String> _userNames = {};

  Future<void> _onUpdateMessages(
      UpdateMessages event, Emitter<ChatState> emit) async {
    if (state is ChatRoomReady) {
      final currentState = state as ChatRoomReady;

      final messages = event.messages;
      final Set<String> userIdsToFetch = {};

      for (final msg in messages) {
        if (!_userNames.containsKey(msg.senderId)) {
          userIdsToFetch.add(msg.senderId);
        }
      }

      if (userIdsToFetch.isNotEmpty) {
        final result = await _chatRepository.getProfiles(userIdsToFetch.toList());
        result.fold(
          (failure) {
            // Log error or ignore?
            // We'll just display without names if fetch fails.
          },
          (profiles) {
            _userNames.addAll(profiles);
          },
        );
      }

      // Update messages with names
      final List<ChatMessage> updatedMessages = messages.map((msg) {
        return ChatMessage(
          id: msg.id,
          chatRoomId: msg.chatRoomId,
          senderId: msg.senderId,
          messageText: msg.messageText,
          createdAt: msg.createdAt,
          senderName: _userNames[msg.senderId],
        );
      }).toList();

      emit(ChatRoomReady(
        chatRoomId: currentState.chatRoomId,
        messages: List.from(updatedMessages), // Ensure new list reference
      ));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatRoomReady) {
      final currentState = state as ChatRoomReady;

      // Optimistic Update
      final optimisticMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch, // Temp ID
        chatRoomId: event.chatRoomId,
        senderId: event.senderId,
        messageText: event.messageText,
        createdAt: DateTime.now(),
        senderName: 'Me', // Placeholder, or fetch from auth/cache if available
      );

      final currentMessages = List<ChatMessage>.from(currentState.messages);
      // Newest at bottom: Append to end?
      // Wait, we decided "reversed: true" in UI means Index 0 is Bottom.
      // But we also inverted the query to "descending" (Newest First).
      // So list is [Newest, ..., Oldest].
      // So Newest should be at Index 0.

      currentMessages.insert(0, optimisticMessage); // Insert at start (Newest)

      emit(ChatRoomReady(
        chatRoomId: currentState.chatRoomId,
        messages: currentMessages,
      ));

      final result = await _chatRepository.sendMessage(
        chatRoomId: event.chatRoomId,
        messageText: event.messageText,
        senderId: event.senderId,
      );

      result.fold(
        (failure) {
             // Revert or show error? For now, we print error.
             print("SendMessage Error: ${failure.message}");
             // Ideally we should revert the optimistic message here
        },
        (success) => null, // Stream should eventually replace/confirm this
      );
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
