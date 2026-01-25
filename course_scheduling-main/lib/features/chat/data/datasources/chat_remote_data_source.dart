import 'package:course_scheduling/core/error/exceptions.dart';
import 'package:course_scheduling/features/chat/data/models/chat_message_model.dart';
import 'package:course_scheduling/features/chat/domain/entities/chat_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessageModel>> getMessages({required int chatRoomId});
  Future<void> sendMessage({
    required int chatRoomId,
    required String messageText,
    required String senderId,
  });
  Future<int> getChatRoomId({required int courseId, required int sectionId});
  Future<Map<String, String>> getProfiles(List<String> userIds);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;

  ChatRemoteDataSourceImpl(this.supabaseClient);

  @override
  Stream<List<ChatMessageModel>> getMessages({required int chatRoomId}) {
    return supabaseClient
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('chat_room_id', chatRoomId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => ChatMessageModel.fromJson(json)).toList());
        // Note: Supabase stream doesn't inherently support joining tables (like profiles) easily in the stream event payload in older versions.
        // If we strictly need username in real-time, we might need a fetch or view.
        // For now, let's assume we might need to fetch user details separately or rely on simple IDs.
        // Actually, let's stick to simple implementation first. The Model expects 'profiles' for username.
        // Standard supabase stream returns the row of the table. It won't have 'profiles' joined.
        // We'll address this by either fetching profiles or accepting that names might be missing in stream updates initially.
  }

  @override
  Future<void> sendMessage({
    required int chatRoomId,
    required String messageText,
    required String senderId,
  }) async {
    try {
      await supabaseClient.from('chat_messages').insert({
        'chat_room_id': chatRoomId,
        'sender_id': senderId,
        'message_text': messageText,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getChatRoomId({
    required int courseId,
    required int sectionId,
  }) async {
    try {
      final response = await supabaseClient
          .from('chat_rooms')
          .select('id')
          .eq('course_id', courseId)
          .eq('section_id', sectionId)
          .maybeSingle();

      if (response == null) {
        // Create one if it doesn't exist? Or throw?
        // Usually creation happens when course/section is created.
        // Let's try to create if missing, or return error.
        // For now, let's auto-create for robustness.
        final newRoom = await supabaseClient
            .from('chat_rooms')
            .insert({'course_id': courseId, 'section_id': sectionId})
            .select()
            .single();
        return newRoom['id'];
      }
      return response['id'];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, String>> getProfiles(List<String> userIds) async {
    try {
      if (userIds.isEmpty) return {};
      final response = await supabaseClient
          .from('profiles')
          .select('id, username')
          .filter('id', 'in', userIds);

      final Map<String, String> profiles = {};
      for (final row in response) {
        profiles[row['id'] as String] = row['username'] as String;
      }
      return profiles;
    } catch (e) {
       // Fail silently or throw? Throwing is better for debug, but we return empty map on failure in Bloc logic usually?
       // Let's throw ServerException as standard.
       throw ServerException(e.toString());
    }
  }
}
