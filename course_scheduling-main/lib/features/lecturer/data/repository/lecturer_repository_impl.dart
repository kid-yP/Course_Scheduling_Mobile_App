import 'package:course_scheduling/core/error/exceptions.dart';
import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/lecturer/data/datasources/lecturer_remote_data_source.dart';
import 'package:course_scheduling/features/lecturer/data/models/schedule_item_model.dart';
import 'package:course_scheduling/features/lecturer/domain/entities/schedule_item.dart';
import 'package:course_scheduling/features/lecturer/domain/repositories/lecturer_repository.dart';
import 'package:fpdart/fpdart.dart';

class LecturerRepositoryImpl implements LecturerRepository {
  final LecturerRemoteDataSource remoteDataSource;

  LecturerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ScheduleItem>>> getSchedule({required String lecturerId}) async {
    try {
      final schedule = await remoteDataSource.getSchedule(lecturerId: lecturerId);
      return Right(schedule);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addScheduleItem({required ScheduleItem item}) async {
    try {
      final model = ScheduleItemModel(
        id: item.id,
        courseId: item.courseId,
        sectionId: item.sectionId,
        lecturerId: item.lecturerId,
        dayOfWeek: item.dayOfWeek,
        startTime: item.startTime,
        endTime: item.endTime,
        location: item.location,
      );
      await remoteDataSource.addScheduleItem(item: model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateScheduleItem({required ScheduleItem item}) async {
    try {
      final model = ScheduleItemModel(
        id: item.id,
        courseId: item.courseId,
        sectionId: item.sectionId,
        lecturerId: item.lecturerId,
        dayOfWeek: item.dayOfWeek,
        startTime: item.startTime,
        endTime: item.endTime,
        location: item.location,
      );
      await remoteDataSource.updateScheduleItem(item: model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteScheduleItem({required int id}) async {
    try {
      await remoteDataSource.deleteScheduleItem(id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getLecturerAssignments({required String lecturerId}) async {
     try {
      final assignments = await remoteDataSource.getLecturerAssignments(lecturerId: lecturerId);
      return Right(assignments);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
