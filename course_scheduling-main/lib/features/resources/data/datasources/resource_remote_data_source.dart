import 'dart:io';

import 'package:course_scheduling/core/error/exceptions.dart';
import 'package:course_scheduling/features/resources/data/models/resource_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ResourceRemoteDataSource {
  Future<List<ResourceModel>> getResources({
    required int courseId,
    required int sectionId,
  });
  Future<void> uploadResource({
    required int courseId,
    required int sectionId,
    required String uploadedBy,
    required File file,
    required String fileName,
    required String description,
  });
}

class ResourceRemoteDataSourceImpl implements ResourceRemoteDataSource {
  final SupabaseClient supabaseClient;

  ResourceRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ResourceModel>> getResources({
    required int courseId,
    required int sectionId,
  }) async {
    try {
      final response = await supabaseClient
          .from('section_resources')
          .select()
          .eq('course_id', courseId)
          .eq('section_id', sectionId)
          .order('uploaded_at', ascending: false);

      return (response as List).map((e) => ResourceModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> uploadResource({
    required int courseId,
    required int sectionId,
    required String uploadedBy,
    required File file,
    required String fileName,
    required String description,
  }) async {
    try {
      // 1. Upload file to Supabase Storage
      final filePath = 'resources/${DateTime.now().toIso8601String()}_$fileName';

      try {
        await supabaseClient.storage.from('course_docs').upload(
              filePath,
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
      } catch (e) {
        print("Initial Upload Error: $e");
        if (e.toString().contains('Bucket not found') || e.toString().contains('StatusCode: 404')) {
           print("Bucket 'course_docs' not found. Attempting to create...");
           try {
             await supabaseClient.storage.createBucket('course_docs', const BucketOptions(public: true));
             print("Bucket created successfully. Retrying upload...");

             await supabaseClient.storage.from('course_docs').upload(
                filePath,
                file,
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
              print("Retry upload successful.");
           } catch (createError) {
              print("Failed to create bucket or retry upload: $createError");
              throw ServerException("Could not find or create 'course_docs' bucket. Please create it manually in Supabase. Error: $createError");
           }
        } else {
           rethrow;
        }
      }

      // 2. Get public URL
      final publicUrl =
          supabaseClient.storage.from('course_docs').getPublicUrl(filePath);

      // 3. Insert record into database
      await supabaseClient.from('section_resources').insert({
        'course_id': courseId,
        'section_id': sectionId,
        'uploaded_by': uploadedBy,
        'file_name': fileName,
        'file_url': publicUrl,
        'description': description,
      });
    } catch (e) {
      print("Final Upload Error: $e");
       if (e.toString().contains('new row violates row-level security policy')) {
         throw ServerException("Upload Failed: Permission Denied. Please add 'INSERT' policy to 'course_docs' bucket in Supabase Storage settings.");
       }
       if (e.toString().contains('Bucket not found')) {
         throw ServerException("Upload Failed: Bucket 'course_docs' not found. Please create it in Supabase Storage with 'Public' access.");
       }
      throw ServerException(e.toString());
    }
  }
}
