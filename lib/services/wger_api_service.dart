// lib/services/wger_api_service.dart

import 'package:dio/dio.dart';

import '../core/constants/app_constants.dart';
import '../core/errors/app_exceptions.dart';
import '../models/exercise.dart';
import '../models/muscle_group.dart';

class WgerApiService {
  late final Dio _dio;

  final Map<int, String> _apiIdCache = {};

  WgerApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.workoutXBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-WorkoutX-Key': AppConstants.workoutXApiKey,
        },
      ),
    );
  }

  /// A Home não depende da API.
  /// Isso evita timeout na tela principal.
  Future<List<MuscleGroup>> fetchMuscleGroups() async {
    return MuscleGroup.defaultGroups();
  }

  /// Busca exercícios por grupo muscular usando bodyPart da WorkoutX.
  Future<List<Exercise>> fetchExercisesByCategory(int categoryId) async {
    try {
      _validateApiKey();

      final bodyPart = _bodyPartFromCategoryId(categoryId);

      final response = await _dio.get(
        '/exercises/bodyPart/$bodyPart',
        queryParameters: {
          'limit': 10,
          'offset': 0,
        },
      );

      final results = _extractExerciseList(response.data);

      final exercises = results
          .whereType<Map<String, dynamic>>()
          .map((json) => Exercise.fromJson(json))
          .where((exercise) => exercise.name != 'Exercício sem nome')
          .toList();

      _cacheApiIds(exercises);

      return exercises;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ApiException('Erro ao carregar exercícios: $e');
    }
  }

  /// Busca exercícios por nome usando o endpoint /name/:name.
  Future<List<Exercise>> searchExercises(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      _validateApiKey();

      final encodedName = Uri.encodeComponent(query.trim());

      final response = await _dio.get(
        '/exercises/name/$encodedName',
      );

      final results = _extractExerciseList(response.data);

      final exercises = results
          .whereType<Map<String, dynamic>>()
          .map((json) => Exercise.fromJson(json))
          .where((exercise) => exercise.name != 'Exercício sem nome')
          .take(10)
          .toList();

      _cacheApiIds(exercises);

      return exercises;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ApiException('Erro ao buscar exercícios: $e');
    }
  }

  /// Busca detalhes completos de um exercício pelo ID interno numérico.
  Future<Exercise> fetchExerciseDetail(int exerciseId) async {
    try {
      _validateApiKey();

      final apiId = _apiIdCache[exerciseId];

      if (apiId == null || apiId.isEmpty) {
        throw const ApiException(
          'Não foi possível localizar o ID original do exercício.',
        );
      }

      final response = await _dio.get('/exercises/exercise/$apiId');

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const ApiException('Resposta inválida ao carregar exercício.');
      }

      final exercise = Exercise.fromJson(data);
      _cacheApiIds([exercise]);

      return exercise;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ApiException('Erro ao carregar detalhes do exercício: $e');
    }
  }

  List<dynamic> _extractExerciseList(dynamic data) {
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final possibleData = data['data'];

      if (possibleData is List) {
        return possibleData;
      }

      final results = data['results'];

      if (results is List) {
        return results;
      }
    }

    return [];
  }

  void _cacheApiIds(List<Exercise> exercises) {
    for (final exercise in exercises) {
      if (exercise.apiId.isNotEmpty) {
        _apiIdCache[exercise.id] = exercise.apiId;
      }
    }
  }

  void _validateApiKey() {
    if (AppConstants.workoutXApiKey.trim().isEmpty) {
      throw const ApiException(
        'Chave da WorkoutX não configurada. Rode com --dart-define=WORKOUTX_API_KEY=SUA_CHAVE.',
      );
    }
  }

  String _bodyPartFromCategoryId(int categoryId) {
    switch (categoryId) {
      case 10:
        return 'waist';
      case 8:
        return 'upper arms';
      case 12:
        return 'back';
      case 14:
        return 'lower legs';
      case 15:
        return 'cardio';
      case 11:
        return 'chest';
      case 9:
        return 'upper legs';
      case 13:
        return 'shoulders';
      default:
        return 'chest';
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
        final message = _extractErrorMessage(error.response?.data);

        if (statusCode == 401) {
          return ApiException(
            'Chave da WorkoutX ausente ou inválida.',
            statusCode: statusCode,
          );
        }

        if (statusCode == 403) {
          return ApiException(
            'Acesso negado pela WorkoutX. Verifique seu plano ou chave.',
            statusCode: statusCode,
          );
        }

        if (statusCode == 429) {
          return ApiException(
            'Limite de requisições da WorkoutX excedido. Aguarde e tente novamente.',
            statusCode: statusCode,
          );
        }

        return ApiException(
          message.isNotEmpty
              ? message
              : 'Erro na API (código $statusCode). Tente novamente.',
          statusCode: statusCode,
        );

      default:
        return const NetworkException();
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString() ?? '';
      if (message.isNotEmpty) return message;

      final error = data['error']?.toString() ?? '';
      if (error.isNotEmpty) return error;
    }

    return '';
  }
}