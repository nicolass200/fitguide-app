import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../services/workout_database_service.dart';
import '../core/errors/app_exceptions.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutDatabaseService _databaseService;

  WorkoutProvider(this._databaseService);

  List<Workout> _workouts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  Future<void> loadWorkouts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _workouts = await _databaseService.fetchAllWorkouts();
    } on DatabaseAppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Erro ao carregar treinos.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createWorkout(String name, List<WorkoutExercise> exercises) async {
    if (name.trim().isEmpty) return false;

    try {
      final workout = Workout(
        name: name.trim(),
        createdAt: DateTime.now(),
        exercises: exercises,
      );
      await _databaseService.insertWorkout(workout);
      await loadWorkouts();
      return true;
    } on DatabaseAppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> renameWorkout(int workoutId, String newName) async {
    if (newName.trim().isEmpty) return false;

    try {
      await _databaseService.updateWorkoutName(workoutId, newName.trim());
      await loadWorkouts();
      return true;
    } on DatabaseAppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteWorkout(int workoutId) async {
    try {
      await _databaseService.deleteWorkout(workoutId);
      _workouts.removeWhere((w) => w.id == workoutId);
      notifyListeners();
    } on DatabaseAppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<void> removeExerciseFromWorkout(int workoutExerciseId) async {
    try {
      await _databaseService.deleteWorkoutExercise(workoutExerciseId);
      await loadWorkouts();
    } on DatabaseAppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
