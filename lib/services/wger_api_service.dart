// lib/services/wger_api_service.dart

import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/app_exceptions.dart';
import '../models/exercise.dart';
import '../models/muscle_group.dart';

class WgerApiService {
  late final Dio _dio;

  WgerApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.wgerBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  /// Busca todos os grupos musculares disponíveis na WGER API
  Future<List<MuscleGroup>> fetchMuscleGroups() async {
    try {
      final response = await _dio.get('/exercisecategory/', queryParameters: {
        'format': 'json',
        'limit': 100,
      });

      final results = response.data['results'] as List<dynamic>;
      return results.map((json) => MuscleGroup.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Busca exercícios de um grupo muscular específico
  Future<List<Exercise>> fetchExercisesByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/exercise/', queryParameters: {
        'format': 'json',
        'category': categoryId,
        'language': AppConstants.wgerLanguageEn,
        'status': 2,
        'limit': 50,
        'offset': 0,
      });

      final results = response.data['results'] as List<dynamic>;
      return results.map((json) => Exercise.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Busca exercícios por nome (para a barra de busca)
  Future<List<Exercise>> searchExercises(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get('/exercise/search/', queryParameters: {
        'term': query,
        'language': 'english',
        'format': 'json',
      });

      // O endpoint de busca retorna formato diferente
      final suggestions = response.data['suggestions'] as List<dynamic>? ?? [];
      return suggestions.map((item) {
        final data = item['data'] as Map<String, dynamic>;
        return Exercise(
          id: data['id'] as int,
          name: item['value'] as String,
          description: '',
          categoryId: 0,
          categoryName: '',
          imageUrls: [],
          muscleIds: [],
        );
      }).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Busca detalhes completos de um exercício pelo ID
  Future<Exercise> fetchExerciseDetail(int exerciseId) async {
    try {
      final response = await _dio.get('/exerciseinfo/$exerciseId/', queryParameters: {
        'format': 'json',
      });

      return Exercise.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Converte erros do Dio em exceções tratáveis da aplicação
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return ApiException(
          'Erro na API (código $statusCode). Tente novamente.',
          statusCode: statusCode,
        );
      default:
        return const NetworkException();
    }
  }
}
