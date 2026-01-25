import 'package:course_scheduling/core/error/exceptions.dart';
import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:course_scheduling/features/chat/domain/entities/chat_message.dart';
import 'package:course_scheduling/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ChatMessage>> getMessages({required int chatRoomId}) {
    return remoteDataSource.getMessages(chatRoomId: chatRoomId);
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required int chatRoomId,
    required String messageText,
    required String senderId,
  }) async {
    try {
      await remoteDataSource.sendMessage(
        chatRoomId: chatRoomId,
        messageText: messageText,
        senderId: senderId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getChatRoomId({
    required int courseId,
    required int sectionId,
  }) async {
    try {
      final id = await remoteDataSource.getChatRoomId(
        courseId: courseId,
        sectionId: sectionId,
      );
      return Right(id);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getProfiles(List<String> userIds) async {
    try {
      final profiles = await remoteDataSource.getProfiles(userIds);
      return Right(profiles);
    } on ServerException catch (e) {
       return Left(Failure(e.message));
    }
  }
}
