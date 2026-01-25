import 'dart:io';

import 'package:course_scheduling/core/error/exceptions.dart';
import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/resources/data/datasources/resource_remote_data_source.dart';
import 'package:course_scheduling/features/resources/domain/entities/resource.dart';
import 'package:course_scheduling/features/resources/domain/repositories/resource_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceRemoteDataSource remoteDataSource;

  ResourceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Resource>>> getResources({
    required int courseId,
    required int sectionId,
  }) async {
    try {
      final resources = await remoteDataSource.getResources(
        courseId: courseId,
        sectionId: sectionId,
      );
      return Right(resources);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> uploadResource({
    required int courseId,
    required int sectionId,
    required String uploadedBy,
    required File file,
    required String fileName,
    required String description,
  }) async {
    try {
      await remoteDataSource.uploadResource(
        courseId: courseId,
        sectionId: sectionId,
        uploadedBy: uploadedBy,
        file: file,
        fileName: fileName,
        description: description,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
