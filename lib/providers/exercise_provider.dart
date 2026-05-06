// lib/providers/exercise_provider.dart

import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import '../models/muscle_group.dart';
import '../services/wger_api_service.dart';
import '../core/errors/app_exceptions.dart';

enum LoadingState { idle, loading, success, error }

class ExerciseProvider extends ChangeNotifier {
  final WgerApiService _apiService;

  ExerciseProvider(this._apiService);

  // ── Estado dos grupos musculares ──
  List<MuscleGroup> _muscleGroups = [];
  LoadingState _muscleGroupsState = LoadingState.idle;
  String _muscleGroupsError = '';

  // ── Estado dos exercícios ──
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  LoadingState _exercisesState = LoadingState.idle;
  String _exercisesError = '';

  // ── Estado do detalhe ──
  Exercise? _selectedExercise;
  LoadingState _detailState = LoadingState.idle;
  String _detailError = '';

  // ── Busca ──
  String _searchQuery = '';

  // ── Getters ──
  List<MuscleGroup> get muscleGroups => _muscleGroups;
  LoadingState get muscleGroupsState => _muscleGroupsState;
  String get muscleGroupsError => _muscleGroupsError;

  List<Exercise> get exercises => _filteredExercises;
  LoadingState get exercisesState => _exercisesState;
  String get exercisesError => _exercisesError;

  Exercise? get selectedExercise => _selectedExercise;
  LoadingState get detailState => _detailState;
  String get detailError => _detailError;

  String get searchQuery => _searchQuery;

  bool get isMuscleGroupsLoading => _muscleGroupsState == LoadingState.loading;
  bool get isExercisesLoading => _exercisesState == LoadingState.loading;
  bool get isDetailLoading => _detailState == LoadingState.loading;

  // ── Ações ──

  Future<void> loadMuscleGroups() async {
    if (_muscleGroupsState == LoadingState.loading) return;

    _muscleGroupsState = LoadingState.loading;
    _muscleGroupsError = '';
    notifyListeners();

    try {
      _muscleGroups = await _apiService.fetchMuscleGroups();
      _muscleGroupsState = LoadingState.success;
    } on AppException catch (e) {
      _muscleGroupsState = LoadingState.error;
      _muscleGroupsError = e.message;
      debugPrint('❌ AppException em loadMuscleGroups: ${e.message}');
    } catch (e, stackTrace) {
      _muscleGroupsState = LoadingState.error;
      _muscleGroupsError = 'Erro inesperado. Tente novamente.';
      debugPrint('❌ ERRO INESPERADO em loadMuscleGroups: $e');
      debugPrint('📍 STACK: $stackTrace');
    }

    notifyListeners();
  }

  Future<void> loadExercisesByCategory(int categoryId) async {
    _exercisesState = LoadingState.loading;
    _exercisesError = '';
    _searchQuery = '';
    notifyListeners();

    try {
      _exercises = await _apiService.fetchExercisesByCategory(categoryId);
      _filteredExercises = List.from(_exercises);
      _exercisesState = LoadingState.success;
    } on AppException catch (e) {
      _exercisesState = LoadingState.error;
      _exercisesError = e.message;
      debugPrint('❌ AppException em loadExercisesByCategory: ${e.message}');
    } catch (e, stackTrace) {
      _exercisesState = LoadingState.error;
      _exercisesError = 'Erro inesperado. Tente novamente.';
      debugPrint('❌ ERRO INESPERADO em loadExercisesByCategory: $e');
      debugPrint('📍 STACK: $stackTrace');
    }

    notifyListeners();
  }

  Future<void> loadExerciseDetail(int exerciseId) async {
    _detailState = LoadingState.loading;
    _detailError = '';
    notifyListeners();

    try {
      _selectedExercise = await _apiService.fetchExerciseDetail(exerciseId);
      _detailState = LoadingState.success;
    } on AppException catch (e) {
      _detailState = LoadingState.error;
      _detailError = e.message;
      debugPrint('❌ AppException em loadExerciseDetail: ${e.message}');
    } catch (e, stackTrace) {
      _detailState = LoadingState.error;
      _detailError = 'Erro inesperado. Tente novamente.';
      debugPrint('❌ ERRO INESPERADO em loadExerciseDetail: $e');
      debugPrint('📍 STACK: $stackTrace');
    }

    notifyListeners();
  }

  /// Filtra exercícios localmente pelo nome digitado
  void filterExercises(String query) {
    _searchQuery = query;

    if (query.trim().isEmpty) {
      _filteredExercises = List.from(_exercises);
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredExercises = _exercises
          .where((e) => e.name.toLowerCase().contains(lowerQuery))
          .toList();
    }

    notifyListeners();
  }

  void clearExercises() {
    _exercises = [];
    _filteredExercises = [];
    _exercisesState = LoadingState.idle;
    _searchQuery = '';
    notifyListeners();
  }
}