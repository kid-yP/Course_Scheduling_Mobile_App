import 'dart:io';
import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/resources/domain/entities/resource.dart';
import 'package:fpdart/fpdart.dart';

abstract class ResourceRepository {
  Future<Either<Failure, List<Resource>>> getResources({
    required int courseId,
    required int sectionId,
  });

  Future<Either<Failure, void>> uploadResource({
    required int courseId,
    required int sectionId,
    required String uploadedBy,
    required File file,
    required String fileName,
    required String description,
  });
}
