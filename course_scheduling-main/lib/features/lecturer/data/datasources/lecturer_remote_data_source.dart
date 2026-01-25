import 'package:course_scheduling/core/error/exceptions.dart';
import 'package:course_scheduling/features/lecturer/data/models/schedule_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LecturerRemoteDataSource {
  Future<List<ScheduleItemModel>> getSchedule({required String lecturerId});
  Future<void> addScheduleItem({required ScheduleItemModel item});
  Future<void> updateScheduleItem({required ScheduleItemModel item});
  Future<void> deleteScheduleItem({required int id});
  Future<List<Map<String, dynamic>>> getLecturerAssignments({required String lecturerId});
}

class LecturerRemoteDataSourceImpl implements LecturerRemoteDataSource {
  final SupabaseClient supabaseClient;

  LecturerRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ScheduleItemModel>> getSchedule({required String lecturerId}) async {
    try {
      final response = await supabaseClient
          .from('weekly_schedule')
          .select('*, courses(name), sections(name)')
          .eq('lecturer_id', lecturerId)
          .order('day_of_week')
          .order('start_time');

      return (response as List).map((e) => ScheduleItemModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addScheduleItem({required ScheduleItemModel item}) async {
    try {
      final data = item.toJson();
      data.remove('id');
      await supabaseClient.from('weekly_schedule').insert(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateScheduleItem({required ScheduleItemModel item}) async {
    try {
      final data = item.toJson();
      data.remove('courses'); // Remove joined table data if present
      data.remove('sections');
      await supabaseClient
          .from('weekly_schedule')
          .update(data)
          .eq('id', item.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteScheduleItem({required int id}) async {
    try {
      await supabaseClient.from('weekly_schedule').delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getLecturerAssignments({required String lecturerId}) async {
    try {
      final response = await supabaseClient
          .from('lecturer_assignments')
          .select('course_id, section_id, courses(name), sections(name, semester, year)')
          .eq('lecturer_id', lecturerId);

      // Return list of maps with course/section info
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
