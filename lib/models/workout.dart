// lib/models/workout.dart

/// Representa um exercício dentro de um treino, com número de séries
class WorkoutExercise {
  final int? id; // ID no banco local (null antes de salvar)
  final int workoutId;
  final int exerciseId;
  final String exerciseName;
  final int series;
  bool isSelected; // usado na tela de montagem do treino

  WorkoutExercise({
    this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.exerciseName,
    required this.series,
    this.isSelected = false,
  });

  WorkoutExercise copyWith({int? series, bool? isSelected}) {
    return WorkoutExercise(
      id: id,
      workoutId: workoutId,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      series: series ?? this.series,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'series': series,
    };
  }

  factory WorkoutExercise.fromMap(Map<String, dynamic> map) {
    return WorkoutExercise(
      id: map['id'] as int?,
      workoutId: map['workout_id'] as int,
      exerciseId: map['exercise_id'] as int,
      exerciseName: map['exercise_name'] as String,
      series: map['series'] as int,
    );
  }
}

/// Representa um treino criado pelo usuário
class Workout {
  final int? id;
  final String name;
  final DateTime createdAt;
  final List<WorkoutExercise> exercises;

  const Workout({
    this.id,
    required this.name,
    required this.createdAt,
    this.exercises = const [],
  });

  Workout copyWith({String? name, List<WorkoutExercise>? exercises}) {
    return Workout(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
