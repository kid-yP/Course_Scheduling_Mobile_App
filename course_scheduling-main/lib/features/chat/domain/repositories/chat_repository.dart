import 'package:course_scheduling/features/chat/domain/entities/chat_message.dart';
import 'package:fpdart/fpdart.dart';
import 'package:course_scheduling/core/error/failures.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> getMessages({required int chatRoomId});
  Future<Either<Failure, void>> sendMessage({
    required int chatRoomId,
    required String messageText,
    required String senderId,
  });
  Future<Either<Failure, int>> getChatRoomId({
    required int courseId,
    required int sectionId,
  });
  Future<Either<Failure, Map<String, String>>> getProfiles(List<String> userIds);
}
