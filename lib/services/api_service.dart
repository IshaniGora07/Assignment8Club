import 'package:dio/dio.dart';
import '../models/experience.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://staging.chamberofsecrets.8club.co',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  Future<List<Experience>> getExperiences() async {
    try {
      final response = await _dio.get('/v1/experiences?active=true');

      if (response.statusCode == 200) {
        final experienceResponse = ExperienceResponse.fromJson(response.data);
        return experienceResponse.experiences;
      } else {
        throw Exception('Failed to load experiences');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else {
        throw Exception('Failed to load experiences: ${e.message}');
      }
    }
  }
}
