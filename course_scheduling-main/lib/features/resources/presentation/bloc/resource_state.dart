part of 'resource_bloc.dart';

@immutable
sealed class ResourceState {}

final class ResourceInitial extends ResourceState {}

final class ResourcesLoading extends ResourceState {}

final class ResourcesLoaded extends ResourceState {
  final List<Resource> resources;

  ResourcesLoaded({required this.resources});
}

final class ResourcesSuccess extends ResourceState {
  final String message;
  ResourcesSuccess({required this.message});
}

final class ResourcesFailure extends ResourceState {
  final String message;

  ResourcesFailure({required this.message});
}
