import 'dart:io';

import 'package:course_scheduling/features/resources/domain/entities/resource.dart';
import 'package:course_scheduling/features/resources/domain/repositories/resource_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'resource_event.dart';
part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final ResourceRepository _resourceRepository;

  ResourceBloc({required ResourceRepository resourceRepository})
      : _resourceRepository = resourceRepository,
        super(ResourceInitial()) {
    on<LoadResources>(_onLoadResources);
    on<UploadResourceEvent>(_onUploadResource);
  }

  Future<void> _onLoadResources(
    LoadResources event,
    Emitter<ResourceState> emit,
  ) async {
    emit(ResourcesLoading());
    final result = await _resourceRepository.getResources(
      courseId: event.courseId,
      sectionId: event.sectionId,
    );
    result.fold(
      (failure) => emit(ResourcesFailure(message: failure.message)),
      (resources) => emit(ResourcesLoaded(resources: resources)),
    );
  }

  Future<void> _onUploadResource(
    UploadResourceEvent event,
    Emitter<ResourceState> emit,
  ) async {
    emit(ResourcesLoading());
    final result = await _resourceRepository.uploadResource(
      courseId: event.courseId,
      sectionId: event.sectionId,
      uploadedBy: event.uploadedBy,
      file: event.file,
      fileName: event.fileName,
      description: event.description,
    );
    result.fold(
      (failure) => emit(ResourcesFailure(message: failure.message)),
      (_) {
        emit(ResourcesSuccess(message: "Resource uploaded successfully"));
        // Reload resources after upload
        add(LoadResources(
            courseId: event.courseId, sectionId: event.sectionId));
      },
    );
  }
}
