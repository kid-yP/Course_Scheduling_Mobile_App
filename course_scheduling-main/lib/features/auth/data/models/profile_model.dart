import 'package:course_scheduling/features/auth/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.userId,
    required super.role,
    required super.name,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      userId: map['id'],
      role: map['role'],
      name: map['username'],
    );
  }
}
