// lib/services/workout_database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/app_exceptions.dart';
import '../models/workout.dart';

class WorkoutDatabaseService {
  static Database? _database;

  /// Singleton: garante uma única instância do banco
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabela de treinos
    await db.execute('''
      CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabela de exercícios de cada treino
    await db.execute('''
      CREATE TABLE workout_exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        exercise_name TEXT NOT NULL,
        series INTEGER NOT NULL DEFAULT 3,
        FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE
      )
    ''');
  }

  // ──────────────────────────────────────────────
  // CREATE
  // ──────────────────────────────────────────────

  /// Salva um novo treino e retorna o ID gerado
  Future<int> insertWorkout(Workout workout) async {
    try {
      final db = await database;
      final workoutId = await db.insert('workouts', workout.toMap()..remove('id'));

      for (final exercise in workout.exercises) {
        await db.insert('workout_exercises', {
          'workout_id': workoutId,
          'exercise_id': exercise.exerciseId,
          'exercise_name': exercise.exerciseName,
          'series': exercise.series,
        });
      }

      return workoutId;
    } catch (e) {
      throw DatabaseAppException('Erro ao salvar treino: $e');
    }
  }

  /// Adiciona um exercício a um treino existente
  Future<void> insertWorkoutExercise(WorkoutExercise exercise) async {
    try {
      final db = await database;
      await db.insert('workout_exercises', exercise.toMap()..remove('id'));
    } catch (e) {
      throw DatabaseAppException('Erro ao adicionar exercício: $e');
    }
  }

  // ──────────────────────────────────────────────
  // READ
  // ──────────────────────────────────────────────

  /// Retorna todos os treinos com seus exercícios
  Future<List<Workout>> fetchAllWorkouts() async {
    try {
      final db = await database;
      final workoutMaps = await db.query(
        'workouts',
        orderBy: 'created_at DESC',
      );

      final List<Workout> workouts = [];

      for (final map in workoutMaps) {
        final exercises = await _fetchExercisesForWorkout(db, map['id'] as int);
        workouts.add(Workout.fromMap(map).copyWith(exercises: exercises));
      }

      return workouts;
    } catch (e) {
      throw DatabaseAppException('Erro ao carregar treinos: $e');
    }
  }

  Future<List<WorkoutExercise>> _fetchExercisesForWorkout(
    Database db,
    int workoutId,
  ) async {
    final maps = await db.query(
      'workout_exercises',
      where: 'workout_id = ?',
      whereArgs: [workoutId],
    );
    return maps.map(WorkoutExercise.fromMap).toList();
  }

  // ──────────────────────────────────────────────
  // UPDATE
  // ──────────────────────────────────────────────

  /// Atualiza o nome de um treino
  Future<void> updateWorkoutName(int workoutId, String newName) async {
    try {
      final db = await database;
      await db.update(
        'workouts',
        {'name': newName},
        where: 'id = ?',
        whereArgs: [workoutId],
      );
    } catch (e) {
      throw DatabaseAppException('Erro ao atualizar treino: $e');
    }
  }

  /// Atualiza o número de séries de um exercício
  Future<void> updateExerciseSeries(int exerciseId, int series) async {
    try {
      final db = await database;
      await db.update(
        'workout_exercises',
        {'series': series},
        where: 'id = ?',
        whereArgs: [exerciseId],
      );
    } catch (e) {
      throw DatabaseAppException('Erro ao atualizar séries: $e');
    }
  }

  // ──────────────────────────────────────────────
  // DELETE
  // ──────────────────────────────────────────────

  /// Remove um treino e todos os seus exercícios (CASCADE)
  Future<void> deleteWorkout(int workoutId) async {
    try {
      final db = await database;
      await db.delete('workouts', where: 'id = ?', whereArgs: [workoutId]);
    } catch (e) {
      throw DatabaseAppException('Erro ao excluir treino: $e');
    }
  }

  /// Remove um exercício específico de um treino
  Future<void> deleteWorkoutExercise(int workoutExerciseId) async {
    try {
      final db = await database;
      await db.delete(
        'workout_exercises',
        where: 'id = ?',
        whereArgs: [workoutExerciseId],
      );
    } catch (e) {
      throw DatabaseAppException('Erro ao remover exercício: $e');
    }
  }
}
