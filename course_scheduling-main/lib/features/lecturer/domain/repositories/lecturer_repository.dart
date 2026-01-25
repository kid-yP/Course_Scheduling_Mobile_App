import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/lecturer/domain/entities/schedule_item.dart';
import 'package:fpdart/fpdart.dart';

abstract class LecturerRepository {
  Future<Either<Failure, List<ScheduleItem>>> getSchedule({required String lecturerId});
  Future<Either<Failure, void>> addScheduleItem({required ScheduleItem item});
  Future<Either<Failure, void>> updateScheduleItem({required ScheduleItem item});
  Future<Either<Failure, void>> deleteScheduleItem({required int id});
  Future<Either<Failure, List<Map<String, dynamic>>>> getLecturerAssignments({required String lecturerId});
}
