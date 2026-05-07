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
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  /// Busca todos os grupos musculares disponíveis na WGER API.
  Future<List<MuscleGroup>> fetchMuscleGroups() async {
    try {
      final response = await _dio.get(
        '/exercisecategory/',
        queryParameters: {
          'format': 'json',
          'limit': 100,
        },
      );

      final results = response.data['results'] as List<dynamic>? ?? [];

      return results
          .whereType<Map<String, dynamic>>()
          .map((json) => MuscleGroup.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Erro ao carregar grupos musculares: $e');
    }
  }

  /// Busca exercícios de um grupo muscular específico.
  ///
  /// Usa exerciseinfo porque esse endpoint já traz traduções, imagens,
  /// músculos e categoria em uma resposta mais completa.
  Future<List<Exercise>> fetchExercisesByCategory(int categoryId) async {
    try {
      final response = await _dio.get(
        '/exerciseinfo/',
        queryParameters: {
          'format': 'json',
          'category': categoryId,
          'language': 7,
          'status': 2,
          'limit': 50,
          'offset': 0,
        },
      );

      final results = response.data['results'] as List<dynamic>? ?? [];

      final exercises = results
          .whereType<Map<String, dynamic>>()
          .map((json) => Exercise.fromJson(json))
          .where((exercise) => exercise.name != 'Exercício sem nome')
          .toList();

      if (exercises.isNotEmpty) {
        return exercises;
      }

      return _fetchExercisesByCategoryFallback(categoryId);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Erro ao carregar exercícios: $e');
    }
  }

  /// Fallback em inglês caso o português não retorne bons dados.
  Future<List<Exercise>> _fetchExercisesByCategoryFallback(int categoryId) async {
    final response = await _dio.get(
      '/exerciseinfo/',
      queryParameters: {
        'format': 'json',
        'category': categoryId,
        'language': 2,
        'status': 2,
        'limit': 50,
        'offset': 0,
      },
    );

    final results = response.data['results'] as List<dynamic>? ?? [];

    return results
        .whereType<Map<String, dynamic>>()
        .map((json) => Exercise.fromJson(json))
        .where((exercise) => exercise.name != 'Exercício sem nome')
        .toList();
  }

  /// Busca exercícios por nome para a barra de busca.
  Future<List<Exercise>> searchExercises(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        '/exerciseinfo/',
        queryParameters: {
          'format': 'json',
          'language': 7,
          'status': 2,
          'limit': 100,
          'offset': 0,
        },
      );

      final results = response.data['results'] as List<dynamic>? ?? [];

      final search = query.trim().toLowerCase();

      return results
          .whereType<Map<String, dynamic>>()
          .map((json) => Exercise.fromJson(json))
          .where((exercise) {
            final name = exercise.name.toLowerCase();
            final description = exercise.cleanDescription.toLowerCase();

            return name.contains(search) || description.contains(search);
          })
          .where((exercise) => exercise.name != 'Exercício sem nome')
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Erro ao buscar exercícios: $e');
    }
  }

  /// Busca detalhes completos de um exercício pelo ID.
  Future<Exercise> fetchExerciseDetail(int exerciseId) async {
    try {
      final response = await _dio.get(
        '/exerciseinfo/$exerciseId/',
        queryParameters: {
          'format': 'json',
          'language': 7,
        },
      );

      return Exercise.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Erro ao carregar detalhes do exercício: $e');
    }
  }

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